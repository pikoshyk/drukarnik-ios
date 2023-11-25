//
//  DKKeyboardEmojiStackView.swift
//  Drukarnik
//
//  Created by Logout on 25.11.23.
//

import UIKit

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

