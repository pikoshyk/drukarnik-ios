//
//  DKKeyboardEmojiStackView.swift
//  Drukarnik
//
//  Created by Logout on 25.11.23.
//

import UIKit

class DKKeyboardEmojiStackView: UIStackView {
    var viewModel: DKKeyboardEmojiViewModel
    private let collectionView: DKKeyboardEmojiCollectionView
    
    init(_ viewModel: DKKeyboardEmojiViewModel) {
        self.viewModel = viewModel
        self.collectionView = DKKeyboardEmojiCollectionView(viewModel)
        super.init(frame: .zero)
        self.configureStackView()
    }

    override init(frame: CGRect) {
        self.viewModel = DKKeyboardEmojiViewModel()
        self.collectionView = DKKeyboardEmojiCollectionView(self.viewModel)
        super.init(frame: frame)
        self.configureStackView()
    }
    
    required init(coder: NSCoder) {
        self.viewModel = DKKeyboardEmojiViewModel()
        self.collectionView = DKKeyboardEmojiCollectionView(self.viewModel)
        super.init(coder: coder)
        self.configureStackView()
    }
    
    private func configureStackView() {
        self.axis = .vertical
        self.distribution = .fill
        self.spacing = 0
        
        self.addArrangedSubview(DKKeyboardEmojiCollectionHeaderView(self.viewModel))
        self.addArrangedSubview(self.collectionView)
        self.addArrangedSubview(DKKeyboardEmojiCollectionToolbarView(self.viewModel))
    }
}

