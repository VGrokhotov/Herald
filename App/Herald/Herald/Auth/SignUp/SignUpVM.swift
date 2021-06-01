//
//  SignUpVM.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 01.06.2021.
//

import Foundation

class SignUpVM {
    
    func signUp(name: String, username: String, email: String, completion: @escaping () -> ()) {
        let user = POSTUser(name: name, username: username, email: email)
        print(user)
        AuthNetworkManager.shared.signUp(with: user, completion: completion)
    }
}
