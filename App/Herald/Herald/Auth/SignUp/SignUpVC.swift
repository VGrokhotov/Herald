//
//  SignUpVC.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 01.06.2021.
//

import UIKit

class SignUpVC: UIViewController {

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    let viewModel = SignUpVM()
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        guard
            let name = nameTextField.text,
            let username = usernameTextField.text,
            let email = emailTextField.text
        else { return }
        
        viewModel.signUp(name: name, username: username, email: email, completion: {
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupToHideKeyboardOnTapOnView()
        
        nameTextField.delegate = self
        usernameTextField.delegate = self
        emailTextField.delegate = self
        
        nameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(validateEmail), for: .editingChanged)
        
        disable(views: signUpButton)
    }

}

// MARK: - Text field delegate

extension SignUpVC: UITextFieldDelegate {
    
    @objc private func textFieldChanged() {
        if areFieldsEmpty()  {
            disable(views: signUpButton)
        } else {
            activate(views: signUpButton)
        }
    }
    
    @objc private func validateEmail() {
        if let email = emailTextField.text, email.isValidEmail() {
            activate(views: signUpButton)
            UIView.animate(withDuration: 0.4) {
                self.emailTextField.backgroundColor = .white
            }
        } else {
            disable(views: signUpButton)
            UIView.animate(withDuration: 0.4) {
                self.emailTextField.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.4380432533)
            }
        }
    }
    
    func areFieldsEmpty() -> Bool {
        return nameTextField.text?.isEmpty ?? true || usernameTextField.text?.isEmpty ?? true || emailTextField.text?.isEmpty ?? true
    }
    
}
