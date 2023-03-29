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

            let latinKeyboardItem = KeyboardLayoutItem(
                action: .custom(named: DKKeyboardLayout.latin.rawValue),
                size: KeyboardLayoutItemSize(
                    width: layout.itemRows.last?.first?.size.width ?? .percentage(1.5),
                    height: layout.idealItemHeight),
                insets: layout.idealItemInsets)

            let lastRowIndex = layout.itemRows.count - 1
            if lastRowIndex >= 0 {
                var lastRow = layout.itemRows.row(at: layout.itemRows.count - 1) ?? []
                lastRow.insert(latinKeyboardItem, at: 1)
                layout.itemRows[lastRowIndex] = lastRow
            }
        }

        return layout
    }
}
