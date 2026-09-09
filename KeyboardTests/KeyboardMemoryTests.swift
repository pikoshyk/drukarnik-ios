import XCTest

final class KeyboardMemoryTests: XCTestCase {
    override func setUp() {
        super.setUp()
        DKEmojiAutocompleteLexicon.resetForTesting(bundle: Bundle(for: Self.self))
    }

    func testEmojiLexiconProviderCreationDoesNotGrowLinearly() {
        measure(metrics: [XCTMemoryMetric()]) {
            for _ in 0..<200 {
                _ = DKEmojiAutocompleteLexicon.emojis
            }
        }
    }

    func testEmojiViewModelCreationUsesSharedModel() {
        measure(metrics: [XCTMemoryMetric()]) {
            for _ in 0..<100 {
                _ = DKKeyboardEmojiViewModel()
            }
        }
    }

    func testLayoutApplicatorAppearCycleDoesNotGrow() {
        var applicator = DKKeyboardLayoutApplicator()
        measure(metrics: [XCTMemoryMetric()]) {
            for _ in 0..<200 {
                applicator.applyLayout(.latin)
                applicator.applyLayout(.latin)
            }
        }
    }
}
