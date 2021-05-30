//
//  AppDelegate.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 29.05.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        if AuthManager.shared.isAuthorized {
            window?.rootViewController = MainVC()
        } else {
            window?.rootViewController = AuthVC()
        }
        window?.makeKeyAndVisible()
        
        return true
    }

}

