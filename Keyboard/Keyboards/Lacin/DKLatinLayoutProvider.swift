//
//  DKLatinLayoutProvider.swift
//  Keyboard
//
//  Created by Logout on 11.12.22.
//

import Foundation
import KeyboardKit

class DKLatinLayoutProvider: DKKeyboardLayoutProvider {
    
    
    init(keyboardContext: KeyboardContext) {
        let inputSetProvider = DKLatinInputSetProvider()
        super.init(keyboardContext: keyboardContext, inputSetProvider: inputSetProvider)
    }
    
    override func keyboardLayout(for context: KeyboardContext) -> KeyboardLayout {
        let layout = super.keyboardLayout(for: context)

        if context.keyboardType.isAlphabetic {
            if let cyrillicKeyboardItem = layout.keyboardLayoutSystemItem(action: .custom(named: DKKeyboardLayout.cyrillic.rawValue)) {
                layout.insertButtomItem(cyrillicKeyboardItem, at: 1)
            }
        }

        return layout
    }
}
