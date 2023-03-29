//
//  DKKeyboardLayoutProvider.swift
//  Keyboard
//
//  Created by Logout on 6.02.23.
//

import Foundation
import KeyboardKit

class DKKeyboardLayoutProvider: StandardKeyboardLayoutProvider {
    
    override func keyboardLayout(for context: KeyboardContext) -> KeyboardLayout {
        let layout = super.keyboardLayout(for: context)
        
        if context.deviceType == .pad {
            if context.keyboardType.isAlphabetic {
                if let items = layout.itemRows.last {
                    let emojiKeyboardItem = KeyboardLayoutItem(
                        action: .keyboardType(.emojis),
                        size: KeyboardLayoutItemSize(
                            width: layout.itemRows.last?.first?.size.width ?? .percentage(1.5),
                            height: layout.idealItemHeight),
                        insets: layout.idealItemInsets)
                    
                    if let item = items.filter({ $0.action == .nextKeyboard }).first {
                        layout.itemRows.replace(item, with: emojiKeyboardItem)
                    }
                }
            } else {
                if let items = layout.itemRows.last {
                    if let item = items.filter({ $0.action == .nextKeyboard }).first {
                        layout.itemRows.remove(item)
                    }
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

