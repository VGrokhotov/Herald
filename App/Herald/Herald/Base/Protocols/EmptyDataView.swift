//
//  EmptyDataView.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 25.01.2022.
//

import UIKit

protocol EmptyDataView: UIView {
    
    var messageTitle: String { get set }
    var noteTitle: String { get set }
    var outerInsets: LayoutInsets { get }
}

protocol EmptyDataRepresentable: AnyObject {
        
    var emptyDataView: EmptyDataView? { get }
}

extension EmptyDataRepresentable where Self: UIViewController {

    // MARK: - Public methods
    
    func setupEmptyDataView(
        messageTitle: String = Strings.defaultEmptyDataMessage,
        noteTitle: String = Strings.defaultEmptyDataNote
    ) {
        if let emptyDataView = emptyDataView {
            emptyDataView.messageTitle = messageTitle
            emptyDataView.noteTitle = noteTitle
            emptyDataView.alpha = 0
            view.layoutSubview(
                emptyDataView,
                with: emptyDataView.outerInsets,
                isTop: false,
                xOffset: 0,
                yOffset: -70
            )
        }
    }

    func showEmptyDataView() {
        if let emptyDataView = emptyDataView {
            emptyDataView.isHidden = false
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                self.willShowEmptyDataView()
                self.emptyDataView?.alpha = 1
//                self.view.bringSubviewToFront(emptyDataView)
            })
        }
    }

    func hideEmptyDataView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.willHideEmptyDataView()
            self.emptyDataView?.alpha = 0
        }) { [weak self] _ in
            self?.emptyDataView?.isHidden = true
        }
    }
    
    // MARK: - Default Implementation
    
    func willShowEmptyDataView() { }
    
    func willHideEmptyDataView() { }
}
