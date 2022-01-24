//
//  SignInInteractor.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 02.06.2021.
//

import Foundation

class SignInInteractor {
    
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
