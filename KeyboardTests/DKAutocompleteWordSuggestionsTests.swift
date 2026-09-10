import BelarusianLacinka
import XCTest

final class DKAutocompleteWordSuggestionsTests: XCTestCase {
    private let converter = BLConverter()
    private lazy var lexicon: [String: [String]] = DKEmojiAutocompleteLexicon.emojis

    override func setUp() {
        super.setUp()
        DKEmojiAutocompleteLexicon.resetForTesting(bundle: Bundle(for: Self.self))
    }

    private func convert(_ text: String, direction: BLDirection) -> String {
        let oldText = " " + text
        var converted = converter.convert(
            text: oldText,
            direction: direction,
            version: .traditional,
            orthograpy: .academic
        )
        converted.removeFirst()
        return converted
    }

    func testLastWord_extractsFromSentence() {
        XCTAssertEqual(DKAutocompleteWordSuggestions.lastWord(from: "прывітанне свет"), "свет")
    }

    func testLastWord_emptyText() {
        XCTAssertNil(DKAutocompleteWordSuggestions.lastWord(from: ""))
        XCTAssertTrue(DKAutocompleteWordSuggestions.build(
            word: "",
            direction: .toCyrillic,
            convert: convert,
            lexicon: lexicon
        ).isEmpty)
    }

    func testLatinToCyrillic_transliteration() {
        let suggestions = DKAutocompleteWordSuggestions.build(
            word: "dobra",
            direction: .toCyrillic,
            convert: convert,
            lexicon: lexicon
        )
        XCTAssertGreaterThan(suggestions.count, 2)
        XCTAssertEqual(suggestions[0].text, "dobra")
        XCTAssertEqual(suggestions[1].text, convert("dobra", direction: .toCyrillic))
        XCTAssertFalse(DKAutocompleteWordSuggestions.isEmojiSuggestion(suggestions[0]))
        XCTAssertFalse(DKAutocompleteWordSuggestions.isEmojiSuggestion(suggestions[1]))
    }

    func testCyrillicToLatin_transliteration() {
        let suggestions = DKAutocompleteWordSuggestions.build(
            word: "добра",
            direction: .toLacin,
            convert: convert,
            lexicon: lexicon
        )
        XCTAssertGreaterThan(suggestions.count, 2)
        XCTAssertEqual(suggestions[0].text, "добра")
        XCTAssertTrue(suggestions[1].text.lowercased().contains("dobra"))
        XCTAssertFalse(DKAutocompleteWordSuggestions.isEmojiSuggestion(suggestions[1]))
    }

    func testEmoji_lookupAlwaysViaCyrillicKey() {
        let suggestions = DKAutocompleteWordSuggestions.build(
            word: "dobra",
            direction: .toCyrillic,
            convert: convert,
            lexicon: lexicon
        )
        XCTAssertNil(lexicon["dobra"])
        XCTAssertNotNil(lexicon["добра"])
        XCTAssertTrue(suggestions.dropFirst(2).allSatisfy(DKAutocompleteWordSuggestions.isEmojiSuggestion))
        XCTAssertTrue(suggestions.dropFirst(2).contains { $0.text == "😇" })
    }

    func testEmoji_cyrillicInput_usesSameKey() {
        let suggestions = DKAutocompleteWordSuggestions.build(
            word: "добра",
            direction: .toLacin,
            convert: convert,
            lexicon: lexicon
        )
        XCTAssertEqual(suggestions[0].text, "добра")
        XCTAssertTrue(suggestions[1].text.lowercased().contains("dobra"))
        XCTAssertTrue(suggestions.dropFirst(2).contains { $0.text == "😇" })
    }

    func testEmoji_partialWord_noMatch() {
        let suggestions = DKAutocompleteWordSuggestions.build(
            word: "dobr",
            direction: .toCyrillic,
            convert: convert,
            lexicon: lexicon
        )
        XCTAssertEqual(suggestions.count, 2)
        XCTAssertEqual(suggestions[0].text, "dobr")
        XCTAssertTrue(suggestions[1].text.contains("добр"))
        XCTAssertFalse(DKAutocompleteWordSuggestions.isEmojiSuggestion(suggestions[1]))
    }

