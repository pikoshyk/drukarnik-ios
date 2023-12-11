//
//  DKKeyboardEmojiCollectionView.swift
//  Drukarnik
//
//  Created by Logout on 25.11.23.
//

import Foundation
import SwiftUI

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
    
    public static var cellSize: CGFloat = 30
    public static var countOfEmojiInColumn: Int = 5
    public static let minialEmojiCellSize: CGFloat = 30
    public static var countEmojisOnScreen: Int = 100

    private let viewModel: DKKeyboardEmojiViewModel

    init(_ viewModel: DKKeyboardEmojiViewModel) {
        self.viewModel = viewModel
        let collectionViewFlowLayout = DKKeyboardEmojiCollectionViewFlowLayout()
        super.init(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        self.viewModel.collectionDelegate = self
        self.configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureCollectionView() {
        self.register(DKKeyboardEmojiCollectionViewCell.self, forCellWithReuseIdentifier: DKKeyboardEmojiCollectionViewCell.reuseIdentifier)
        self.showsHorizontalScrollIndicator = false
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

        var countOfEmojiInColumn = 5
        var emojiSide = emojiPanelViewHeight / CGFloat(countOfEmojiInColumn)
        if emojiSide < Self.minialEmojiCellSize {
            countOfEmojiInColumn = 4
            emojiSide = emojiPanelViewHeight / CGFloat(countOfEmojiInColumn)
        }
        let newCellSize = emojiSide

        if Self.cellSize == newCellSize && Self.countOfEmojiInColumn == countOfEmojiInColumn {
            return false
        }
        Self.cellSize = newCellSize
        Self.countOfEmojiInColumn = countOfEmojiInColumn
        Self.countEmojisOnScreen = countOfEmojiInColumn * Int(ceil(emojiPanelViewWidth / Self.cellSize))
        
        return true
    }

    override func layoutSubviews() {
        if self.recalculateCellSize(collectionView: self) {
            DispatchQueue.main.async {
                self.collectionViewLayout.invalidateLayout()
            }
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
//        _ = self.recalculateCellSize(collectionView: collectionView)
        return CGSize(width: Self.cellSize*1.25, height: Self.cellSize)
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
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        
//        let left = (section == 0) ? Self.sectionSpace : Self.cellSpace
//        var right = Self.sectionSpace
//        if self.viewModel.sections.count == section + 1{
//            right = Self.cellSpace
//        }
//        
//        return UIEdgeInsets(top: Self.cellSpace,
//                            left: left,
//                            bottom: Self.cellSpace,
//                            right: right)
//    }
}

extension DKKeyboardEmojiCollectionView: DKEmojiSectionDelegate {
    
    func scrollToSection(sectionId: DKEmojiSectionType) {
        let sectionIds = self.viewModel.sections.compactMap { $0.id }
        guard let section = sectionIds.firstIndex(of: sectionId) else {
            return
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
