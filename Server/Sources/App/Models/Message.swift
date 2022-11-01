//
//  Message.swift
//  
//
//  Created by Vladislav Grokhotov on 01.11.2022.
//

import Vapor
import Fluent

enum ContentType: String, Codable {
    
    case text = "text"
    case image = "image"
    case file = "file"
    case unknown = "unknown"
}

private enum Constants {
    
    static let messagesSchema = "messages"
    
    static let senderId = "senderId"
    static let content = "content"
    static let contentType = "contentType"
    static let created = "created"
    static let fileSize = "fileSize"
    static let fileName = "fileName"
    
    static let text = "text"
    static let image = "image"
    static let file = "file"
    static let unknown = "unknown"
}

final class Message: Model, Content {
    
    // Name of the table or collection.
    static let schema = Constants.messagesSchema
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: FieldKey(stringLiteral: Constants.senderId))
    var senderId: UUID
    
    @Field(key: FieldKey(stringLiteral: Constants.content))
    var content: Data
    
    @Enum(key: FieldKey(stringLiteral: Constants.contentType))
    var contentType: ContentType
    
    @Field(key: FieldKey(stringLiteral: Constants.created))
    var created: Date
    
    @Field(key: FieldKey(stringLiteral: Constants.fileSize))
    var fileSize: Int?
    
    @Field(key: FieldKey(stringLiteral: Constants.fileName))
    var fileName: String?
    
    init() {}
    
    init(
        id: UUID? = nil,
        senderId: UUID,
        content: Data,
        contentType: ContentType,
        created: Date,
        fileSize: Int? = nil,
        fileName: String? = nil
    ) {
        self.id = id
        self.senderId = senderId
        self.content = content
        self.contentType = contentType
        self.created = created
        self.fileSize = fileSize
        self.fileName = fileName
    }
}

extension Message {
    
    struct CreateMigration: Fluent.Migration {
        
        var name: String { "CreateMessage" }
        
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.enum("ContentType")
                .case("text")
                .case("image")
                .case("file")
                .case("unknown")
                .create()
                .flatMap { enumDataType in
                    return database.schema(Constants.messagesSchema)
                        .id()
                        .field(FieldKey(stringLiteral: Constants.senderId), .string, .required)
                        .field(FieldKey(stringLiteral: Constants.content), .data, .required)
                        .field(FieldKey(stringLiteral: Constants.contentType), enumDataType, .required)
                        .field(FieldKey(stringLiteral: Constants.created), .date, .required)
                        .field(FieldKey(stringLiteral: Constants.fileSize), .int)
                        .field(FieldKey(stringLiteral: Constants.fileName), .string)
                        .create()
                }
        }
        
        // Optionally reverts the changes made in the prepare method.
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema(Constants.messagesSchema).delete()
        }
    }
}
