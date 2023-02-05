//
//  DKAutocompleteProvider.swift
//  Keyboard
//
//  Created by Logout on 6.02.23.
//

import KeyboardKit
import Foundation
import UIKit

class DKAutocompleteProvider: AutocompleteProvider {
    var locale: Locale
    weak var settings: DKKeyboardSettings?
    weak var textDocumentProxy: UITextDocumentProxy?

    func autocompleteSuggestions(for text: String, completion: @escaping KeyboardKit.AutocompleteCompletion) {
        assertionFailure("Method <autocompleteSuggestions(for:completion:)> must be overrided.")
    }
    
    init(settings: DKKeyboardSettings, textDocumentProxy: UITextDocumentProxy) {
        self.settings = settings
        self.locale = settings.keyboardLayout.locale
        self.textDocumentProxy = textDocumentProxy
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
