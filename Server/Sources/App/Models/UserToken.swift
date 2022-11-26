//
//  UserToken.swift
//  
//
//  Created by Vladislav Grokhotov on 29.10.2022.
//

import Fluent
import Vapor

private enum Constants {
    
    static let userTokenSchema = "user_tokens"
    static let usersSchema = "users"
    
    static let value = "value"
    static let userId = "user_id"
    static let id = "id"
    
    static let valueKey = FieldKey(stringLiteral: Constants.value)
    static let userIdKey = FieldKey(stringLiteral: Constants.userId)
    static let idKey = FieldKey(stringLiteral: Constants.id)
}

final class UserToken: Model, Content {
    
    static let schema = Constants.userTokenSchema

    @ID(key: .id)
    var id: UUID?

    @Field(key: Constants.valueKey)
    var value: String

    @Parent(key: Constants.userIdKey)
    var user: User

    init() {}

    init(id: UUID? = nil, value: String, userId: User.IDValue) {
        self.id = id
        self.value = value
        self.$user.id = userId
    }
}

extension UserToken {
    
    struct Migration: Fluent.Migration {
        
        var name: String { "CreateUserToken" }

        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema(Constants.userTokenSchema)
                .id()
                .field(Constants.valueKey, .string, .required)
                .field(Constants.userIdKey, .uuid, .required, .references(Constants.usersSchema, Constants.idKey))
                .unique(on: Constants.valueKey)
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema(Constants.userTokenSchema).delete()
        }
    }
}

extension UserToken: ModelTokenAuthenticatable {
    
    static let valueKey = \UserToken.$value
    static let userKey = \UserToken.$user

    var isValid: Bool {
        true
    }
}

