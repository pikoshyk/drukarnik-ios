//
//  DKLatinLayoutProvider.swift
//  Keyboard
//
//  Created by Logout on 11.12.22.
//

import Foundation
import KeyboardKit

class DKLatinLayoutProvider: StandardKeyboardLayoutProvider {
    
    
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
            layout.itemRows.insert(cyrillicKeyboardItem, before: .keyboardType(.emojis))

            if context.deviceType != .pad {
                let items = layout.itemRows.last?.filter { $0.action == .character(".") } ?? []
                if items.count == 0 {
                    let itemDot = KeyboardLayoutItem(
                        action: .character("."),
                        size: KeyboardLayoutItemSize(
                            width: .inputPercentage(1),
                            height: layout.idealItemHeight),
                        insets: layout.idealItemInsets)
                    layout.itemRows.insert(itemDot, after: .space)
                }
            }
        }
        return layout
    }
    
//    func bottomSystemButtonWidth(for context: KeyboardContext) -> KeyboardLayoutItemWidth {
//        .percentage(self.isPortrait(context) ? 0.123 : 0.095)
//    }
}
