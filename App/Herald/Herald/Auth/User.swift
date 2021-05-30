//
//  User.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 30.05.2021.
//

import RealmSwift
import Foundation

class User: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var username = ""
    @objc dynamic var email = ""
    @objc dynamic var secret = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
