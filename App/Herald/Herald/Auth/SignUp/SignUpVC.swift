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
    @IBOutlet weak var signUpButton: LoadingButton!
    
    let viewModel = SignUpVM()
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        guard
            let name = nameTextField.text,
            let username = usernameTextField.text,
            let email = emailTextField.text
        else { return }
        
        signUpButton.showLoading()
        viewModel.signUp(name: name, username: username, email: email, completion: { [weak self] newUser in
            self?.viewModel.sendEmail(username: newUser.username, completion: { [weak self] status in
                self?.signUpButton.hideLoading()
                let vc = VerificationVC()
                vc.viewModel = self?.viewModel.createVerificationVM(username: newUser.username)
                self?.navigationController?.pushViewController(vc, animated: true)
                self?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            }, errCompletion: {  [weak self] message in
                self?.signUpButton.hideLoading()
                self?.errorAlert(with: message)
            })
        }, errCompletion: { [weak self] message in
            self?.signUpButton.hideLoading()
            self?.errorAlert(with: message)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupToHideKeyboardOnTapOnView()
        
        nameTextField.delegate = self
        usernameTextField.delegate = self
        emailTextField.delegate = self
        
        nameTextField.addTarget(self, action: #selector(textFieldChanged), for: .allEditingEvents)
        usernameTextField.addTarget(self, action: #selector(textFieldChanged), for: .allEditingEvents)
        emailTextField.addTarget(self, action: #selector(validateEmail), for: .allEditingEvents)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        disable(buttons: signUpButton)
    }

}

// MARK: - Text field delegate

extension SignUpVC: UITextFieldDelegate {
    
    @objc private func textFieldChanged() {
        if areFieldsNotCorrect()  {
            disable(buttons: signUpButton)
        } else {
            activate(buttons: signUpButton)
        }
    }
    
    @objc private func validateEmail() {
        textFieldChanged()
        if let email = emailTextField.text, email.isValidEmail() {
            UIView.animate(withDuration: 0.4) {
                self.emailTextField.backgroundColor = .white
            }
        } else {
            UIView.animate(withDuration: 0.4) {
                self.emailTextField.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.4380432533)
            }
        }
    }
    
    func areFieldsNotCorrect() -> Bool {
        return nameTextField.text?.isEmpty ?? true || usernameTextField.text?.isEmpty ?? true || emailTextField.text?.isEmpty ?? true || !(emailTextField.text?.isValidEmail() ?? false)
    }
    
}
