//
//  Color+UIColor.swift
//  Drukarnik
//
//  Created by Logout on 27.04.24.
//

import UIKit
import SwiftUI

@available(iOS, introduced: 14.4, deprecated: 15.8, message: "")
extension Color {
    init(uiColor: UIColor) {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        self = Color(hue: h, saturation: s, brightness: b, opacity: a)
    }
}
