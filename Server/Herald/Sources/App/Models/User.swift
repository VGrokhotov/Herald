//
//  User.swift
//  
//
//  Created by Vladislav Grokhotov on 19.05.2021.
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

    init() { }

    init(id: UUID? = nil, name: String, username: String, email: String) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
    }
}

struct CreateUser: Migration {
    // Prepares the database for storing Galaxy models.
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .id()
            .field("name", .string, .required)
            .field("username", .string, .required, .identifier(auto: false))
            .field("email", .string, .required)
            .unique(on: "username")
            .update()
    }

    // Optionally reverts the changes made in the prepare method.
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
