//
//  Interlocutor.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 29.05.2021.
//

import RealmSwift
import Foundation

class Interlocutor: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var secondName = ""
    @objc dynamic var lastMessage = ""
    @objc dynamic var lastMessageTime = Date()
    @objc dynamic var messagesID = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
