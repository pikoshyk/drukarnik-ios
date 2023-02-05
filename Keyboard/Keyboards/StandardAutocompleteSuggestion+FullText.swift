//
//  StandardAutocompleteSuggestion+FullText.swift
//  Keyboard
//
//  Created by Logout on 25.01.23.
//

import KeyboardKit

extension StandardAutocompleteSuggestion {
    var fullTextReplace: Bool {
        set {
            self.additionalInfo["fullTextReplace"] = newValue
        }
        get {
            (self.additionalInfo["fullTextReplace"] as? Bool) ?? false
        }
    }
}
