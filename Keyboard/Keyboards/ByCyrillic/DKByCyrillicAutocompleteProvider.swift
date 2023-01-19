//
//  DKByCyrillycAutocompleteProvider.swift
//  Keyboard
//
//  Created by Logout on 22.12.22.
//

import Foundation
import KeyboardKit

class DKByCyrillycAutocompleteProvider: AutocompleteProvider {
    
    var locale: Locale = DKByKeyboardSettings.shared.keyboardLayout.locale

    func autocompleteSuggestions(for text: String, completion: AutocompleteCompletion) {
        let word = text.components(separatedBy: CharacterSet(charactersIn: String.wordDelimiters.joined())).last ?? ""
        if word.isEmpty { return completion(.success([])) }
        completion(.success(self.suggestions(for: word)))
    }
    
    var canIgnoreWords: Bool { false }
    var canLearnWords: Bool { false }
    var ignoredWords: [String] = []
    var learnedWords: [String] = []
    
    func hasIgnoredWord(_ word: String) -> Bool { false }
    func hasLearnedWord(_ word: String) -> Bool { false }
    func ignoreWord(_ word: String) {}
    func learnWord(_ word: String) {}
    func removeIgnoredWord(_ word: String) {}
    func unlearnWord(_ word: String) {}
}

private extension DKByCyrillycAutocompleteProvider {
    
    func suggestions(for text: String) -> [AutocompleteSuggestion] {
        var words: [String] = []
        return words.map {suggestion($0)}
    }
    
    func suggestion(_ word: String, subtitle: String? = nil) -> AutocompleteSuggestion {
        StandardAutocompleteSuggestion(
            text: word,
            title: word,
            subtitle: subtitle)
    }
    
}
