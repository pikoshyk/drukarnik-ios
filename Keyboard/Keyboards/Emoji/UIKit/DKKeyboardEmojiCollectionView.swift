//
//  DKKeyboardEmojiCollectionView.swift
//  Drukarnik
//
//  Created by Logout on 25.11.23.
//

import SwiftUI

class DKKeyboardEmojiCollectionView: UICollectionView {
    
    static var cellSize: CGFloat = 25.0
    private static var cellSpace: CGFloat = 0.0
    private static let sectionSpace: CGFloat = 16.0
    
    private let viewModel: DKKeyboardEmojiViewModel

    init(_ viewModel: DKKeyboardEmojiViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.viewModel.collectionDelegate = self
        self.configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureCollectionView() {
        self.dataSource = self
        self.delegate = self
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = UIColor.clear
        self.register(DKKeyboardEmojiCollectionViewCell.self, forCellWithReuseIdentifier: DKKeyboardEmojiCollectionViewCell.reuseIdentifier)
        self.updateLayout()
    }
    
    private func updateLayout() {
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = Self.cellSpace
            layout.minimumInteritemSpacing = Self.cellSpace
        }
        self.layoutSubviews()
    }
    
    var emojiPanelViewHeight: CGFloat {
        let height = self.frame.height
        return height
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let emojiPanelViewHeight = self.emojiPanelViewHeight
        if emojiPanelViewHeight == 0 {
            return
        }

        let countOfEmojiInColumn = 5.0
        let spaceForOneEmoji = self.emojiPanelViewHeight / countOfEmojiInColumn
        let newCellSize = spaceForOneEmoji - Self.cellSpace*(countOfEmojiInColumn+1)

        if Self.cellSize == newCellSize {
            return
        }

        Self.cellSize = newCellSize
        super.layoutSubviews()
        self.updateLayout()
        self.collectionViewLayout.invalidateLayout()
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
        if let cellX = cell as? DKKeyboardEmojiCollectionViewCell {
            let emoji = self.viewModel.sections[indexPath.section].emoji(indexPath.row)
            cellX.emojiLabel = emoji
        }
        return cell
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
        self.viewModel.onPress(emoji)
    }
}

extension DKKeyboardEmojiCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Self.cellSize*1.25, height: Self.cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let left = (section == 0) ? Self.sectionSpace : Self.cellSpace
        var right = Self.sectionSpace
        if self.viewModel.sections.count == section + 1{
            right = Self.cellSpace
        }
        
        return UIEdgeInsets(top: Self.cellSpace,
                            left: left,
                            bottom: Self.cellSpace,
                            right: right)
    }
}

extension DKKeyboardEmojiCollectionView: DKEmojiSectionDelegate {
    
    func scrollToSection(sectionId: DKEmojiSectionType) {
        let sectionIds = self.viewModel.sections.compactMap { $0.id }
        guard let section = sectionIds.firstIndex(of: sectionId) else {
            return
        }

        self.scrollToItem(at: IndexPath(row: 0, section: section), at: .left, animated: false)
        let x = self.contentOffset.x - Self.sectionSpace;
        self.setContentOffset(CGPoint(x: x, y: 0), animated: false)
    }

}


@available(iOS, introduced: 17.0)
#Preview {
    let viewController = UIStoryboard(name: "DKKeyboardEmoji", bundle: Bundle.main).instantiateInitialViewController()
    return viewController!
}
