//
//  VerificationVC.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 02.06.2021.
//

import UIKit
import KAPinField

class VerificationVC: UIViewController, KAPinFieldDelegate {
    
    @IBOutlet var codeField: KAPinField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var viewModel: VerificationVM!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Почти готово!"
        codeField.properties.delegate = self
    }
    
    func pinField(_ field: KAPinField, didFinishWith code: String) {
        activityIndicator.startAnimating()
        disable(views: codeField)
        viewModel.signIn(code: code) { [weak self] in
            print("ahahahaah")
            self?.activityIndicator.stopAnimating()
        } errCompletion: { [weak self] message in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            self.errorAlert(with: message)
            self.activate(views: self.codeField)
        }

    }
    

}
