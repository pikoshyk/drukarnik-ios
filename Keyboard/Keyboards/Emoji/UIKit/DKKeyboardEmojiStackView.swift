//
//  DKKeyboardEmojiStackView.swift
//  Drukarnik
//
//  Created by Logout on 25.11.23.
//

import UIKit

class DKKeyboardEmojiStackView: UIStackView {
    var viewModel: DKKeyboardEmojiViewModel
    
    init(_ viewModel: DKKeyboardEmojiViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.configureStackView()
    }

    override init(frame: CGRect) {
        self.viewModel = DKKeyboardEmojiViewModel()
        super.init(frame: frame)
        self.configureStackView()
    }
    
    required init(coder: NSCoder) {
        self.viewModel = DKKeyboardEmojiViewModel()
        super.init(coder: coder)
        self.configureStackView()
    }
    
    private func configureStackView() {
        self.axis = .vertical
        self.distribution = .fill
        self.spacing = 0
        
//        self.backgroundColor = .secondarySystemFill
        
        self.addArrangedSubview(DKKeyboardEmojiCollectionHeaderView(self.viewModel))
        self.addArrangedSubview(DKKeyboardEmojiCollectionView(self.viewModel))
        self.addArrangedSubview(DKKeyboardEmojiCollectionToolbarView(self.viewModel))
    }
}

