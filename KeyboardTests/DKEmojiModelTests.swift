import XCTest

final class DKEmojiModelTests: XCTestCase {
    func testSharedModelIdentity() {
        let first = DKEmojiModel.shared
        let second = DKEmojiModel.shared
        XCTAssertEqual(first.totalEmojiCount, second.totalEmojiCount)
    }

    func testSectionsAreNotEmptyOnSupportedOS() {
        if #available(iOS 26.6, *) {
            let model = DKEmojiModel()
            XCTAssertFalse(model.smileys.isEmpty)
            XCTAssertFalse(model.nature.isEmpty)
            XCTAssertGreaterThan(model.totalEmojiCount, 100)
        } else if #available(iOS 17.4, *) {
            let model = DKEmojiModel.shared
            XCTAssertFalse(model.smileys.isEmpty)
            XCTAssertFalse(model.nature.isEmpty)
            XCTAssertGreaterThan(model.totalEmojiCount, 100)
        }
    }

    func testEmoji17BaseGlyphsOnIOS266Catalog() {
        guard #available(iOS 26.6, *) else { return }
        let model = DKEmojiModel()
        XCTAssertTrue(model.smileys.contains("🫪"))
        XCTAssertTrue(model.smileys.contains("🫯"))
        XCTAssertTrue(model.smileys.contains("🧑‍🩰"))
        XCTAssertTrue(model.nature.contains("🫍"))
        XCTAssertTrue(model.nature.contains("🫈"))
        XCTAssertTrue(model.objects.contains("🪊"))
        XCTAssertTrue(model.travelplaces.contains("🛘"))
        XCTAssertTrue(model.objects.contains("🪎"))
    }
}
