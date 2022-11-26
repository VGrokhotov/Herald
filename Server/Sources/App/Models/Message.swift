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
    
    static let senderIdKey = FieldKey(stringLiteral: Constants.senderId)
    static let contentKey = FieldKey(stringLiteral: Constants.content)
    static let contentTypeKey = FieldKey(stringLiteral: Constants.contentType)
    static let createdKey = FieldKey(stringLiteral: Constants.created)
    static let fileSizeKey = FieldKey(stringLiteral: Constants.fileSize)
    static let fileNameKey = FieldKey(stringLiteral: Constants.fileName)
    
    static let contentTypeEnumName = "ContentType"
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
    
    @Field(key: Constants.senderIdKey)
    var senderId: UUID
    
    @Field(key: Constants.contentKey)
    var content: Data
    
    @Enum(key: Constants.contentTypeKey)
    var contentType: ContentType
    
    @Field(key: Constants.createdKey)
    var created: Date
    
    @Field(key: Constants.fileSizeKey)
    var fileSize: Int?
    
    @Field(key: Constants.fileNameKey)
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
            return database.enum(Constants.contentTypeEnumName)
                .case(Constants.text)
                .case(Constants.image)
                .case(Constants.file)
                .case(Constants.unknown)
                .create()
                .flatMap { enumDataType in
                    return database.schema(Constants.messagesSchema)
                        .id()
                        .field(Constants.senderIdKey, .string, .required)
                        .field(Constants.contentKey, .data, .required)
                        .field(Constants.contentTypeKey, enumDataType, .required)
                        .field(Constants.createdKey, .date, .required)
                        .field(Constants.fileSizeKey, .int)
                        .field(Constants.fileNameKey, .string)
                        .create()
                }
        }
        
        // Optionally reverts the changes made in the prepare method.
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema(Constants.messagesSchema).delete()
        }
    }
}
