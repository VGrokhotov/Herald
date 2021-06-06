//
//  MainVM.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 29.05.2021.
//

import Foundation

class MainVM {
    func logout(
        completion: @escaping () -> (),
        errCompletion: @escaping (String) -> ()
    ) {
        guard let user = AuthManager.shared.user else {
            errCompletion(env.badMessage)
            return
        }
        let token = user.token
        AuthNetworkService.shared.logout(key: token, completion: { status in
            UserManager.shared.delete(user)
            let _ = AuthManager.shared.isAuthorized
            completion()
        }, errCompletion: errCompletion)
    }
}
