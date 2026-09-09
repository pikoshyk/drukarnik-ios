import BelarusianLacinka
import Foundation
import KeyboardKit
import UIKit

class DKLatinAutocompleteProvider: DKAutocompleteProvider {

    private let lexicon: [String: [String]]

    override init(settings: DKKeyboardSettings, textDocumentProxy: UITextDocumentProxy) {
        self.lexicon = DKEmojiAutocompleteLexicon.emojis
        super.init(settings: settings, textDocumentProxy: textDocumentProxy)
    }

    override func autocompleteSuggestions(for text: String) async throws -> [Autocomplete.Suggestion] {
        guard let word = DKAutocompleteWordSuggestions.lastWord(from: text) else { return [] }
        return DKAutocompleteWordSuggestions.build(
            word: word,
            direction: .toCyrillic,
            convert: DKLocalizationKeyboard.convert,
            lexicon: self.lexicon
        )
    }
}
