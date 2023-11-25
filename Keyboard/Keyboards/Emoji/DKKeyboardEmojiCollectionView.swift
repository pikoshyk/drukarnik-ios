//
//  DKKeyboardEmojiCollectionView.swift
//  Drukarnik
//
//  Created by Logout on 25.11.23.
//

import SwiftUI
import UIKit

class DKKeyboardEmojiCollectionViewCell: UICollectionViewCell {
    
    private var emoji: String?
    private let label = UILabel()
    private static let size = CGSize(width: DKKeyboardEmojiCollectionView.cellSize,
                                     height: DKKeyboardEmojiCollectionView.cellSize)

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
        let fontSize = Self.size.width / 1.1
        self.label.font = UIFont.systemFont(ofSize: fontSize)
        self.contentView.addSubview(self.label)
        self.label.frame = CGRect(origin: CGPoint.zero,
                                  size: CGSize(width: fontSize*2, height: fontSize*2))
//        self.contentView.backgroundColor = UIColor.green
    }
    
    var emojiLabel: String? {
        get {
            self.emoji
        }
        set {
            self.emoji = newValue
            self.label.text = newValue
            self.layoutIfNeeded()
        }
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        let center = CGPoint(x: DKKeyboardEmojiCollectionView.cellSize  / 2.0,
                             y: DKKeyboardEmojiCollectionView.cellSize / 2.0)
        self.label.center = center
    }
}

class DKKeyboardEmojiCollectionViewController: UIViewController {
    
    @IBOutlet var keyboardView: DKKeyboardEmojiCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class DKKeyboardEmojiCollectionView: UICollectionView {
    
    fileprivate static var cellSize: CGFloat = 35.0
    private static var cellSpace: CGFloat = 0.0
    private static let sectionSpace: CGFloat = 20.0
    
    private let viewModel: DKKeyboardEmojiViewModel

    init(_ viewModel: DKKeyboardEmojiViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
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
//        let emojiPanelViewHeight = self.emojiPanelViewHeight
//        if emojiPanelViewHeight == 0 {
//            return
//        }
//
//        let countOfEmojiInColumn = 5.0
//        let spaceForOneEmoji = self.emojiPanelViewHeight / countOfEmojiInColumn
//        let newCellSize = spaceForOneEmoji - Self.cellSpace*(countOfEmojiInColumn+1)
//
//        if Self.cellSize == newCellSize {
//            return
//        }
//
//        Self.cellSize = newCellSize
//        self.layoutSubviews()
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

extension DKKeyboardEmojiCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Self.cellSize*1.25, height: Self.cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Self.cellSpace,
                            left: section == 0 ? Self.sectionSpace : Self.cellSpace,
                            bottom: Self.cellSpace,
                            right: Self.cellSpace)
    }
}

class DKKeyboardEmojiCollectionHeaderView: UIStackView {
    private let viewModel: DKKeyboardEmojiViewModel

    init(_ viewModel: DKKeyboardEmojiViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.configureStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureStackView() {
        self.axis = .horizontal
        self.distribution = .fill
        self.spacing = 0

        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 28)
        ])

        self.addArrangedSubview(UIView.fixedSizeView(width: 15, height: 1))

        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .secondaryLabel
        label.text = self.viewModel.sections.first?.title.uppercased()
        
        self.addArrangedSubview(label)

        let labelH = label.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)
        labelH.priority = .required
        labelH.isActive = true
    }
}


class DKKeyboardEmojiCollectionToolbarView: UIStackView {
    private let viewModel: DKKeyboardEmojiViewModel

    init(_ viewModel: DKKeyboardEmojiViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.configureStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureStackView() {
        self.axis = .horizontal
        self.distribution = .equalSpacing
        self.spacing = 0

        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 40)
        ])

        self.addArrangedSubview(UIView.fixedSizeView(width: 1, height: 1))

        if let image = UIImage(named: "keyboard-emoji-category-recents") {
            let button = UIButton()
            button.tintColor = .secondaryLabel
            button.setImage(image, for: .normal)
            button.tag = DKEmojiSectionType.resents.rawValue
            button.addTarget(self.viewModel, action: #selector(self.viewModel.onSectionPress(_:)), for: .touchUpInside)
            self.addArrangedSubview(button)
        }

        for section in self.viewModel.sections {
            if let image = UIImage(named: section.imageName) {
                let button = UIButton()
                button.tintColor = .secondaryLabel
                button.tag = section.id.rawValue
                button.addTarget(self.viewModel, action: #selector(self.viewModel.onSectionPress(_:)), for: .touchUpInside)
                button.setImage(image, for: .normal)
                self.addArrangedSubview(button)
            }
        }

        if let image = UIImage(named: "keyboard-emoji-button-delete") {
            let button = UIButton()
            button.tintColor = .label
            button.addTarget(self.viewModel, action: #selector(self.viewModel.onDelete), for: .touchUpInside)
            button.setImage(image, for: .normal)
            self.addArrangedSubview(button)
        }
        
        self.addArrangedSubview(UIView.fixedSizeView(width: 1, height: 1))
        
    }
}

class DKKeyboardEmojiStackView: UIStackView {
    private let viewModel = DKKeyboardEmojiViewModel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureStackView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.configureStackView()
    }
    
    private func configureStackView() {
        self.axis = .vertical
        self.distribution = .fill
        self.spacing = 0
        
        self.backgroundColor = .secondarySystemFill
        
        self.addArrangedSubview(DKKeyboardEmojiCollectionHeaderView(self.viewModel))
        self.addArrangedSubview(DKKeyboardEmojiCollectionView(self.viewModel))
        self.addArrangedSubview(DKKeyboardEmojiCollectionToolbarView(self.viewModel))
    }
}


extension UIView {
    static func fixedSizeView(width: CGFloat, height: CGFloat) -> UIView {
        let fixedSizeView = UIView()
        fixedSizeView.translatesAutoresizingMaskIntoConstraints = false
        fixedSizeView.backgroundColor = .clear

        let w: NSLayoutConstraint = fixedSizeView.widthAnchor.constraint(equalToConstant: width)
        w.priority = .required
        w.isActive = true

        let h: NSLayoutConstraint = fixedSizeView.heightAnchor.constraint(equalToConstant: height)
        h.priority = .required
        h.isActive = true

        return fixedSizeView
    }
}

@available(iOS, introduced: 17.0)
#Preview {
    let viewController = UIStoryboard(name: "DKKeyboardEmoji", bundle: Bundle.main).instantiateInitialViewController()
    return viewController!
}
