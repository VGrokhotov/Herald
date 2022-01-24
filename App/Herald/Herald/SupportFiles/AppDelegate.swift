//
//  AppDelegate.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 29.05.2021.
//

import UIKit
import FontBlaster
import IQKeyboardManagerSwift
import Localizer

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    override init() {
        super.init()
        FontBlaster.blast()
        UIFont.overrideInitialize()
    }
    
    var isAuthorized = false {
        didSet {
            guard let window = window else { return }
            AuthManager.shared.getUser()
            if isAuthorized {
                window.rootViewController = MainVC()
            } else {
                window.rootViewController = AuthPreviewVC()
            }
            window.makeKeyAndVisible()
            
            UIView.transition(with: window, duration: 0.7, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        
        Localizer.default = .ru
        
        AuthManager.shared.getUser()
        if let _ = AuthManager.shared.user {
            isAuthorized = true
        } else {
            isAuthorized = false
        }
        
        IQKeyboardManager.shared.enable = true
        
        return true
    }
}
