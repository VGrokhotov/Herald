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
        present(SignUpVC(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
