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
    @objc dynamic var token = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(_ user: UserWithToken) {
        self.init()
        self.id = user.id.uuidString
        self.name = user.name
        self.username = user.username
        self.email = user.email
        self.token = user.token
    }
}

struct POSTUser: Codable {
    let name: String
    let username: String
    let email: String
}

struct CreatedUser: Codable {
    let id: UUID
    let name: String
    let username: String
    let email: String
    let secret: String?
}

struct Username: Codable {
    var username: String
}

struct UserWithToken: Codable {
    let id: UUID
    let name: String
    let username: String
    let email: String
    let token: String
}
