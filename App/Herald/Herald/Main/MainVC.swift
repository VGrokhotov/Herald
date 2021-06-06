//
//  MainVC.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 29.05.2021.
//

import UIKit
import RealmSwift

class MainVC: UIViewController {

    @IBOutlet weak var logoutButton: LoadingButton!
    
    let viewModel = MainVM()
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        
        logoutButton.showLoading()
        viewModel.logout { [weak self] in
            self?.logoutButton.hideLoading()
            guard let window = UIApplication.shared.windows.first else { return }
            self?.dismiss(animated: true, completion: nil)
            window.rootViewController = AuthPreviewVC()
            window.makeKeyAndVisible()
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        } errCompletion: { [weak self] message in
            self?.logoutButton.hideLoading()
            self?.errorAlert(with: message)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

}
