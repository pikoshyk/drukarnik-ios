import XCTest

final class DKKeyboardEmojiLayoutMetricsTests: XCTestCase {
    func testVisibleCountIPhonePortrait() {
        let metrics = DKKeyboardEmojiLayoutMetrics.cellMetrics(panelHeight: 200)
        let itemWidth = metrics.cellSize * DKKeyboardEmojiLayoutMetrics.itemWidthMultiplier
        let visible = DKKeyboardEmojiLayoutMetrics.visibleEmojiCount(
            panelWidth: 390,
            itemWidth: itemWidth,
            rows: metrics.rows
        )
        let expectedColumns = Int(ceil(390 / itemWidth + DKKeyboardEmojiLayoutMetrics.partialColumnBuffer))
        XCTAssertEqual(visible, expectedColumns * metrics.rows)
    }

    func testVisibleCountIPadLandscape() {
        let metrics = DKKeyboardEmojiLayoutMetrics.cellMetrics(panelHeight: 260)
        let itemWidth = metrics.cellSize * DKKeyboardEmojiLayoutMetrics.itemWidthMultiplier
        let visible = DKKeyboardEmojiLayoutMetrics.visibleEmojiCount(
            panelWidth: 1024,
            itemWidth: itemWidth,
            rows: metrics.rows
        )
        XCTAssertGreaterThan(visible, metrics.rows * 5)
    }

    func testCellMetricsUsesFourRowsWhenHeightIsTight() {
        let metrics = DKKeyboardEmojiLayoutMetrics.cellMetrics(panelHeight: 150)
        XCTAssertEqual(metrics.rows, 4)
        XCTAssertEqual(metrics.cellSize, 37.5)
    }

    func testShouldInvalidateLayoutThreshold() {
        XCTAssertFalse(DKKeyboardEmojiLayoutMetrics.shouldInvalidateLayout(oldSize: 40, newSize: 40.4))
        XCTAssertTrue(DKKeyboardEmojiLayoutMetrics.shouldInvalidateLayout(oldSize: 40, newSize: 41))
    }
}
