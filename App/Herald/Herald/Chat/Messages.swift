//
//  Messages.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 29.05.2021.
//

import RealmSwift
import Foundation

class Messages: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var interlocutorID = ""
    var messages = List<Message>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
