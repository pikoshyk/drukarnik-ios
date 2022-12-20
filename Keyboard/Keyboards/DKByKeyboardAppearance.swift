//
//  DKByCyrillycKeyboardAppearance.swift
//  Keyboard
//
//  Created by Logout on 19.12.22.
//

import KeyboardKit
import SwiftUI

class DKByKeyboardAppearance: StandardKeyboardAppearance {
    
    override func actionCalloutStyle() -> ActionCalloutStyle {
        let style = super.actionCalloutStyle()
        return style
    }
    
    override func buttonImage(for action: KeyboardAction) -> Image? {
        switch action {
        case .primary(.newLine): return .keyboardNewline(for: Locale.current)
        case .primary(.custom(title: "send")): return nil
        case .primary(.custom(title: "Google")): return nil
        case .primary(.custom(title: "next")): return nil
        case .primary(.custom(title: "route")): return nil
        case .primary(.custom(title: "Yahoo")): return nil
        case .primary(.custom(title: "emergencyCall")): return nil
        case .primary(.custom(title: "continue")): return nil
        case .primary(.custom(title: "unknown")): return nil

        case .return: return .keyboardNewline(for: Locale.current)
        default: return super.buttonImage(for: action)
        }
    }
    
    override func buttonStyle(for action: KeyboardAction, isPressed: Bool) -> KeyboardButtonStyle {
        switch(action) {
        case .custom(named: DKByKeyboardLayout.latin.rawValue):
            fallthrough
        case .custom(named: DKByKeyboardLayout.cyrillic.rawValue):
            return super.buttonStyle(for: .keyboardType(.alphabetic(.uppercased)), isPressed: isPressed)
        case .primary(.custom(title: "send")): fallthrough
        case .primary(.custom(title: "Google")): fallthrough
        case .primary(.custom(title: "next")): fallthrough
        case .primary(.custom(title: "route")): fallthrough
        case .primary(.custom(title: "Yahoo")): fallthrough
        case .primary(.custom(title: "emergencyCall")): fallthrough
        case .primary(.custom(title: "continue")): fallthrough
        case .primary(.custom(title: "unknown")):
            return super.buttonStyle(for: .primary(.ok), isPressed: isPressed)
        default:
            return super.buttonStyle(for: action, isPressed: isPressed)
        }
    }
    
    override func buttonFont(for action: KeyboardAction) -> Font {
        switch(action) {
        case .space:
            let rawFont = Font.system(size: 12.0)
            let weight = Font.Weight.medium
            return rawFont.weight(weight)
        default:
            return super.buttonFont(for: action)
        }
    }

    
    override func buttonText(for action: KeyboardAction) -> String? {
        switch action {
        case .keyboardType(.alphabetic(.auto)): return DKByKeyboardSettings.shared.keyboardLayout.label
        case .custom(named: DKByKeyboardLayout.latin.rawValue): return DKByKeyboardLayout.latin.label
        case .custom(named: DKByKeyboardLayout.cyrillic.rawValue): return DKByKeyboardLayout.cyrillic.label
        case .space: return DKLocalization.keyboaredButtonSpace
        case .primary(.search): return DKLocalization.keyboaredButtonSearch
        case .primary(.newLine): return nil
        case .primary(.done): return DKLocalization.keyboaredButtonDone
        case .primary(.go): return DKLocalization.keyboaredButtonGo
        case .primary(.join): return DKLocalization.keyboaredButtonJoin
        case .primary(.ok): return DKLocalization.keyboaredButtonOK
        case .primary(.custom(title: "send")): return DKLocalization.keyboaredButtonSend

        case .primary(.custom(title: "Google")): return "Google"
        case .primary(.custom(title: "next")): return DKLocalization.keyboaredButtonNext
        case .primary(.custom(title: "route")): return "Route"
        case .primary(.custom(title: "Yahoo")): return "Yahoo"
        case .primary(.custom(title: "emergencyCall")): return "Emergency"
        case .primary(.custom(title: "continue")): return DKLocalization.keyboaredButtonContinue
        case .primary(.custom(title: "unknown")): return "Unknown"
            
            
        case .return: return nil
        default: return super.buttonText(for: action)
        }
    }
    
    override func inputCalloutStyle() -> InputCalloutStyle {
        let style = super.inputCalloutStyle()
        return style
    }
}