    func testEmoji_noDirectLatinLookup() {
        XCTAssertNotNil(lexicon["confused"])
        let cyrillicKey = convert("confused", direction: .toCyrillic)
        let emojis = DKAutocompleteWordSuggestions.emojis(forCyrillicKey: cyrillicKey, lexicon: lexicon)
        XCTAssertTrue(emojis.isEmpty)
    }

    func testEmoji_eachIsSeparateSuggestion() {
        let suggestions = DKAutocompleteWordSuggestions.build(
            word: "добра",
            direction: .toLacin,
            convert: convert,
            lexicon: lexicon
        )
        let emojiSuggestions = suggestions.filter(DKAutocompleteWordSuggestions.isEmojiSuggestion)
        XCTAssertEqual(emojiSuggestions.count, lexicon["добра"]?.count)
        XCTAssertEqual(Set(emojiSuggestions.map(\.text)), Set(lexicon["добра"] ?? []))
    }

    func testBuild_noMatch_returnsEmpty() {
        let suggestions = DKAutocompleteWordSuggestions.build(
            word: "zzzznotaword",
            direction: .toCyrillic,
            convert: { word, _ in word },
            lexicon: [:]
        )
        XCTAssertTrue(suggestions.isEmpty)
    }

    func testBuild_skipsWhenUnchangedAndNoEmoji() {
        let suggestions = DKAutocompleteWordSuggestions.build(
            word: "zzzznotaword",
            direction: .toLacin,
            convert: { word, _ in word },
            lexicon: [:]
        )
        XCTAssertTrue(suggestions.isEmpty)
    }

    func testAllSuggestions_notAutocorrect() {
        let suggestions = DKAutocompleteWordSuggestions.build(
            word: "dobra",
            direction: .toCyrillic,
            convert: convert,
            lexicon: lexicon
        )
        XCTAssertFalse(suggestions.contains { $0.isAutocorrect })
    }

    func testBuild_alwaysReturnsWhenTranslitDiffers() {
        let suggestions = DKAutocompleteWordSuggestions.build(
            word: "dobr",
            direction: .toCyrillic,
            convert: convert,
            lexicon: [:]
        )
        XCTAssertEqual(suggestions.count, 2)
        XCTAssertEqual(suggestions[0].text, "dobr")
        XCTAssertEqual(suggestions[1].text, convert("dobr", direction: .toCyrillic))
    }

    func testBuild_includesRawWordBeforeConverted() {
        let suggestions = DKAutocompleteWordSuggestions.build(
            word: "dobra",
            direction: .toCyrillic,
            convert: convert,
            lexicon: [:]
        )
        XCTAssertEqual(suggestions.map(\.text), [ "dobra", convert("dobra", direction: .toCyrillic) ])
    }

    func testApplyInputCase_capitalizesFirstLetter() {
        let output = DKAutocompleteWordSuggestions.applyInputCase(from: "Ahon", to: "ahoń")
        XCTAssertEqual(output, "Ahoń")
    }

    func testApplyInputCase_preservesLowercase() {
        let output = DKAutocompleteWordSuggestions.applyInputCase(from: "ahon", to: "ahoń")
        XCTAssertEqual(output, "ahoń")
    }

    func testBuild_preservesInputCapitalization() {
        let suggestions = DKAutocompleteWordSuggestions.build(
            word: "Агонь",
            direction: .toLacin,
            convert: convert,
            lexicon: lexicon
        )
        XCTAssertEqual(suggestions.first?.text.first?.isUppercase, true)
        let columns = DKAutocompleteWordSuggestions.toolbarWordColumns(
            from: suggestions.filter { !DKAutocompleteWordSuggestions.isEmojiSuggestion($0) }
        )
        XCTAssertEqual(columns.converted?.text.first?.isUppercase, true)
    }

    func testLastWord_preservesCase() {
        XCTAssertEqual(DKAutocompleteWordSuggestions.lastWord(from: "Прывітанне Свет"), "Свет")
    }
}
