//
//  DKKeyboardEmojiCollectionViewCell.swift
//  Drukarnik
//
//  Created by Logout on 25.11.23.
//

import UIKit

class DKKeyboardEmojiCollectionViewCell: UICollectionViewCell {
    
    private var emoji: String?
    private let label = UILabel()

    static let reuseIdentifier = "cellEmoji"
    override var reuseIdentifier: String? { Self.reuseIdentifier }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureCell()
    }
    
    private func configureCell() {
        let fontSize = DKKeyboardEmojiCollectionView.cellSize / 1.1
        self.label.font = UIFont.systemFont(ofSize: fontSize)
        self.contentView.addSubview(self.label)
        self.label.frame = CGRect(origin: CGPoint.zero,
                                  size: CGSize(width: fontSize*2, height: fontSize*2))
        let center = CGPoint(x: DKKeyboardEmojiCollectionView.cellSize*1.25  / 2.0,
                             y: DKKeyboardEmojiCollectionView.cellSize / 2.0)
        self.label.center = center

//        self.contentView.backgroundColor = UIColor.green
    }
    
    var emojiLabel: String? {
        get {
            self.emoji
        }
        set {
            self.emoji = newValue
            self.label.text = newValue
            self.layoutSubviews()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let fontSize = DKKeyboardEmojiCollectionView.cellSize / 1.1
        if self.label.font.pointSize != fontSize {
            self.label.font = UIFont.systemFont(ofSize: fontSize)
            self.label.frame = CGRect(origin: CGPoint.zero,
                                      size: CGSize(width: fontSize*2, height: fontSize*2))
        }
        let center = CGPoint(x: DKKeyboardEmojiCollectionView.cellSize*1.25  / 2.0,
                             y: DKKeyboardEmojiCollectionView.cellSize / 2.0)
        self.label.center = center
    }
}
