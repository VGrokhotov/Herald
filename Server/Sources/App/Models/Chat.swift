//
//  Chat.swift
//  
//
//  Created by Vladislav Grokhotov on 01.11.2022.
//

import Vapor
import Fluent

private enum Constants {
    
    static let chatsSchema = "chats"
    
    static let interlocutorId = "interlocutorId"
    static let interlocutorName = "interlocutorName"
    static let lastUpdated = "lastUpdated"
    static let messages = "messages"
    
    static let interlocutorIdKey = FieldKey(stringLiteral: Constants.interlocutorId)
    static let interlocutorNameKey = FieldKey(stringLiteral: Constants.interlocutorName)
    static let lastUpdatedKey = FieldKey(stringLiteral: Constants.lastUpdated)
    static let messagesKey = FieldKey(stringLiteral: Constants.messages)
}

final class Chat: Model, Content {
    
    // Name of the table or collection.
    static let schema = Constants.chatsSchema
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: Constants.interlocutorIdKey)
    var interlocutorId: UUID
    
    @Field(key: Constants.interlocutorNameKey)
    var interlocutorName: String
    
    @Field(key: Constants.lastUpdatedKey)
    var lastUpdated: Date
    
    @Field(key: Constants.messagesKey)
    var messages: [UUID]
    
    init() {}
    
    init(
        id: UUID? = nil,
        interlocutorId: UUID,
        interlocutorName: String,
        lastUpdated: Date,
        messages: [UUID]
    ) {
        self.id = id
        self.interlocutorId = interlocutorId
        self.interlocutorName = interlocutorName
        self.lastUpdated = lastUpdated
        self.messages = messages
    }
}

extension Chat {
    
    struct CreateMigration: Fluent.Migration {
        
        var name: String { "CreateChat" }
        
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.schema(Constants.chatsSchema)
                .id()
                .field(Constants.interlocutorIdKey, .uuid, .required)
                .field(Constants.interlocutorNameKey, .string, .required)
                .field(Constants.lastUpdatedKey, .date, .required)
                .field(Constants.messagesKey, .array(of: .uuid), .required)
                .create()
        }
        
        // Optionally reverts the changes made in the prepare method.
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema(Constants.chatsSchema).delete()
        }
    }
}
