//
//  MainVC.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 29.05.2021.
//

import UIKit
import RealmSwift

class MainVC: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let viewModel = MainVM()
    
    var sideMenuVC: SideMenuVC!
    var isExpanded: Bool = false
    var sideMenuTrailingConstraint: NSLayoutConstraint!
    var revealSideMenuOnTop: Bool = true
    var sideMenuShadowView: UIView!
    var draggingIsEnabled: Bool = false
    var panBaseLocation: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSideMenu()
    }
    
    func logout() {
        activityIndicator.startAnimating()
        viewModel.logout { [weak self] in
            self?.activityIndicator.stopAnimating()
            guard let window = UIApplication.shared.windows.first else { return }
            self?.dismiss(animated: true, completion: nil)
            window.rootViewController = AuthPreviewVC()
            window.makeKeyAndVisible()
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        } errCompletion: { [weak self] message in
            self?.activityIndicator.stopAnimating()
            self?.errorAlert(with: message)
        }
    }

}
