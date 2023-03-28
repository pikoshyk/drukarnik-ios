//
//  DKAutocompleteToolbar.swift
//  Keyboard
//
//  Created by Logout on 25.01.23.
//

import SwiftUI
import KeyboardKit

class DKAutocompleteToolbar {
    
    /**
     This is the default action that will be used to trigger
     a text replacement when a `suggestion` is tapped.
     */
    static func standardActionWithFullTextAutocompleteSupport (
        for suggestion: AutocompleteSuggestion,
        keyboardController: KeyboardInputViewController
    ) {
        let proxy = keyboardController.textDocumentProxy
        let actionHandler = keyboardController.keyboardActionHandler

        let fullTextReplaceRequired = suggestion.fullTextReplaceRequired

        if fullTextReplaceRequired {
            proxy.insertAutocompleteSuggestionFullText(suggestion)
        } else {
            proxy.insertAutocompleteSuggestion(suggestion)
        }
        actionHandler.handle(.release, on: .character(""))
    }
    
}
