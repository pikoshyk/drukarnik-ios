//
//  DKKeyboardEmojiCollectionView.swift
//  Drukarnik
//
//  Created by Logout on 25.11.23.
//

import Foundation
import SwiftUI

class DKKeyboardEmojiCollectionView: UICollectionView {
    
    public static var cellSize: CGFloat = 25.0
    public static var cellSpace: CGFloat = 0.0
    public static let sectionSpace: CGFloat = 16.0
    public static let countOfEmojiInColumn: Int = 5
    public static var countEmojisOnScreen: Int = 100

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

    var emojiPanelViewWidth: CGFloat {
        let width = self.frame.width
        return width
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let emojiPanelViewHeight = self.emojiPanelViewHeight
        if emojiPanelViewHeight == 0 {
            return
        }

        let spaceForOneEmoji = self.emojiPanelViewHeight / CGFloat(Self.countOfEmojiInColumn)
        let newCellSize = spaceForOneEmoji - Self.cellSpace*CGFloat(Self.countOfEmojiInColumn+1)

        if Self.cellSize == newCellSize {
            return
        }

        Self.cellSize = newCellSize
        Self.countEmojisOnScreen = Self.countOfEmojiInColumn * Int(ceil(self.emojiPanelViewWidth / Self.cellSize))
        
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
