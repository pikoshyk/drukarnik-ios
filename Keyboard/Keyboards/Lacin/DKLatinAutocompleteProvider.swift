//
//  DKLatinAutocompleteProvider.swift
//  Keyboard
//
//  Created by Logout on 22.12.22.
//

import Foundation
import KeyboardKit
import UIKit

class DKLatinAutocompleteProvider: DKAutocompleteProvider {

    override func autocompleteSuggestions(for word: String) async throws -> [Autocomplete.Suggestion] {
//        let word = text.components(separatedBy: CharacterSet(charactersIn: String.wordDelimiters.joined())).last ?? ""
//        if word.isEmpty { return completion(.success([])) }
//        completion(.success(self.suggestions(for: word)))

        let text = word //self.textDocumentProxy.fullText ?? ""
        if text.isEmpty { return [] }
        return self.transliteration(for: text, to: .toCyrillic)
    }
}

private extension DKLatinAutocompleteProvider {
    
    func suggestions(for text: String) -> [Autocomplete.Suggestion] {
        let words: [String] = []
        return words.map {suggestion($0)}
    }
    
    func suggestion(_ word: String, subtitle: String? = nil) -> Autocomplete.Suggestion {
        Autocomplete.Suggestion(
            text: word,
            title: word,
            subtitle: subtitle)
    }
}
