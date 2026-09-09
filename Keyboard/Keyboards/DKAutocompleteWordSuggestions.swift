import BelarusianLacinka
import Foundation
import KeyboardKit

enum DKAutocompleteWordSuggestions {

    static func lastWord(from text: String) -> String? {
        guard !text.isEmpty else { return nil }
        let word = text
            .components(separatedBy: CharacterSet(charactersIn: String.wordDelimiters.joined()))
            .last
        guard let word, !word.isEmpty else { return nil }
        return word
    }

    static func applyInputCase(from input: String, to output: String) -> String {
        guard !input.isEmpty, !output.isEmpty else { return output }
        if input == input.uppercased(), input != input.lowercased() {
            return output.uppercased()
        }
        if let first = input.first, first.isUppercase {
            return output.prefix(1).uppercased() + output.dropFirst()
        }
        return output
    }

    static func cyrillicKey(for word: String, toCyrillic: (String) -> String) -> String {
        toCyrillic(word)
    }

    static func emojis(forCyrillicKey key: String, lexicon: [String: [String]]) -> [String] {
        lexicon[key] ?? []
    }

    static func isEmojiSuggestion(_ suggestion: Autocomplete.Suggestion) -> Bool {
        let text = suggestion.text
        guard !text.isEmpty else { return false }
        if text.unicodeScalars.contains(where: CharacterSet.letters.contains) {
            return false
        }
        return text.unicodeScalars.contains {
            $0.properties.isEmoji || $0.properties.isEmojiPresentation || isEmojiModifier($0)
        }
    }

    private static func isEmojiModifier(_ scalar: UnicodeScalar) -> Bool {
        switch scalar.value {
        case 0x200D, 0xFE0F, 0xFE0E:
            return true
        default:
            return false
        }
    }

    static func partition(
        _ suggestions: [Autocomplete.Suggestion]
    ) -> (words: [Autocomplete.Suggestion], emojis: [Autocomplete.Suggestion]) {
        let words = suggestions.filter { !isEmojiSuggestion($0) }
        let emojis = suggestions.filter(isEmojiSuggestion)
        return (words, emojis)
    }

    enum BarLayout: Equatable {
        case empty
        case wordsOnly
        case emojisOnly
        case wordAndEmojis
    }

    static func barLayout(
        wordSuggestions: [Autocomplete.Suggestion],
        emojiSuggestions: [Autocomplete.Suggestion]
    ) -> BarLayout {
        let hasWords = !wordSuggestions.isEmpty
        let hasEmojis = !emojiSuggestions.isEmpty
        switch (hasWords, hasEmojis) {
        case (false, false): return .empty
        case (true, false): return .wordsOnly
        case (false, true): return .emojisOnly
        case (true, true): return .wordAndEmojis
        }
    }

    static func usesThreeColumnBar(
        word: Autocomplete.Suggestion?,
        emojis: [Autocomplete.Suggestion]
    ) -> Bool {
        word != nil || !emojis.isEmpty
    }

    static let emojiItemWidth: CGFloat = 44

    static func emojiRowWidth(emojiCount: Int) -> CGFloat {
        CGFloat(max(emojiCount, 0)) * emojiItemWidth
    }

    static func emojiRowFits(emojiCount: Int, in availableWidth: CGFloat) -> Bool {
        emojiRowWidth(emojiCount: emojiCount) <= availableWidth
    }

    static func shouldScrollThreeColumnBar(emojiCount: Int, in totalWidth: CGFloat) -> Bool {
        guard emojiCount > 0, totalWidth > 0 else { return false }
        return !emojiRowFits(emojiCount: emojiCount, in: totalWidth / 3)
    }

    static func build(
        word: String,
        direction: BLDirection,
        convert: (String, BLDirection) -> String,
        lexicon: [String: [String]]
    ) -> [Autocomplete.Suggestion] {
        let lowercasedWord = word.lowercased()
        let display = applyInputCase(from: word, to: convert(lowercasedWord, direction))
        let cyrillicKey = convert(lowercasedWord, .toCyrillic)
        let emojis = emojis(forCyrillicKey: cyrillicKey, lexicon: lexicon)
        guard display != word || !emojis.isEmpty else { return [] }

        var suggestions: [Autocomplete.Suggestion] = []
        if display != word {
            suggestions.append(
                Autocomplete.Suggestion(
                    text: display,
                    title: display,
                    isAutocorrect: false,
                    subtitle: nil
                )
            )
        }
        for emoji in emojis {
            suggestions.append(
                Autocomplete.Suggestion(
                    text: emoji,
                    title: emoji,
                    isAutocorrect: false,
                    subtitle: nil
                )
            )
        }
        return suggestions
    }
}
