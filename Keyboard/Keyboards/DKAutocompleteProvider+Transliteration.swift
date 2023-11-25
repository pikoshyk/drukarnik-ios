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

    func transliteration(for text: String, to: BLDirection) -> [Autocomplete.Suggestion] {
        let convertedText = DKLocalizationKeyboard.convert(text: text, to: to)
        let autocompleteTransliteration = self.settings?.autocompleteTransliteration ?? true

        var suggestions: [Autocomplete.Suggestion] = []
        if autocompleteTransliteration {
            suggestions = [
                Autocomplete.Suggestion(text: text, isAutocorrect: false, subtitle: nil),
                Autocomplete.Suggestion(text: convertedText, isAutocorrect: true, subtitle: nil),
            ]
        } else {
            suggestions = [
                Autocomplete.Suggestion(text: convertedText ,isAutocorrect: false, subtitle: nil)
            ]
        }
        
//        suggestion.fullTextReplaceRequired = true
        return suggestions
    }

}
