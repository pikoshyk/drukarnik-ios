import Foundation
import SwiftUI

enum DKKeyboardEmojiLayoutMetrics {
    static let minimumCellSize: CGFloat = 40
    static let sizeChangeThreshold: CGFloat = 0.5
    static let partialColumnBuffer: CGFloat = 2
    static let itemWidthMultiplier: CGFloat = 1.25

    static func visibleEmojiCount(panelWidth: CGFloat, itemWidth: CGFloat, rows: Int) -> Int {
        guard itemWidth > 0, rows > 0, panelWidth > 0 else {
            return 0
        }
        let columns = Int(ceil(panelWidth / itemWidth + partialColumnBuffer))
        return columns * rows
    }

    static func cellMetrics(panelHeight: CGFloat) -> (cellSize: CGFloat, rows: Int) {
        guard panelHeight > 0 else {
            return (minimumCellSize, 5)
        }

        var rows = 5
        var cellSize = panelHeight / CGFloat(rows)
        if cellSize < minimumCellSize {
            rows = 4
            cellSize = panelHeight / CGFloat(rows)
        }
        return (cellSize, rows)
    }

    static func shouldInvalidateLayout(oldSize: CGFloat, newSize: CGFloat) -> Bool {
        abs(oldSize - newSize) > sizeChangeThreshold
    }
}

class DKKeyboardEmojiCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        self.scrollDirection = .horizontal
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.scrollDirection = .horizontal
    }
}

class DKKeyboardEmojiCollectionView: UICollectionView {

    public static var cellSize: CGFloat = 40
    public static var countOfEmojiInColumn: Int = 5
    public static var countEmojisOnScreen: Int = 100

    private let viewModel: DKKeyboardEmojiViewModel

    init(_ viewModel: DKKeyboardEmojiViewModel) {
        self.viewModel = viewModel
        let collectionViewFlowLayout = DKKeyboardEmojiCollectionViewFlowLayout()
        super.init(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        self.viewModel.collectionDelegate = self
        self.configureCollectionView()

        self.viewModel.onReloadCollectionViewData = { [weak self] in
            self?.reloadData()
        }
        self.viewModel.onReloadRecentSectionData = { [weak self] in
            self?.reloadRecentSection()
        }
    }

    func reloadRecentSection() {
        let offset = self.contentOffset
        UIView.performWithoutAnimation {
            self.reloadSections(IndexSet(integer: 0))
            self.layoutIfNeeded()
            self.setContentOffset(offset, animated: false)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureCollectionView() {
        self.register(DKKeyboardEmojiCollectionViewCell.self, forCellWithReuseIdentifier: DKKeyboardEmojiCollectionViewCell.reuseIdentifier)
        self.showsHorizontalScrollIndicator = false
        self.isPrefetchingEnabled = false
        self.backgroundColor = UIColor.clear
        self.delegate = self
        self.dataSource = self
    }

    func recalculateCellSize(collectionView: UICollectionView) -> Bool {
        let emojiPanelViewHeight = collectionView.bounds.height
        let emojiPanelViewWidth = collectionView.bounds.width

        if emojiPanelViewHeight == 0 {
            return false
        }

        let metrics = DKKeyboardEmojiLayoutMetrics.cellMetrics(panelHeight: emojiPanelViewHeight)
        let newCellSize = metrics.cellSize
        let countOfEmojiInColumn = metrics.rows

        if !DKKeyboardEmojiLayoutMetrics.shouldInvalidateLayout(oldSize: Self.cellSize, newSize: newCellSize),
           Self.countOfEmojiInColumn == countOfEmojiInColumn {
            return false
        }

        Self.cellSize = newCellSize
        Self.countOfEmojiInColumn = countOfEmojiInColumn
        let itemWidth = Self.cellSize * DKKeyboardEmojiLayoutMetrics.itemWidthMultiplier
        Self.countEmojisOnScreen = DKKeyboardEmojiLayoutMetrics.visibleEmojiCount(
            panelWidth: emojiPanelViewWidth,
            itemWidth: itemWidth,
            rows: countOfEmojiInColumn
        )

        return true
    }

    override func layoutSubviews() {
        if self.recalculateCellSize(collectionView: self) {
            self.collectionViewLayout.invalidateLayout()
        }
        super.layoutSubviews()
    }

    func refreshCurrentSectionId() {
        guard let section = self.indexPathsForVisibleItems.first?.section else {
            return
        }
        let sectionId = self.viewModel.sections[section].id
        self.viewModel.onSectionChanged(sectionId)
    }
}

extension DKKeyboardEmojiCollectionView: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = self.viewModel.sections.count
        return count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.viewModel.sections[section].items.count
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DKKeyboardEmojiCollectionViewCell.reuseIdentifier, for: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cellX = cell as? DKKeyboardEmojiCollectionViewCell {
            let emoji = self.viewModel.sections[indexPath.section].emoji(indexPath.row)
            cellX.emojiLabel = emoji
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cellX = cell as? DKKeyboardEmojiCollectionViewCell {
            cellX.clearCell()
        }
    }
}

extension DKKeyboardEmojiCollectionView: UICollectionViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.refreshCurrentSectionId()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.refreshCurrentSectionId()
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.refreshCurrentSectionId()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoji = self.viewModel.sections[indexPath.section].emoji(indexPath.row)
        self.viewModel.onEmojiBlock?(emoji)
    }
}

extension DKKeyboardEmojiCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Self.cellSize * DKKeyboardEmojiLayoutMetrics.itemWidthMultiplier, height: Self.cellSize)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension DKKeyboardEmojiCollectionView: DKEmojiSectionDelegate {

    func scrollToSection(sectionId: DKEmojiSectionType) {
        let sectionIds = self.viewModel.sections.compactMap { $0.id }
        guard var section = sectionIds.firstIndex(of: sectionId) else {
            return
        }
        if self.collectionView(self, numberOfItemsInSection: section) == 0 {
            section += 1
        }
        self.scrollToItem(at: IndexPath(row: 0, section: section), at: .left, animated: false)
        let x = self.contentOffset.x;
        self.setContentOffset(CGPoint(x: x, y: 0), animated: false)
    }

}

@available(iOS, introduced: 17.0)
#Preview {
    let viewController = UIStoryboard(name: "DKKeyboardEmoji", bundle: Bundle.main).instantiateInitialViewController()
    return viewController!
}
