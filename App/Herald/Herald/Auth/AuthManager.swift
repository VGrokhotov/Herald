//
//  AuthManager.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 30.05.2021.
//

import Foundation

class AuthManager {
    
    private init(){}
    public static let shared = AuthManager()
    
    var user: User?
    
    var isAuthorized: Bool {
        if let user = UserManager.shared.get() {
            self.user = user
            return true
        }
        user = nil
        return false
    }
    
    
    
}
