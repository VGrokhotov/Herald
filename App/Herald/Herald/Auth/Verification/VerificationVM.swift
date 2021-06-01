//
//  VerificationVM.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 02.06.2021.
//

import Foundation

class VerificationVM {
    
    func signIn(
        username: String,
        completion: @escaping (CreatedUser) -> (),
        errCompletion: @escaping (String) -> ()
    ) {
        
        let usernameOnject = Username(username: username)
        let key = "lol"
//        AuthNetworkService.shared.sugnIn(with: usernameOnject, key: key, completion: completion, errCompletion: errCompletion)
    }
}
