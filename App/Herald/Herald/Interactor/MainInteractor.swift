//
//  MainInteractor.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 29.05.2021.
//

import Foundation

class MainInteractor {
    func logout(
        completion: @escaping () -> (),
        errCompletion: @escaping (String) -> ()
    ) {
        guard let user = AuthManager.shared.user else {
            errCompletion(env.badMessage)
            return
        }
        let token = user.token
        AuthGateway.shared.logout(key: token, completion: { status in
            UserGateway.shared.delete(user)
            completion()
        }, errCompletion: errCompletion)
    }
}
