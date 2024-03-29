//
//  UIViewController+Utility.swift
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
    
    func disable(buttons: UIButton...) {
        for button in buttons {
            button.isEnabled = false
            UIView.animate(withDuration: 0.4) {
                button.titleLabel?.textColor = .lightGray
            }
        }
    }
    
    func activate(views: UIControl...) {
        for view in views {
            view.isEnabled = true
        }
    }
    
    func activate(buttons: UIButton...) {
        for button in buttons {
            button.isEnabled = true
            UIView.animate(withDuration: 0.4) {
                button.titleLabel?.textColor = .black
            }
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
        
        let allert = UIAlertController(title: Strings.success, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Strings.ok, style: .default) { _ in
            action()
        }
        
        allert.addAction(okAction)
        present(allert, animated: true)
    }
    
    func attentionAlert(with message: String, action: @escaping () -> () = {}) {
        
        let allert = UIAlertController(title: Strings.attention, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Strings.ok, style: .default) { _ in
            action()
        }
        
        allert.addAction(okAction)
        present(allert, animated: true)
    }
    
    func errorAlert(with message: String, action: Optional<() -> ()> = nil ){
        
        let allert = UIAlertController(title: Strings.error, message: message, preferredStyle: .alert)
        
        if let action = action {
            
            let retryAction = UIAlertAction(title: Strings.retry, style: .default) { _ in
                action()
            }
            
            let cancelAction = UIAlertAction(title: Strings.cancel, style: .cancel)
            
            allert.addAction(retryAction)
            allert.addAction(cancelAction)
            
        } else {
            let okAction = UIAlertAction(title: Strings.ok, style: .default)
            allert.addAction(okAction)
        }
        
        
        present(allert, animated: true)
    }
    
}

