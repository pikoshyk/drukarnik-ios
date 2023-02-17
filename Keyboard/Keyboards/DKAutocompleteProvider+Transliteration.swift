//
//  AutocompleteProvider+Transliteration.swift
//  Keyboard
//
//  Created by Logout on 25.01.23.
//

import Foundation
import KeyboardKit
import BelarusianLacinka

extension DKAutocompleteProvider {

    func transliteration(for text: String, to: BLDirection) -> [AutocompleteSuggestion] {
        let convertedText = DKLocalizationKeyboard.convert(text: text, to: to)
        let autocompleteTransliteration = self.settings?.autocompleteTransliteration ?? true

        var suggestions: [AutocompleteSuggestion] = []
        if autocompleteTransliteration {
            suggestions = [
                StandardAutocompleteSuggestion(text: text ,isAutocomplete: false),
                StandardAutocompleteSuggestion(text: convertedText ,isAutocomplete: true),
            ]
        } else {
            suggestions = [
                StandardAutocompleteSuggestion(text: convertedText ,isAutocomplete: false)
            ]
        }
        
//        suggestion.fullTextReplaceRequired = true
        return suggestions
    }

}
