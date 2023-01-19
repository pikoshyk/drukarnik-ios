//
//  CALayer+Tools.swift
//  Drukarnik
//
//  Created by Logout on 24.12.22.
//

import UIKit

extension CALayer {
    var borderUIColor: UIColor? {
        get {
            guard let cgColor = self.borderColor else {
                return nil
            }
            let color = UIColor(cgColor: cgColor)
            return color
        }
        set {
            guard let color = newValue else {
                self.borderColor = nil
                return
            }
            self.borderColor = color.cgColor
        }
    }
}
