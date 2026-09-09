import Foundation
import BelarusianLacinka
import KeyboardKit
import UIKit

class DKEmojiAutocompleteProvider: DKAutocompleteProvider {

    private let dict: [String: [String]]

    override init(settings: DKKeyboardSettings, textDocumentProxy: UITextDocumentProxy) {
        self.dict = DKEmojiAutocompleteLexicon.emojis
        super.init(settings: settings, textDocumentProxy: textDocumentProxy)
    }

    override func autocompleteSuggestions(for text: String) async throws -> [Autocomplete.Suggestion] {
        guard let word = text.components(separatedBy: CharacterSet(charactersIn: String.wordDelimiters.joined())).last?.lowercased() else {
            return []
        }
        if text.isEmpty { return [] }

        var emoji = self.dict[word]
        if emoji == nil {
            let trWord = DKLocalizationKeyboard.convert(text: word, to: .toCyrillic)
            emoji = self.dict[trWord]
        }
        guard let emoji = emoji else {
            return []
        }
        let suggestions = emoji.compactMap { Autocomplete.Suggestion(text: $0) }
        return suggestions
    }
}
