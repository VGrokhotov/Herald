//
//  SignUpInteractor.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 01.06.2021.
//

import Foundation

class SignUpInteractor {
    
    func signUp(
        name: String,
        username: String,
        email: String,
        completion: @escaping (CreatedUser) -> (),
        errCompletion: @escaping (String) -> ()
    ) {
        let user = POSTUser(name: name, username: username, email: email)
        AuthGateway.shared.signUp(with: user, completion: completion, errCompletion: errCompletion)
    }
    
    func sendEmail(
        username: String,
        completion: @escaping (Int) -> (),
        errCompletion: @escaping (String) -> ()
    ) {
        let usernameOnject = Username(username: username)
        AuthGateway.shared.email(with: usernameOnject, completion: completion, errCompletion: errCompletion)
    }
    
    func createVerificationVM(username: String) -> VerificationInteractor {
        return VerificationInteractor(username: username)
    }
}
