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
        XCTAssertGreaterThan(suggestions.count, 1)
        XCTAssertEqual(suggestions[0].text, convert("dobra", direction: .toCyrillic))
        XCTAssertFalse(DKAutocompleteWordSuggestions.isEmojiSuggestion(suggestions[0]))
    }

    func testCyrillicToLatin_transliteration() {
        let suggestions = DKAutocompleteWordSuggestions.build(
            word: "добра",
            direction: .toLacin,
            convert: convert,
            lexicon: lexicon
        )
        XCTAssertGreaterThan(suggestions.count, 1)
        XCTAssertTrue(suggestions[0].text.lowercased().contains("dobra"))
        XCTAssertFalse(DKAutocompleteWordSuggestions.isEmojiSuggestion(suggestions[0]))
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
        XCTAssertTrue(suggestions.dropFirst().allSatisfy(DKAutocompleteWordSuggestions.isEmojiSuggestion))
        XCTAssertTrue(suggestions.dropFirst().contains { $0.text == "😇" })
    }

    func testEmoji_cyrillicInput_usesSameKey() {
        let suggestions = DKAutocompleteWordSuggestions.build(
            word: "добра",
            direction: .toLacin,
            convert: convert,
            lexicon: lexicon
        )
        XCTAssertTrue(suggestions[0].text.lowercased().contains("dobra"))
        XCTAssertTrue(suggestions.dropFirst().contains { $0.text == "😇" })
    }

    func testEmoji_partialWord_noMatch() {
        let suggestions = DKAutocompleteWordSuggestions.build(
            word: "dobr",
            direction: .toCyrillic,
            convert: convert,
            lexicon: lexicon
        )
        XCTAssertEqual(suggestions.count, 1)
        XCTAssertTrue(suggestions[0].text.contains("добр"))
        XCTAssertFalse(DKAutocompleteWordSuggestions.isEmojiSuggestion(suggestions[0]))
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
        XCTAssertEqual(suggestions.count, 1)
        XCTAssertEqual(suggestions[0].text, convert("dobr", direction: .toCyrillic))
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
    }

    func testLastWord_preservesCase() {
        XCTAssertEqual(DKAutocompleteWordSuggestions.lastWord(from: "Прывітанне Свет"), "Свет")
    }
}
