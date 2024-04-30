//
//  DKKeyboardAppearance.swift
//  Keyboard
//
//  Created by Logout on 19.12.22.
//

import KeyboardKit
import SwiftUI

class DKKeyboardAppearance: KeyboardStyle.StandardProvider {
    
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

//        case .return: return .keyboardNewline(for: Locale.current)
        default: return super.buttonImage(for: action)
        }
    }
    
    override func buttonStyle(for action: KeyboardAction, isPressed: Bool) -> Keyboard.ButtonStyle {
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
    
    override func buttonFont(for action: KeyboardAction) -> KeyboardFont {
        switch(action) {
        case .space:
            let size = buttonFontSize(for: action)
            let buttonFontSize = size * 3 / 4
            let font = KeyboardFont.system(size: buttonFontSize)
            let weight = KeyboardFont.FontWeight.medium
            return font.weight(weight)
        default:
            return super.buttonFont(for: action)
        }
    }

    
    override func buttonText(for action: KeyboardAction) -> String? {
        switch action {
        case .keyboardType(.alphabetic(.auto)): return DKLocalizationKeyboard.settings?.keyboardLayout.label ?? ""
        case .custom(named: DKKeyboardLayout.latin.rawValue): return DKKeyboardLayout.latin.label
        case .custom(named: DKKeyboardLayout.cyrillic.rawValue): return DKKeyboardLayout.cyrillic.label
        case .space: return DKLocalizationKeyboard.keyboardButtonSpace
        case .primary(.search): return DKLocalizationKeyboard.keyboardButtonSearch
        case .primary(.done): return DKLocalizationKeyboard.keyboardButtonDone
        case .primary(.go): return DKLocalizationKeyboard.keyboardButtonGo
        case .primary(.join): return DKLocalizationKeyboard.keyboardButtonJoin
        case .primary(.ok): return DKLocalizationKeyboard.keyboardButtonOK
        case .primary(.newLine): return nil
        case .primary(.return): return nil
        case .primary(.custom(title: "send")): return DKLocalizationKeyboard.keyboardButtonSend
        case .primary(.custom(title: "Google")): return "Google"
        case .primary(.custom(title: "next")): return DKLocalizationKeyboard.keyboardButtonNext
        case .primary(.custom(title: "route")): return "Route"
        case .primary(.custom(title: "Yahoo")): return "Yahoo"
        case .primary(.custom(title: "emergencyCall")): return "Emergency"
        case .primary(.custom(title: "continue")): return DKLocalizationKeyboard.keyboardButtonContinue
        case .primary(.custom(title: "unknown")): return "Unknown"
        default: return super.buttonText(for: action)
        }
    }
}
