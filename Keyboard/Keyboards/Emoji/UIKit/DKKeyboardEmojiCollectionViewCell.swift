import UIKit

class DKKeyboardEmojiCollectionViewCell: UICollectionViewCell {

    private let emojiLabelView = UILabel()

    static let reuseIdentifier = "cellEmoji"
    override var reuseIdentifier: String? { Self.reuseIdentifier }

    static func dequeue(from collectionView: UICollectionView, for indexPath: IndexPath) -> DKKeyboardEmojiCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.reuseIdentifier, for: indexPath) as? DKKeyboardEmojiCollectionViewCell ?? DKKeyboardEmojiCollectionViewCell()
        return cell
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.emojiLabelView.textAlignment = .center
        self.contentView.addSubview(self.emojiLabelView)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.emojiLabelView.textAlignment = .center
        self.contentView.addSubview(self.emojiLabelView)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.clearCell()
    }

    func clearCell() {
        self.emojiLabelView.text = nil
    }

    var emojiLabel: String? {
        get {
            self.emojiLabelView.text
        }
        set {
            self.emojiLabelView.text = newValue
            self.emojiLabelView.font = UIFont.systemFont(ofSize: DKKeyboardEmojiCollectionView.cellSize / 1.2)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.emojiLabelView.frame = self.contentView.bounds
    }
}
