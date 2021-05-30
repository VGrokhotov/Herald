//
//  Message.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 29.05.2021.
//

import RealmSwift
import Foundation

class Message: Object {
    @objc dynamic var id = ""
    @objc dynamic var type = ""
    @objc dynamic var content = Data()
    @objc dynamic var time = Date()
    @objc dynamic var interlocutorID = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
