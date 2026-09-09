import Foundation
import KeyboardKit
import BelarusianLacinka

extension DKAutocompleteProvider {

    func transliteration(for text: String, to: BLDirection) -> [Autocomplete.Suggestion] {
        guard let word = DKAutocompleteWordSuggestions.lastWord(from: text) else { return [] }
        return DKAutocompleteWordSuggestions.build(
            word: word,
            direction: to,
            convert: DKLocalizationKeyboard.convert,
            lexicon: DKEmojiAutocompleteLexicon.emojis
        )
    }
}
