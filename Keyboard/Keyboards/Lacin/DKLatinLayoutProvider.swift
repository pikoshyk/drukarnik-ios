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
            layout.itemRows.insert(cyrillicKeyboardItem, before: .keyboardType(.emojis))
        }
//        Disable emoji button on numeric keyboard
//        else if context.keyboardType == .numeric {
//            if let items = layout.itemRows.last {
//                if let item = items.filter({ $0.action.isKeyboardTypeAction(.emojis) }).first {
//                    layout.itemRows.remove(item)
//                }
//            }
//        }

        return layout
    }
}
