//
//  SignUpVM.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 01.06.2021.
//

import Foundation

class SignUpVM {
    
    func signUp(
        name: String,
        username: String,
        email: String,
        completion: @escaping (CreatedUser) -> (),
        errCompletion: @escaping (String) -> ()
    ) {
        let user = POSTUser(name: name, username: username, email: email)
        AuthNetworkService.shared.signUp(with: user, completion: completion, errCompletion: errCompletion)
    }
    
    func sendEmail(
        username: String,
        completion: @escaping (Int) -> (),
        errCompletion: @escaping (String) -> ()
    ) {
        let usernameOnject = Username(username: username)
        AuthNetworkService.shared.email(with: usernameOnject, completion: completion, errCompletion: errCompletion)
    }
    
    func createVerificationVM(username: String) -> VerificationVM {
        let vm = VerificationVM()
        vm.username = username
        return vm
    }
}
