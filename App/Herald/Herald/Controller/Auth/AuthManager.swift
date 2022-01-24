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
    
    func getUser() {
        if let user = UserGateway.shared.get() {
            self.user = user
            return
        }
        
        user = nil
    }
}
