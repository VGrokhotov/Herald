//
//  UserGateway.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 30.05.2021.
//

import RealmSwift

class UserGateway {
    
    private init() {}
    static let shared = UserGateway()
    
    private var realm = try! Realm()
    
    func save(_ user: User) {
        try! realm.write {
            realm.add(user)
        }
    }
    
    func delete(_ user: User) {
        try! realm.write({
            realm.delete(user)
        })
    }
    
    func get() -> User? {
        return realm.objects(User.self).first
    }
}
