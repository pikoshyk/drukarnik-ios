//
//  DKKeyboardAppearance.swift
//  Keyboard
//
//  Created by Logout on 19.12.22.
//

import KeyboardKit
import SwiftUI

class DKKeyboardAppearance: StandardKeyboardAppearance {
    
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
        case .custom(named: DKKeyboardLayout.latin.rawValue):
            fallthrough
        case .custom(named: DKKeyboardLayout.cyrillic.rawValue):
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
        case .keyboardType(.alphabetic(.auto)): return DKLocalizationKeyboard.settings?.keyboardLayout.label ?? ""
        case .custom(named: DKKeyboardLayout.latin.rawValue): return DKKeyboardLayout.latin.label
        case .custom(named: DKKeyboardLayout.cyrillic.rawValue): return DKKeyboardLayout.cyrillic.label
        case .space: return DKLocalizationKeyboard.keyboaredButtonSpace
        case .primary(.search): return DKLocalizationKeyboard.keyboaredButtonSearch
        case .primary(.done): return DKLocalizationKeyboard.keyboaredButtonDone
        case .primary(.go): return DKLocalizationKeyboard.keyboaredButtonGo
        case .primary(.join): return DKLocalizationKeyboard.keyboaredButtonJoin
        case .primary(.ok): return DKLocalizationKeyboard.keyboaredButtonOK
        case .primary(.newLine): return nil
        case .primary(.return): return nil
        case .primary(.custom(title: "send")): return DKLocalizationKeyboard.keyboaredButtonSend
        case .primary(.custom(title: "Google")): return "Google"
        case .primary(.custom(title: "next")): return DKLocalizationKeyboard.keyboaredButtonNext
        case .primary(.custom(title: "route")): return "Route"
        case .primary(.custom(title: "Yahoo")): return "Yahoo"
        case .primary(.custom(title: "emergencyCall")): return "Emergency"
        case .primary(.custom(title: "continue")): return DKLocalizationKeyboard.keyboaredButtonContinue
        case .primary(.custom(title: "unknown")): return "Unknown"
        default: return super.buttonText(for: action)
        }
    }
    
    override func inputCalloutStyle() -> InputCalloutStyle {
        let style = super.inputCalloutStyle()
        return style
    }
}