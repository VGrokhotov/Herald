//
//  AuthController.swift
//  
//
//  Created by Vladislav Grokhotov on 29.10.2022.
//

import Vapor
import Fluent
import VaporSMTPKit
import SMTPKitten
import JWTKit

final class AuthController {
    
    func create(_ req: Request) async throws -> Response {
        try User.validate(content: req)
        
        let user = try req.content.decode(User.self)
        
        if let _ = try await User.query(on: req.db).filter(\.$username == user.username).first() {
            throw Abort(.badRequest, reason: "User with such username already exists")
        }
        
        try await user.create(on: req.db)
        
        return try await user.encodeResponse(status: .created, for: req)
    }
    
    func email(_ req: Request) async throws -> HTTPStatus  {
        let username = try req.content.decode(Username.self)
        
        guard let user = try await User.query(on: req.db).filter(\.$username == username.username).first() else {
            throw Abort(.notFound, reason: "User does not exists")
        }
        
        let credentials = try SMTPCredentials.getDefault()
        let secret = String(Int.random(in: 1000..<10000))
        
        user.secret = secret
        
        try await user.update(on: req.db)
        
        let email = Mail(
            from: "vladgrokhotov@gmail.com",
            to: [
                MailUser(name: user.name, email: user.email)
            ],
            subject: "Entering the account",
            contentType: .plain,
            text: "Your code for entering - \(user.secret!)"
        )
        
        return try await req.application.sendMail(email, withCredentials: credentials).transform(to: .noContent).get()
    }
    
    func signIn(_ req: Request) async throws -> Response {
        let username = try req.content.decode(Username.self)
        
        guard let jwt = req.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized)
        }
        
        guard let user = try await User.query(on: req.db).filter(\.$username == username.username).first() else {
            throw Abort(.notFound, reason: "User does not exists")
        }
        
        guard let secret = user.$secret.wrappedValue else {
            throw Abort(.conflict, reason: "User does not have secret")
        }
        
        let signers = JWTSigners()
        signers.use(.hs256(key: secret))
        
        let payload = try signers.verify(jwt, as: Payload.self)
        
        if payload.username != username.username {
            throw Abort(.conflict, reason: "JWT payload does not match with body username")
        }
        
        let token = try user.generateToken()
        
        guard let userId = user.id else {
            throw Abort(.internalServerError, reason: "No user ID")
        }
        
        try await token.create(on: req.db)
        
        let userWithToken = UserWithToken(
            id: userId,
            name: user.name,
            username: user.username,
            email: user.email,
            token: token.value
        )
        
        return try await userWithToken.encodeResponse(status: .accepted, for: req)
    }
    
    func logOut(_ req: Request) async throws -> HTTPStatus {
        try req.auth.require(User.self)
        
        guard let token = req.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized, reason: "No bearerAuthorization")
        }
        
        guard let userToken = try await UserToken.query(on: req.db).filter(\.$value == token).first() else {
            throw Abort(.unauthorized, reason: "No such token in DB")
        }
        
        return try await userToken.delete(on: req.db).transform(to: .noContent).get()
    }
}
