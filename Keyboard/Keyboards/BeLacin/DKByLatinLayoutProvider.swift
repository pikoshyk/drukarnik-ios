//
//  DKByCyrillicLayoutProvider.swift
//  Keyboard
//
//  Created by Logout on 11.12.22.
//

import Foundation
import KeyboardKit

class DKByLatinLayoutProvider: StandardKeyboardLayoutProvider {
    
    
    init(dictationReplacement: KeyboardAction? = nil) {
        let inputSetProvider = DKByLatinInputSetProvider()
        super.init(keyboardContext: <#KeyboardContext#>, inputSetProvider: inputSetProvider, dictationReplacement: dictationReplacement)
    }
    
    private override init(keyboardContext: KeyboardContext, inputSetProvider: InputSetProvider, dictationReplacement: KeyboardAction? = nil) {
        super.init(keyboardContext: <#KeyboardContext#>, inputSetProvider: inputSetProvider, dictationReplacement: dictationReplacement)
    }

    override func keyboardLayout(for context: KeyboardContext) -> KeyboardLayout {
        let layout = super.keyboardLayout(for: context)

        if context.keyboardType.isAlphabetic {
            let cyrillicKeyboardItem = KeyboardLayoutItem(
                action: .custom(named: DKByKeyboardLayout.cyrillic.rawValue),
                size: KeyboardLayoutItemSize(
                    width: layout.itemRows.last?.first?.size.width ?? .percentage(1.5),
                    height: layout.idealItemHeight),
                insets: layout.idealItemInsets)
            layout.itemRows.insert(cyrillicKeyboardItem, before: .keyboardType(.emojis))

            if context.deviceType != .pad {
                let itemDot = KeyboardLayoutItem(
                    action: .character("."),
                    size: KeyboardLayoutItemSize(
                        width: .inputPercentage(1),
                        height: layout.idealItemHeight),
                    insets: layout.idealItemInsets)
                layout.itemRows.insert(itemDot, after: .space)
            }
        }
        return layout
    }
    
//    func bottomSystemButtonWidth(for context: KeyboardContext) -> KeyboardLayoutItemWidth {
//        .percentage(self.isPortrait(context) ? 0.123 : 0.095)
//    }
}