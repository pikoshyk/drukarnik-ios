//
//  UIView+FixedSizeView.swift
//  Drukarnik
//
//  Created by Logout on 25.11.23.
//

import UIKit

extension UIView {
    static func fixedSizeView(width: CGFloat, height: CGFloat) -> UIView {
        let fixedSizeView = UIView()
        fixedSizeView.translatesAutoresizingMaskIntoConstraints = false
        fixedSizeView.backgroundColor = .clear

        let w: NSLayoutConstraint = fixedSizeView.widthAnchor.constraint(equalToConstant: width)
        w.priority = .required
        w.isActive = true

        let h: NSLayoutConstraint = fixedSizeView.heightAnchor.constraint(equalToConstant: height)
        h.priority = .required
        h.isActive = true

        return fixedSizeView
    }
}
