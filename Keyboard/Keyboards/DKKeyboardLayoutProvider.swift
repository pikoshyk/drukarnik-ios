//
//  DKKeyboardLayoutProvider.swift
//  Keyboard
//
//  Created by Logout on 6.02.23.
//

import Foundation
import KeyboardKit

class DKKeyboardLayoutProvider: InputSetBasedKeyboardLayoutProvider {
    
    override func keyboardLayout(for context: KeyboardContext) -> KeyboardLayout {
        let layout = super.keyboardLayout(for: context)

        if let items = layout.itemRows.last {
            let itemsToDelete: [KeyboardAction] = [.keyboardType(.emojis)]
            if let item = items.filter({ itemsToDelete.contains($0.action) }).first {
                layout.itemRows.remove(item)
            }
        }

//        if context.deviceType == .pad {
//            if let items = layout.itemRows.last {
//                let itemsToDelete: [KeyboardAction] = [.nextKeyboard, .keyboardType(.emojis)]
//                if let item = items.filter({ itemsToDelete.contains($0.action) }).first {
//                    layout.itemRows.remove(item)
//                }
//            }
//            if context.keyboardType.isAlphabetic {
//                if let emojiKeyboardItem = layout.keyboardLayoutSystemItem(action: .keyboardType(.emojis)) {
//                    layout.insertButtomItem(emojiKeyboardItem, at: 1)
//                }
//            }
//        }

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

