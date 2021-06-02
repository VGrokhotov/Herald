//
//  AuthController.swift
//  
//
//  Created by Vladislav Grokhotov on 19.05.2021.
//

import Vapor
import Fluent
import VaporSMTPKit
import SMTPKitten
import JWTKit

final class AuthController {
    
    //MARK: POST
    
    func create(_ req: Request) throws -> EventLoopFuture<Response> {
        try User.validate(content: req)
        let user = try req.content.decode(User.self)
        
        return User.query(on: req.db)
            .filter(\.$username == user.username)
            .first()
            .throwingFlatMap { foundUser in
                if let _ = foundUser {
                    throw Abort(.badRequest, reason: "User with such username already exists")
                } else {
                    return user.create(on: req.db)
                        .map { user }
                        .encodeResponse(status: .created, for: req)
                }
            }
    }
    
    func email(_ req: Request) throws -> EventLoopFuture<HTTPStatus>  {
        let username = try req.content.decode(Username.self)
        
        return User.query(on: req.db)
            .filter(\.$username == username.username)
            .first()
            .unwrap(or: Abort(.notFound, reason: "User does not exists"))
            .flatMap({ user -> EventLoopFuture<User> in
                let secret = String(Int.random(in: 1000..<10000))
                user.secret = secret
                return user.update(on: req.db).map{user }
            })
            .flatMap { user in
                let email = Mail(
                    from: "vladgrokhotov@gmail.com",
                    to: [
                        MailUser(name: user.name, email: "vlad@grokhotov.ru")
                    ],
                    subject: "Entering the account",
                    contentType: .plain,
                    text: "Your code for entering - \(user.secret!)"
                )
                
                return req.application.sendMail(email, withCredentials: .default).transform(to: .noContent)
            }
    }
    
    func signin(_ req: Request) throws -> EventLoopFuture<Response> {
        let username = try req.content.decode(Username.self)
        
        return User.query(on: req.db)
            .filter(\.$username == username.username)
            .first()
            .unwrap(or: Abort(.notFound, reason: "User does not exists"))
            .map { user -> String? in
                user.$secret.wrappedValue
            }
            .unwrap(or: Abort(.conflict, reason: "User does not have secret"))
            .flatMapThrowing({ secret -> String in
                let signers = JWTSigners()
                signers.use(.hs256(key: secret))
                guard let jwt = req.headers.bearerAuthorization?.token else {
                    throw Abort(.unauthorized)
                }
                let payload = try signers.verify(jwt, as: Payload.self)
                
                return payload.username
            })
            .throwingFlatMap({ username -> EventLoopFuture<UserWithToken> in
                return User.query(on: req.db)
                    .filter(\.$username == username)
                    .first()
                    .unwrap(or: Abort(.notFound, reason: "User does not exists"))
                    .throwingFlatMap( { user -> EventLoopFuture<UserWithToken> in
                        let token = try user.generateToken()
                        guard let userId = user.id else { throw Abort(.internalServerError, reason: "No user ID")}
                        return token.create(on: req.db).map {
                            UserWithToken(
                                id: userId,
                                name: user.name,
                                username: user.username,
                                email: user.email,
                                token: token.value)
                        }
                    })
            })
            .encodeResponse(status: .accepted, for: req)
    }
    
}
