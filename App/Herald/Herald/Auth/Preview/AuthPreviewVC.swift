//
//  AuthPreviewVC.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 30.05.2021.
//

import UIKit

class AuthPreviewVC: UIViewController {
    
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        present(SignInVC(), animated: true)
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        let navigationController = UINavigationController()
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24)]
        let signUpVc = SignUpVC()
        signUpVc.title = "Создаем аккаунт"
        navigationController.setViewControllers([signUpVc], animated: false)
        present(navigationController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
