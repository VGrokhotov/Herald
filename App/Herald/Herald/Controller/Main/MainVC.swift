//
//  MainVC.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 29.05.2021.
//

import UIKit
import RealmSwift

class MainVC: UIViewController, EmptyDataRepresentable {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let interactor = MainInteractor()
    
    var emptyDataView: EmptyDataView? = BaseEmptyDataView()
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
        
        setupEmptyDataView()
        
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.activityIndicator.stopAnimating()
            self.showEmptyDataView()
        }
    }
    
    func logout() {
        activityIndicator.startAnimating()
        interactor.logout { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.dismiss(animated: true, completion: nil)
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.isAuthorized = false
        } errCompletion: { [weak self] message in
            self?.activityIndicator.stopAnimating()
            self?.errorAlert(with: message)
        }
    }
}
