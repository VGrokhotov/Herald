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
import JWT

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
                req.application.jwt.signers.use(.hs256(key: secret))
                let payload = try req.jwt.verify(as: Payload.self)
                
                return payload.username
            })
            .throwingFlatMap({ username -> EventLoopFuture<UserToken> in
                return User.query(on: req.db)
                    .filter(\.$username == username)
                    .first()
                    .unwrap(or: Abort(.notFound, reason: "User does not exists"))
                    .throwingFlatMap( { user -> EventLoopFuture<UserToken> in
                        let token = try user.generateToken()
                        return token.create(on: req.db)
                            .map { token }
                    })
            }).map({ token in
                ["token" : token.value]
            })
            .encodeResponse(status: .accepted, for: req)
    }
    
}
