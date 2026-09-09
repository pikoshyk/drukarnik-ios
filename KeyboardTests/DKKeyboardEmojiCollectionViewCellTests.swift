import UIKit
import XCTest

final class DKKeyboardEmojiCollectionViewCellTests: XCTestCase {
    func testConfigureSingleCellManyTimesDoesNotLeakLayers() {
        let cell = DKKeyboardEmojiCollectionViewCell(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        DKKeyboardEmojiCollectionView.cellSize = 40

        measure(metrics: [XCTMemoryMetric()]) {
            for index in 0..<1000 {
                cell.emojiLabel = index.isMultiple(of: 2) ? "😀" : "❤️"
                cell.layoutIfNeeded()
            }
        }
    }
}
