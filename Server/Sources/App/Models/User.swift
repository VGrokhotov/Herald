//
//  User.swift
//  
//
//  Created by Vladislav Grokhotov on 29.10.2022.
//

import Vapor
import Fluent

private enum Constants {
    
    static let usersSchema = "users"
    
    static let name = "name"
    static let username = "username"
    static let email = "email"
    static let secret = "secret"
    
    static let nameKey = FieldKey(stringLiteral: Constants.name)
    static let usernameKey = FieldKey(stringLiteral: Constants.username)
    static let emailKey = FieldKey(stringLiteral: Constants.email)
    static let secretKey = FieldKey(stringLiteral: Constants.secret)
}

final class User: Model, Content {
    
    // Name of the table or collection.
    static let schema = Constants.usersSchema

    @ID(key: .id)
    var id: UUID?

    @Field(key: Constants.nameKey)
    var name: String
    
    @Field(key: Constants.usernameKey)
    var username: String
    
    @Field(key: Constants.emailKey)
    var email: String
    
    @Field(key: Constants.secretKey)
    var secret: String?

    init() {}

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

struct SearchUser: Content {
    
    var username: String
    var name: String
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
        validations.add(ValidationKey(stringLiteral: Constants.email), as: String.self, is: .email)
    }
}

extension User {
    
    struct Migration: Fluent.Migration {
        
        var name: String { "CreateUser" }
        
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema(Constants.usersSchema)
                .id()
                .field(Constants.nameKey, .string, .required)
                .field(Constants.usernameKey, .string, .required)
                .field(Constants.emailKey, .string, .required)
                .field(Constants.secretKey, .string)
                .unique(on: Constants.usernameKey)
                .create()
        }
        
        // Optionally reverts the changes made in the prepare method.
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema(Constants.usersSchema).delete()
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
