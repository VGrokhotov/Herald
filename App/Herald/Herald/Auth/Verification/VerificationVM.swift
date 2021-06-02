//
//  VerificationVM.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 02.06.2021.
//

import Foundation
import JWTKit

class VerificationVM {
    
    var username: String!
    
    func signIn(
        code: String,
        completion: @escaping () -> (),
        errCompletion: @escaping (String) -> ()
    ) {
        let usernameOnject = Username(username: username)
        let signers = JWTSigners()
        signers.use(.hs256(key: code))
        let payload = Payload(username: username, expiration: .init(value: .distantFuture))
        guard let jwt = try? signers.sign(payload) else { return }
        AuthNetworkService.shared.signIn(with: usernameOnject, key: jwt, completion: { userWithToken in
            let userToSave = User(userWithToken)
            UserManager.shared.save(userToSave)
            completion()
        }, errCompletion: errCompletion)
    }
}
