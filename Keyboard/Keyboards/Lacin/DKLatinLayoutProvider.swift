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
            let cyrillicKeyboardItem = KeyboardLayoutItem(
                action: .custom(named: DKKeyboardLayout.cyrillic.rawValue),
                size: KeyboardLayoutItemSize(
                    width: layout.itemRows.last?.first?.size.width ?? .percentage(1.5),
                    height: layout.idealItemHeight),
                insets: layout.idealItemInsets)
            
            let lastRowIndex = layout.itemRows.count - 1
            if lastRowIndex >= 0 {
                var lastRow = layout.itemRows.row(at: layout.itemRows.count - 1) ?? []
                lastRow.insert(cyrillicKeyboardItem, at: 1)
                layout.itemRows[lastRowIndex] = lastRow
            }
        }

        return layout
    }
}
