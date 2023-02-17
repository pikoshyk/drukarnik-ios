//
//  StandardAutocompleteSuggestion+FullText.swift
//  Keyboard
//
//  Created by Logout on 25.01.23.
//

import KeyboardKit

extension StandardAutocompleteSuggestion {
    var fullTextReplaceRequired: Bool {
        set {
            self.additionalInfo["fullTextReplaceRequired"] = newValue
        }
        get {
            (self.additionalInfo["fullTextReplaceRequired"] as? Bool) ?? false
        }
    }
}
