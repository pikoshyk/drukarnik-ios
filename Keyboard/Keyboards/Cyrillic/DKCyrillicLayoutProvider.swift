//
//  DKCyrillicLayoutProvider.swift
//  Keyboard
//
//  Created by Logout on 11.12.22.
//

import Foundation
import KeyboardKit

class DKCyrillicLayoutProvider: DKKeyboardLayoutProvider {
    
    init(keyboardContext: KeyboardContext) {
        let inputSetProvider = DKCyrillicInputSetProvider()
        super.init(keyboardContext: keyboardContext, inputSetProvider: inputSetProvider)
    }
    
    override func keyboardLayout(for context: KeyboardContext) -> KeyboardLayout {
        let layout = super.keyboardLayout(for: context)

        if context.keyboardType.isAlphabetic {
            if let latinKeyboardItem = layout.keyboardLayoutSystemItem(action: .custom(named: DKKeyboardLayout.latin.rawValue)) {
                layout.insertButtomItem(latinKeyboardItem, at: 1)
            }
        }

        return layout
    }
}
