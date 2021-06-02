//
//  SignInVM.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 02.06.2021.
//

import Foundation

class SignInVM {
    
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
