//
//  MainVCWithSideMenuExtetion.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 29.06.2021.
//

import UIKit

extension MainVC: SideMenuVCDelegate {
    
    static var sideMenuRevealWidth: CGFloat = 250
    static let paddingForRotation: CGFloat = 150
    
    func configureSideMenu() {
        sideMenuVC = SideMenuVC()
        sideMenuVC.delegate = self
        view.insertSubview(sideMenuVC.view, at: revealSideMenuOnTop ? 2 : 0)
        addChild(sideMenuVC)
        sideMenuVC.didMove(toParent: self)
        
        sideMenuVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        if revealSideMenuOnTop {
            sideMenuTrailingConstraint = sideMenuVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -MainVC.sideMenuRevealWidth - MainVC.paddingForRotation)
            sideMenuTrailingConstraint.isActive = true
        }
        NSLayoutConstraint.activate([
            sideMenuVC.view.widthAnchor.constraint(equalToConstant: MainVC.sideMenuRevealWidth),
            sideMenuVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sideMenuVC.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        sideMenuShadowView = UIView(frame: view.bounds)
        sideMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sideMenuShadowView.backgroundColor = .black
        sideMenuShadowView.alpha = 0.0
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapGestureRecognizer))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
        if revealSideMenuOnTop {
            view.insertSubview(sideMenuShadowView, at: 1)
        }
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    func selectedCell(_ row: Int) {
        switch row {
        case 0:
            // Profile
            print("P")
        case 1:
            // Settings
            print("P")
        case 2:
            logout()
        default:
            break
        }
        
        // Collapse side menu with animation
        DispatchQueue.main.async { self.sideMenuState(expanded: false) }
    }
    
    func sideMenuState(expanded: Bool) {
        if expanded {
            animateSideMenu(targetPosition: revealSideMenuOnTop ? 0 : MainVC.sideMenuRevealWidth) { _ in
                self.isExpanded = true
            }
            // Animate Shadow (Fade In)
            UIView.animate(withDuration: 0.5) { self.sideMenuShadowView.alpha = 0.6 }
        }
        else {
            animateSideMenu(targetPosition: self.revealSideMenuOnTop ? (-MainVC.sideMenuRevealWidth - MainVC.paddingForRotation) : 0) { _ in
                self.isExpanded = false
            }
            // Animate Shadow (Fade Out)
            UIView.animate(withDuration: 0.5) { self.sideMenuShadowView.alpha = 0.0 }
        }
    }
    
    func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint.constant = targetPosition
                self.view.layoutIfNeeded()
            }
            else {
                self.view.subviews[1].frame.origin.x = targetPosition
            }
        }, completion: completion)
    }
}



extension MainVC: UIGestureRecognizerDelegate {
    @objc func TapGestureRecognizer(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if isExpanded {
                sideMenuState(expanded: false)
            }
        }
    }

    // Close side menu when you tap on the shadow background view
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: sideMenuVC.view))! {
            return false
        }
        return true
    }
    
    // Dragging Side Menu
    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        
        let position: CGFloat = sender.translation(in: view).x
        let velocity: CGFloat = sender.velocity(in: view).x
        
        switch sender.state {
        case .began:
            
            // If the user tries to expand the menu more than the reveal width, then cancel the pan gesture
            if velocity > 0, isExpanded {
                sender.state = .cancelled
            }
            
            // If the user swipes right but the side menu hasn't expanded yet, enable dragging
            if velocity > 0, !isExpanded {
                draggingIsEnabled = true
            }
            // If user swipes left and the side menu is already expanded, enable dragging they collapsing the side menu)
            else if velocity < 0, isExpanded {
                draggingIsEnabled = true
            }
            
            if draggingIsEnabled {
                // If swipe is fast, Expand/Collapse the side menu with animation instead of dragging
                let velocityThreshold: CGFloat = 550
                if abs(velocity) > velocityThreshold {
                    sideMenuState(expanded: isExpanded ? false : true)
                    draggingIsEnabled = false
                    return
                }
                
                if revealSideMenuOnTop {
                    panBaseLocation = 0.0
                    if isExpanded {
                        panBaseLocation = MainVC.sideMenuRevealWidth
                    }
                }
            }
            
        case .changed:
            
            // Expand/Collapse side menu while dragging
            if draggingIsEnabled {
                if revealSideMenuOnTop {
                    // Show/Hide shadow background view while dragging
                    let xLocation: CGFloat = panBaseLocation + position
                    let percentage = (xLocation * 150 / MainVC.sideMenuRevealWidth) / MainVC.sideMenuRevealWidth
                    
                    let alpha = percentage >= 0.6 ? 0.6 : percentage
                    sideMenuShadowView.alpha = alpha
                    
                    // Move side menu while dragging
                    if xLocation <= MainVC.sideMenuRevealWidth {
                        sideMenuTrailingConstraint.constant = xLocation - MainVC.sideMenuRevealWidth
                    }
                }
                else {
                    if let recogView = sender.view?.subviews[1] {
                        // Show/Hide shadow background view while dragging
                        let percentage = (recogView.frame.origin.x * 150 / MainVC.sideMenuRevealWidth) / MainVC.sideMenuRevealWidth
                        
                        let alpha = percentage >= 0.6 ? 0.6 : percentage
                        sideMenuShadowView.alpha = alpha
                        
                        // Move side menu while dragging
                        if recogView.frame.origin.x <= MainVC.sideMenuRevealWidth, recogView.frame.origin.x >= 0 {
                            recogView.frame.origin.x = recogView.frame.origin.x + position
                            sender.setTranslation(CGPoint.zero, in: view)
                        }
                    }
                }
            }
        case .ended:
            draggingIsEnabled = false
            // If the side menu is half Open/Close, then Expand/Collapse with animationse with animation
            if revealSideMenuOnTop {
                let movedMoreThanHalf = sideMenuTrailingConstraint.constant > -(MainVC.sideMenuRevealWidth * 0.5)
                sideMenuState(expanded: movedMoreThanHalf)
            }
            else {
                if let recogView = sender.view?.subviews[1] {
                    let movedMoreThanHalf = recogView.frame.origin.x > MainVC.sideMenuRevealWidth * 0.5
                    sideMenuState(expanded: movedMoreThanHalf)
                }
            }
        default:
            break
        }
    }
}
