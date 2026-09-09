import KeyboardKit
import XCTest

final class DKAutocompleteToolbarLogicTests: XCTestCase {

    private func word(_ text: String) -> Autocomplete.Suggestion {
        Autocomplete.Suggestion(text: text, title: text)
    }

    private func emoji(_ text: String) -> Autocomplete.Suggestion {
        Autocomplete.Suggestion(text: text, title: text)
    }

    func testToolbarContent_showsSuggestionsWhenAvailable() {
        XCTAssertEqual(
            DKKeyboardToolbarContent.resolve(hasAutosuggestions: true, showSettingsView: false),
            .suggestions
        )
    }

    func testToolbarContent_showsOptionsWhenSettingsOpen() {
        XCTAssertEqual(
            DKKeyboardToolbarContent.resolve(hasAutosuggestions: true, showSettingsView: true),
            .options
        )
    }

    func testToolbarContent_showsOptionsWithoutSuggestions() {
        XCTAssertEqual(
            DKKeyboardToolbarContent.resolve(hasAutosuggestions: false, showSettingsView: false),
            .options
        )
    }

    func testPartition_splitsWordsAndEmoji() {
        let suggestions = [word("добра"), emoji("😇"), emoji("🥰")]
        let partition = DKAutocompleteWordSuggestions.partition(suggestions)

        XCTAssertEqual(partition.words.map(\.text), ["добра"])
        XCTAssertEqual(partition.emojis.map(\.text), ["😇", "🥰"])
    }

    func testBarLayout_wordsOnly() {
        XCTAssertEqual(
            DKAutocompleteWordSuggestions.barLayout(wordSuggestions: [word("добра")], emojiSuggestions: []),
            .wordsOnly
        )
        XCTAssertTrue(DKAutocompleteWordSuggestions.usesThreeColumnBar(word: word("добра"), emojis: []))
    }

    func testBarLayout_emojisOnly() {
        let emojis = [emoji("😇"), emoji("🥰")]
        XCTAssertEqual(
            DKAutocompleteWordSuggestions.barLayout(wordSuggestions: [], emojiSuggestions: emojis),
            .emojisOnly
        )
        XCTAssertTrue(DKAutocompleteWordSuggestions.usesThreeColumnBar(word: nil, emojis: emojis))
    }

    func testBarLayout_wordAndEmojis() {
        let emojis = [emoji("😇")]
        XCTAssertEqual(
            DKAutocompleteWordSuggestions.barLayout(
                wordSuggestions: [word("добра")],
                emojiSuggestions: emojis
            ),
            .wordAndEmojis
        )
        XCTAssertTrue(DKAutocompleteWordSuggestions.usesThreeColumnBar(word: word("добра"), emojis: emojis))
    }

    func testBarLayout_empty() {
        XCTAssertEqual(
            DKAutocompleteWordSuggestions.barLayout(wordSuggestions: [], emojiSuggestions: []),
            .empty
        )
        XCTAssertFalse(DKAutocompleteWordSuggestions.usesThreeColumnBar(word: nil, emojis: []))
    }

    func testIsEmojiSuggestion_recognizesCompositeHeartEmoji() {
        XCTAssertTrue(DKAutocompleteWordSuggestions.isEmojiSuggestion(emoji("❤️‍🔥")))
        XCTAssertTrue(DKAutocompleteWordSuggestions.isEmojiSuggestion(emoji("♥️")))
        XCTAssertTrue(DKAutocompleteWordSuggestions.isEmojiSuggestion(emoji("❤️")))
    }

    func testIsEmojiSuggestion_rejectsTransliterationWord() {
        XCTAssertFalse(DKAutocompleteWordSuggestions.isEmojiSuggestion(word("siertsa")))
    }

    func testEmojiRowFits_whenThereIsEnoughSpace() {
        XCTAssertTrue(DKAutocompleteWordSuggestions.emojiRowFits(emojiCount: 2, in: 88))
        XCTAssertFalse(DKAutocompleteWordSuggestions.emojiRowFits(emojiCount: 3, in: 88))
    }

    func testShouldScrollThreeColumnBar_whenRightColumnOverflows() {
        XCTAssertFalse(DKAutocompleteWordSuggestions.shouldScrollThreeColumnBar(emojiCount: 0, in: 300))
        XCTAssertFalse(DKAutocompleteWordSuggestions.shouldScrollThreeColumnBar(emojiCount: 2, in: 300))
        XCTAssertTrue(DKAutocompleteWordSuggestions.shouldScrollThreeColumnBar(emojiCount: 3, in: 300))
    }

    func testEmojiRowWidth_usesFixedItemWidth() {
        XCTAssertEqual(DKAutocompleteWordSuggestions.emojiRowWidth(emojiCount: 5), 220)
    }

    func testPartition_sercaKeepsWordSeparateFromEmoji() {
        let suggestions = [word("siertsa")] + [
            "🥰", "😘", "🩷", "❤️", "❤️‍🔥", "♥️", "❣️"
        ].map(emoji)
        let partition = DKAutocompleteWordSuggestions.partition(suggestions)

        XCTAssertEqual(partition.words.map(\.text), ["siertsa"])
        XCTAssertEqual(partition.emojis.count, 7)
        XCTAssertEqual(
            DKAutocompleteWordSuggestions.barLayout(
                wordSuggestions: partition.words,
                emojiSuggestions: partition.emojis
            ),
            .wordAndEmojis
        )
    }
}
