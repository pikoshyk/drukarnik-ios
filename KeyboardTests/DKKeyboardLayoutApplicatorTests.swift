import XCTest

final class DKKeyboardLayoutApplicatorTests: XCTestCase {
    func testApplyLayoutDoesNotRecreateWhenSameLayout() {
        var applicator = DKKeyboardLayoutApplicator()
        XCTAssertTrue(applicator.applyLayout(.latin))
        XCTAssertEqual(applicator.layoutChangeCount, 1)
        XCTAssertFalse(applicator.applyLayout(.latin))
        XCTAssertEqual(applicator.layoutChangeCount, 1)
    }

    func testApplyLayoutRecreatesWhenLayoutChanges() {
        var applicator = DKKeyboardLayoutApplicator()
        XCTAssertTrue(applicator.applyLayout(.latin))
        XCTAssertTrue(applicator.applyLayout(.cyrillic))
        XCTAssertEqual(applicator.layoutChangeCount, 2)
        XCTAssertEqual(applicator.appliedLayout, .cyrillic)
    }

    func testForceApplyLayoutIncrementsCount() {
        var applicator = DKKeyboardLayoutApplicator()
        XCTAssertTrue(applicator.applyLayout(.latin))
        XCTAssertTrue(applicator.applyLayout(.latin, force: true))
        XCTAssertEqual(applicator.layoutChangeCount, 2)
    }
}
