//
//  DKLatinAutocompleteProvider.swift
//  Keyboard
//
//  Created by Logout on 22.12.22.
//

import Foundation
import KeyboardKit
import UIKit

class DKLatinAutocompleteProvider: AutocompleteProvider {
    
    var locale: Locale = DKKeyboardSettings.shared.keyboardLayout.locale
    private var textDocumentProxy: UITextDocumentProxy
    
    init(textDocumentProxy: UITextDocumentProxy) {
        self.textDocumentProxy = textDocumentProxy
    }
    
    func autocompleteSuggestions(for word: String, completion: AutocompleteCompletion) {
//        let word = text.components(separatedBy: CharacterSet(charactersIn: String.wordDelimiters.joined())).last ?? ""
//        if word.isEmpty { return completion(.success([])) }
//        completion(.success(self.suggestions(for: word)))

        let text = word //self.textDocumentProxy.fullText ?? ""
        if text.isEmpty { return completion(.success([])) }
        completion(.success(self.transliteration(for: text, to: .toCyrillic)))
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

private extension DKLatinAutocompleteProvider {
    
    func suggestions(for text: String) -> [AutocompleteSuggestion] {
        let words: [String] = []
        return words.map {suggestion($0)}
    }
    
    func suggestion(_ word: String, subtitle: String? = nil) -> AutocompleteSuggestion {
        StandardAutocompleteSuggestion(
            text: word,
            title: word,
            subtitle: subtitle)
    }
}
