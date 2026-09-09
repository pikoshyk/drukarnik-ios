import XCTest

final class DKEmojiAutocompleteLexiconTests: XCTestCase {
    override func setUp() {
        super.setUp()
        DKEmojiAutocompleteLexicon.resetForTesting(bundle: Bundle(for: Self.self))
    }

    func testDecodeLexiconFromBundle() {
        let dict = DKEmojiAutocompleteLexicon.emojis
        XCTAssertFalse(dict.isEmpty)
        XCTAssertNotNil(dict["confused"])
    }

    func testLookupReturnsEmojiList() {
        let dict = DKEmojiAutocompleteLexicon.emojis
        let confused = dict["confused"]
        XCTAssertNotNil(confused)
        XCTAssertFalse(confused?.isEmpty ?? true)
    }

    func testSharedInstanceIdentity() {
        let first = DKEmojiAutocompleteLexicon.emojis
        let second = DKEmojiAutocompleteLexicon.emojis
        XCTAssertEqual(first.count, second.count)
        XCTAssertEqual(first["confused"], second["confused"])
    }

    func testParsePerformanceSecondCallIsCached() {
        DKEmojiAutocompleteLexicon.resetForTesting(bundle: Bundle(for: Self.self))
        measure {
            for _ in 0..<50 {
                _ = DKEmojiAutocompleteLexicon.emojis
            }
        }
    }

    func testLookupPerformance() {
        let dict = DKEmojiAutocompleteLexicon.emojis
        measure {
            for _ in 0..<500 {
                _ = dict["confused"]
            }
        }
    }

    func testStressLookupsWithoutGrowth() {
        let dict = DKEmojiAutocompleteLexicon.emojis
        let initialCount = dict.count
        for _ in 0..<10_000 {
            _ = dict["confused"]
            _ = dict["добра"]
        }
        XCTAssertEqual(DKEmojiAutocompleteLexicon.emojis.count, initialCount)
    }
}
