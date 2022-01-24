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
    var interactor: VerificationInteractor!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.verificatioTitle
        codeField.properties.delegate = self
    }
    
    func pinField(_ field: KAPinField, didFinishWith code: String) {
        activityIndicator.startAnimating()
        disable(views: codeField)
        interactor.signIn(code: code) { [weak self] in
            self?.navigationController?.viewControllers.first?.dismiss(animated: true, completion: nil)
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.isAuthorized = true
        } errCompletion: { [weak self] message in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            self.errorAlert(with: message)
            self.activate(views: self.codeField)
        }
    }
}
