import KeyboardKit
import XCTest

final class DKKeyboardEmojiRecentsTests: XCTestCase {

    private func emoji(_ text: String) -> Autocomplete.Suggestion {
        Autocomplete.Suggestion(text: text, title: text)
    }

    private func word(_ text: String) -> Autocomplete.Suggestion {
        Autocomplete.Suggestion(text: text, title: text)
    }

    func testRecord_insertsNewEmojiAtFront() {
        let now = Date(timeIntervalSince1970: 100)
        let result = DKKeyboardEmojiRecents.record(emoji: "😀", in: [], now: now)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.emoji, "😀")
        XCTAssertEqual(result.first?.usage, [now])
    }

    func testRecord_appendsUsageForExistingEmoji() {
        let older = Date(timeIntervalSince1970: 50)
        let newer = Date(timeIntervalSince1970: 100)
        let existing = DKKeyboardEmojiRecentsItem(emoji: "😀", usage: [older])
        let result = DKKeyboardEmojiRecents.record(emoji: "😀", in: [existing], now: newer)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.usage.count, 2)
        XCTAssertEqual(result.first?.usage.first, newer)
    }

    func testRecord_trimsUsageDatesToTen() {
        let usage = (0..<10).map { Date(timeIntervalSince1970: Double($0)) }
        let existing = DKKeyboardEmojiRecentsItem(emoji: "😀", usage: usage)
        let now = Date(timeIntervalSince1970: 100)
        let result = DKKeyboardEmojiRecents.record(emoji: "😀", in: [existing], now: now)
        XCTAssertEqual(result.first?.usage.count, 10)
        XCTAssertEqual(result.first?.usage.first, now)
    }

    func testRecord_sortsByMostRecentUsage() {
        let t1 = Date(timeIntervalSince1970: 10)
        let t2 = Date(timeIntervalSince1970: 20)
        let t3 = Date(timeIntervalSince1970: 30)
        let a = DKKeyboardEmojiRecentsItem(emoji: "😀", usage: [t1])
        let b = DKKeyboardEmojiRecentsItem(emoji: "🙂", usage: [t2])
        let result = DKKeyboardEmojiRecents.record(emoji: "👍", in: [a, b], now: t3)
        XCTAssertEqual(result.map(\.emoji), ["👍", "🙂", "😀"])
    }

    func testRecord_trimsListToThirtyTwoItems() {
        var recents: [DKKeyboardEmojiRecentsItem] = []
        for index in 0..<32 {
            let date = Date(timeIntervalSince1970: Double(index))
            recents.append(DKKeyboardEmojiRecentsItem(emoji: "e\(index)", usage: [date]))
        }
        let now = Date(timeIntervalSince1970: 1000)
        let result = DKKeyboardEmojiRecents.record(emoji: "new", in: recents, now: now)
        XCTAssertEqual(result.count, 32)
        XCTAssertEqual(result.first?.emoji, "new")
        XCTAssertFalse(result.contains(where: { $0.emoji == "e0" }))
    }

    func testSuggestionAction_emojiRecordsRecent() {
        var inserted: Autocomplete.Suggestion?
        var recorded: String?
        let suggestion = emoji("😇")
        DKAutocompleteSuggestionAction.perform(
            suggestion: suggestion,
            autocompleteAction: { inserted = $0 },
            recordRecentEmoji: { recorded = $0 }
        )
        XCTAssertEqual(inserted?.text, "😇")
        XCTAssertEqual(recorded, "😇")
    }

    func testReloadRecentSection_readsFromRecentsBlock() {
        let viewModel = DKKeyboardEmojiViewModel()
        var recents = ["😀"]
        viewModel.onRecentsBlock = { recents }
        viewModel.reloadRecentSection()
        XCTAssertEqual(viewModel.recentSection.items, ["😀"])
        recents = ["🙂", "😀"]
        viewModel.reloadRecentSection()
        XCTAssertEqual(viewModel.recentSection.items, ["🙂", "😀"])
    }

    func testSuggestionAction_wordDoesNotRecordRecent() {
        var inserted: Autocomplete.Suggestion?
        var recorded: String?
        let suggestion = word("добра")
        DKAutocompleteSuggestionAction.perform(
            suggestion: suggestion,
            autocompleteAction: { inserted = $0 },
            recordRecentEmoji: { recorded = $0 }
        )
        XCTAssertEqual(inserted?.text, "добра")
        XCTAssertNil(recorded)
    }
}
