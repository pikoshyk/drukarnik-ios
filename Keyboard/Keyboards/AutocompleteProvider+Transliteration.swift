//
//  AutocompleteProvider+Transliteration.swift
//  Keyboard
//
//  Created by Logout on 25.01.23.
//

import Foundation
import KeyboardKit
import BelarusianLacinka

extension AutocompleteProvider {

    func transliteration(for text: String, to: BLDirection) -> [AutocompleteSuggestion] {
        let convertedText = DKLocalizationKeyboard.convert(text: text, to: to)
        let suggestion = StandardAutocompleteSuggestion(text: convertedText)
//        suggestion.fullTextReplace = true
        return [suggestion]
    }

}
