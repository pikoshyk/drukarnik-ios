//
//  DKKeyboardLayoutProvider.swift
//  Keyboard
//
//  Created by Logout on 6.02.23.
//

import Foundation
import KeyboardKit

class DKKeyboardLayoutProvider: KeyboardLayout.DeviceBasedProvider {
    
    override func keyboardLayout(for context: KeyboardContext) -> KeyboardLayout {
        let layout = super.keyboardLayout(for: context)

        if context.deviceType == .pad {
            
            let nextKeyboardItem = layout.keyboardLayoutSystemItem(action: .nextKeyboard)

            if let items = layout.itemRows.last {
                let itemsToDelete: [KeyboardAction] = [.nextKeyboard, .keyboardType(.emojis)]
                if let item = items.filter({ itemsToDelete.contains($0.action) }).first {
                    layout.itemRows.remove(item)
                }
            }
            if let nextKeyboardItem = nextKeyboardItem {
                layout.insertButtomItem(nextKeyboardItem, at: 1)
            }
            if context.keyboardType.isAlphabetic {
                if let emojiKeyboardItem = layout.keyboardLayoutSystemItem(action: .keyboardType(.emojis)) {
                    layout.insertButtomItem(emojiKeyboardItem, at: 1)
                }
            }
        }

        //        if context.keyboardType.isAlphabetic {
        //            if context.deviceType != .pad {
        //                let items = layout.itemRows.last?.filter { $0.action == .character(".") } ?? []
        //                if items.count == 0 {
        //                    let itemDot = KeyboardLayoutItem(
        //                        action: .character("."),
        //                        size: KeyboardLayoutItemSize(
        //                            width: .inputPercentage(1),
        //                            height: layout.idealItemHeight),
        //                        insets: layout.idealItemInsets)
        //                    layout.itemRows.insert(itemDot, after: .space)
        //                }
        //            }
        //        }
        return layout
    }
    
    
//    func bottomSystemButtonWidth(for context: KeyboardContext) -> KeyboardLayoutItemWidth {
//        .percentage(self.isPortrait(context) ? 0.123 : 0.095)
//    }
}


#warning("TODO: After each update KeyboardKit comment 'layout.itemRows.remove(.keyboardType(.emojis))' in SystemKeyboard::init")
