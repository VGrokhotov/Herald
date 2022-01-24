//
//  VerificationInteractor.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 02.06.2021.
//

import Foundation
import JWTKit

class VerificationInteractor {
    
    private var username: String
    
    init(username: String) {
        self.username = username
    }
    
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
        AuthGateway.shared.signIn(with: usernameOnject, key: jwt, completion: { userWithToken in
            let userToSave = User(userWithToken)
            UserGateway.shared.save(userToSave)
            completion()
        }, errCompletion: errCompletion)
    }
}
