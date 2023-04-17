//
//  KeyboardLayout+Buttons.swift
//  Keyboard
//
//  Created by Logout on 29.03.23.
//

import Foundation
import KeyboardKit

public extension KeyboardLayout {

    var bottomRowIndex: Int? {
        let index = self.itemRows.count - 1
        return index >= 0 ? index : nil
    }

    var hasRows: Bool {
        self.itemRows.count > 0
    }

    func keyboardLayoutSystemItem(action: KeyboardAction) -> KeyboardLayoutItem? {
        guard let bottomRowIndex = self.bottomRowIndex else {
            return nil
        }
        guard let template = (self.itemRows[bottomRowIndex].first { $0.action.isSystemAction }) else {
            return nil
        }
        let item = KeyboardLayoutItem(action: action, size: template.size, insets: template.insets)
        return item
    }
    
    func insertButtomItem(_ item: KeyboardLayoutItem, at index: Int) {
        if let bottomRowIndex = self.bottomRowIndex {
            var lastRow = self.itemRows.row(at: bottomRowIndex) ?? []
            lastRow.insert(item, at: index)
            self.itemRows[bottomRowIndex] = lastRow
        }
    }
}

