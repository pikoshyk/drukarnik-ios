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

    func testToolbarWordColumns_rawAndConverted() {
        let columns = DKAutocompleteWordSuggestions.toolbarWordColumns(
            from: [word("dobra"), word("добра")]
        )
        XCTAssertEqual(columns.raw?.text, "dobra")
        XCTAssertEqual(columns.converted?.text, "добра")
    }

    func testToolbarWordColumns_singleWordGoesToCenter() {
        let columns = DKAutocompleteWordSuggestions.toolbarWordColumns(from: [word("добра")])
        XCTAssertNil(columns.raw)
        XCTAssertEqual(columns.converted?.text, "добра")
    }

    func testToolbarWordColumns_empty() {
        let columns = DKAutocompleteWordSuggestions.toolbarWordColumns(from: [])
        XCTAssertNil(columns.raw)
        XCTAssertNil(columns.converted)
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
        let inset = DKAutocompleteWordSuggestions.emojiRowHorizontalInset
        XCTAssertTrue(DKAutocompleteWordSuggestions.emojiRowFits(emojiCount: 2, in: 88 + 2 * inset))
        XCTAssertFalse(DKAutocompleteWordSuggestions.emojiRowFits(emojiCount: 3, in: 88 + 2 * inset))
    }

    func testShouldScrollThreeColumnBar_whenRightColumnOverflows() {
        let totalWidth: CGFloat = 300
        let columnWidth = totalWidth / 3

        XCTAssertFalse(DKAutocompleteWordSuggestions.shouldScrollThreeColumnBar(emojiCount: 0, in: totalWidth))

        for count in 1...4 {
            let fits = DKAutocompleteWordSuggestions.emojiRowFits(emojiCount: count, in: columnWidth)
            let scrolls = DKAutocompleteWordSuggestions.shouldScrollThreeColumnBar(emojiCount: count, in: totalWidth)
            XCTAssertEqual(scrolls, !fits, "emojiCount \(count)")
        }
    }

    func testEmojiRowWidth_usesFixedItemWidth() {
        let inset = DKAutocompleteWordSuggestions.emojiRowHorizontalInset
        XCTAssertEqual(DKAutocompleteWordSuggestions.emojiRowWidth(emojiCount: 5), 220 + 2 * inset)
    }

    func testEmojiRowHorizontalInset_matchesVisualGapBetweenEmoji() {
        XCTAssertEqual(DKAutocompleteWordSuggestions.emojiRowHorizontalInset, 8)
        XCTAssertEqual(
            2 * DKAutocompleteWordSuggestions.emojiRowHorizontalInset,
            DKAutocompleteWordSuggestions.emojiItemWidth - DKAutocompleteWordSuggestions.emojiFontSize
        )
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
