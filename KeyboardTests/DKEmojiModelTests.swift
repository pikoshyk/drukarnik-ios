import XCTest

final class DKEmojiModelTests: XCTestCase {
    func testSharedModelIdentity() {
        let first = DKEmojiModel.shared
        let second = DKEmojiModel.shared
        XCTAssertEqual(first.totalEmojiCount, second.totalEmojiCount)
    }

    func testSectionsAreNotEmptyOnSupportedOS() {
        if #available(iOS 17.4, *) {
            let model = DKEmojiModel.shared
            XCTAssertFalse(model.smileys.isEmpty)
            XCTAssertFalse(model.nature.isEmpty)
            XCTAssertGreaterThan(model.totalEmojiCount, 100)
        }
    }
}
