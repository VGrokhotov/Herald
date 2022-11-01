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
    static let interlocutorSurname = "interlocutorSurname"
    static let lastUpdated = "lastUpdated"
    static let messages = "messages"
}

final class Chat: Model, Content {
    
    // Name of the table or collection.
    static let schema = Constants.chatsSchema
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: FieldKey(stringLiteral: Constants.interlocutorId))
    var interlocutorId: UUID
    
    @Field(key: FieldKey(stringLiteral: Constants.interlocutorName))
    var interlocutorName: String
    
    @Field(key: FieldKey(stringLiteral: Constants.interlocutorSurname))
    var interlocutorSurname: String
    
    @Field(key: FieldKey(stringLiteral: Constants.lastUpdated))
    var lastUpdated: Date
    
    @Field(key: FieldKey(stringLiteral: Constants.messages))
    var messages: [UUID]
    
    init() {}
    
    init(
        id: UUID? = nil,
        interlocutorId: UUID,
        interlocutorName: String,
        interlocutorSurname: String,
        lastUpdated: Date,
        messages: [UUID]
    ) {
        self.id = id
        self.interlocutorId = interlocutorId
        self.interlocutorName = interlocutorName
        self.interlocutorSurname = interlocutorSurname
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
                .field(FieldKey(stringLiteral: Constants.interlocutorId), .uuid, .required)
                .field(FieldKey(stringLiteral: Constants.interlocutorName), .string, .required)
                .field(FieldKey(stringLiteral: Constants.interlocutorSurname), .string, .required)
                .field(FieldKey(stringLiteral: Constants.lastUpdated), .date, .required)
                .field(FieldKey(stringLiteral: Constants.messages), .array(of: .uuid), .required)
                .create()
        }
        
        // Optionally reverts the changes made in the prepare method.
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema(Constants.chatsSchema).delete()
        }
    }
}
