//
//  SignInVC.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 01.06.2021.
//

import UIKit

class SignInVC: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var enterButton: LoadingButton!
    
    var interactor = SignInInteractor()
    
    @IBAction func enterButtonPressed(_ sender: Any) {
        guard let username = usernameTextField.text else { return }
        
        enterButton.showLoading()
        interactor.sendEmail(username: username, completion: { [weak self] status in
            self?.enterButton.hideLoading()
            let vc = VerificationVC()
            vc.interactor = self?.interactor.createVerificationVM(username: username)
            self?.navigationController?.pushViewController(vc, animated: true)
            self?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }, errCompletion: {  [weak self] message in
            self?.enterButton.hideLoading()
            self?.errorAlert(with: message)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupToHideKeyboardOnTapOnView()
        
        usernameTextField.delegate = self
        
        usernameTextField.addTarget(self, action: #selector(textFieldChanged), for: .allEditingEvents)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        disable(buttons: enterButton)
    }
}

// MARK: - Text field delegate

extension SignInVC: UITextFieldDelegate {
    
    @objc private func textFieldChanged() {
        if usernameTextField.text?.isEmpty ?? true  {
            disable(buttons: enterButton)
        } else {
            activate(buttons: enterButton)
        }
    }
}
