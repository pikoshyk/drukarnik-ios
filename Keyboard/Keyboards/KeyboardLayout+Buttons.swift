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

    func keyboardLayoutSystemItem(action: KeyboardAction) -> KeyboardLayout.Item? {
        guard let bottomRowIndex = self.bottomRowIndex else {
            return nil
        }
        guard let template = (self.itemRows[bottomRowIndex].first { $0.action.isSystemAction }) else {
            return nil
        }
        let item = KeyboardLayout.Item(action: action, size: template.size, edgeInsets: template.edgeInsets)
        return item
    }
    
    func insertButtomItem(_ item: KeyboardLayout.Item, at index: Int) {
        if let bottomRowIndex = self.bottomRowIndex {
            var lastRow = self.itemRows.row(at: bottomRowIndex) ?? []
            lastRow.insert(item, at: index)
            self.itemRows[bottomRowIndex] = lastRow
        }
    }
}

