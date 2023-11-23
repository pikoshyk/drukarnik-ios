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
                AutocompleteSuggestion(text: text, isAutocorrect: false, subtitle: nil),
                AutocompleteSuggestion(text: convertedText, isAutocorrect: true, subtitle: nil),
            ]
        } else {
            suggestions = [
                AutocompleteSuggestion(text: convertedText ,isAutocorrect: false, subtitle: nil)
            ]
        }
        
//        suggestion.fullTextReplaceRequired = true
        return suggestions
    }

}
