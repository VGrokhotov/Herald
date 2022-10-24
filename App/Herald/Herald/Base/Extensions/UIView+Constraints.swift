//
//  UIView+Constraints.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 25.01.2022.
//

import UIKit

struct LayoutInsets {
    
    static var zero: LayoutInsets { self.init(top: 0, left: 0, bottom: 0, right: 0) }

    public var top: CGFloat?
    public var left: CGFloat?
    public var bottom: CGFloat?
    public var right: CGFloat?

    static func insets(
        top: CGFloat? = 0,
        left: CGFloat? = 0,
        bottom: CGFloat? = 0,
        right: CGFloat? = 0
    ) -> LayoutInsets {
        return LayoutInsets(top: top, left: left, bottom: bottom, right: right)
    }
}

extension UIView {
    
    func layoutSubview(
        _ view: UIView,
        with insets: LayoutInsets = .zero,
        safe: Bool = false,
        isTop: Bool = true,
        xOffset: CGFloat? = nil,
        yOffset: CGFloat? = nil
    ) {
        if isTop {
            addSubview(view)
        } else {
            insertSubview(view, at: 0)
        }

        view.translatesAutoresizingMaskIntoConstraints = false

        if let top = insets.top {
            view.topAnchor.makeConstraint(equalTo: getTopAnchor(safe: safe), constant: top)
        }

        if let left = insets.left {
            view.leadingAnchor.makeConstraint(equalTo: getLeadingAnchor(safe: safe), constant: left)
        }

        if let bottom = insets.bottom {
            view.bottomAnchor.makeConstraint(equalTo: getBottomAnchor(safe: safe), constant: -bottom)
        }

        if let right = insets.right {
            view.trailingAnchor.makeConstraint(equalTo: getTrailingAnchor(safe: safe), constant: -right)
        }
        
        if let xOffset = xOffset {
            view.centerXAnchor.makeConstraint(equalTo: centerXAnchor, constant: xOffset)
        }
        
        if let yOffset = yOffset {
            view.centerYAnchor.makeConstraint(equalTo: centerYAnchor, constant: yOffset)
        }
    }
    
    func layoutSize(
        height: CGFloat? = nil,
        width: CGFloat? = nil,
        translateAutoresizingMaskIntoConstraints: Bool = false
    ) {
        translatesAutoresizingMaskIntoConstraints = translateAutoresizingMaskIntoConstraints
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    
    func getTopAnchor(safe: Bool) -> NSLayoutYAxisAnchor {
        return safe ? safeAreaLayoutGuide.topAnchor : topAnchor
    }

    func getBottomAnchor(safe: Bool) -> NSLayoutYAxisAnchor {
        return safe ? safeAreaLayoutGuide.bottomAnchor : bottomAnchor
    }

    func getLeadingAnchor(safe: Bool) -> NSLayoutXAxisAnchor {
        return safe ? safeAreaLayoutGuide.leadingAnchor : leadingAnchor
    }

    func getTrailingAnchor(safe: Bool) -> NSLayoutXAxisAnchor {
        return safe ? safeAreaLayoutGuide.trailingAnchor : trailingAnchor
    }
}

extension NSLayoutAnchor {
    
    @objc func makeConstraint(equalTo anchor: NSLayoutAnchor, constant: CGFloat) {
        constraint(equalTo: anchor, constant: constant).isActive = true
    }
}
