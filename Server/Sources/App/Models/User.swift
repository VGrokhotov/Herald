//
//  User.swift
//  
//
//  Created by Vladislav Grokhotov on 29.10.2022.
//

import Vapor
import Fluent

final class User: Model, Content {
    
    // Name of the table or collection.
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "secret")
    var secret: String?

    init() { }

    init(id: UUID? = nil, name: String, username: String, email: String, secret: String? = nil) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.secret = secret
    }
}

struct Username: Content {
    
    var username: String
}

extension User: Authenticatable {
    
    func generateToken() throws -> UserToken {
        try .init(
            value: [UInt8].random(count: 16).base64,
            userID: requireID()
        )
    }
}

extension User: Validatable {
    
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
    }
}

extension User {
    
    struct Migration: Fluent.Migration {
        
        var name: String { "CreateUser" }
        
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema("users")
                .id()
                .field("name", .string, .required)
                .field("username", .string, .required)
                .field("email", .string, .required)
                .field("secret", .string)
                .unique(on: "username")
                .create()
        }
        
        // Optionally reverts the changes made in the prepare method.
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema("users").delete()
        }
    }
}

struct UserWithToken: Content {
    
    let id: UUID
    let name: String
    let username: String
    let email: String
    let token: String
}
