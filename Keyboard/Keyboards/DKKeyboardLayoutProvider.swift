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

