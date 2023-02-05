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
    static func standardActionFullText(
        for suggestion: AutocompleteSuggestion
    ) {
        let controller = KeyboardInputViewController.shared
        let proxy = controller.textDocumentProxy
        let actionHandler = controller.keyboardActionHandler


        var fullTextReplace = false
        if let standardSuggestion = suggestion as? StandardAutocompleteSuggestion {
            fullTextReplace = standardSuggestion.fullTextReplace
        }
        if fullTextReplace {
            proxy.insertAutocompleteSuggestionFullText(suggestion)
        } else {
            proxy.insertAutocompleteSuggestion(suggestion)
        }
        actionHandler.handle(.tap, on: .character(""))
    }
    
}
