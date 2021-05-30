//
//  UIViewControllerExtension.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 29.05.2021.
//

import UIKit

extension UIViewController {
    
    func disable(views: UIControl...) {
        for view in views {
            view.isEnabled = false
        }
    }
    
    func activate(views: UIControl...) {
        for view in views {
            view.isEnabled = true
        }
    }
    
    func hide(view: UIView) {
        UIView.animate(withDuration: 0.5, animations: {
            view.alpha = 0
        }) { (finished) in
            view.isHidden = finished
        }
    }
    
    func show(view: UIView) {
        view.alpha = 0
        view.isHidden = false
        UIView.animate(withDuration: 0.6) {
            view.alpha = 1
        }
    }
    
    
    //MARK: To dismiss keyboard after tapping anywhere else
    
    func setupToHideKeyboardOnTapOnView() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard)
        )
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    //MARK: Alerts
    
    func successAlert(with message: String, action: @escaping () -> () = {}) {
        
        let allert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            action()
        }
        
        allert.addAction(okAction)
        present(allert, animated: true)
    }
    
    func attentionAlert(with message: String, action: @escaping () -> () = {}) {
        
        let allert = UIAlertController(title: "Attention!", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            action()
        }
        
        allert.addAction(okAction)
        present(allert, animated: true)
    }
    
    func errorAlert(with message: String, action: Optional<() -> ()> = nil ){
        
        let allert = UIAlertController(title: "Error occurred", message: message, preferredStyle: .alert)
        
        if let action = action {
            
            let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
                action()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            allert.addAction(retryAction)
            allert.addAction(cancelAction)
            
        } else {
            let okAction = UIAlertAction(title: "Ok", style: .default)
            allert.addAction(okAction)
        }
        
        
        present(allert, animated: true)
    }
    
}

