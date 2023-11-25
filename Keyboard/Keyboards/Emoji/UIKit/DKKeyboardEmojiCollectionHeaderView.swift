//
//  DKKeyboardEmojiCollectionHeaderView.swift
//  Drukarnik
//
//  Created by Logout on 25.11.23.
//

import UIKit

class DKKeyboardEmojiCollectionHeaderView: UIStackView {
    private let viewModel: DKKeyboardEmojiViewModel
    private let label = UILabel()

    init(_ viewModel: DKKeyboardEmojiViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.viewModel.headerDelegate = self
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
        
        self.label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        self.label.textColor = .secondaryLabel
        self.label.text = self.viewModel.sections.first?.title.uppercased()
        
        self.addArrangedSubview(self.label)

        let labelH = self.label.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)
        labelH.priority = .required
        labelH.isActive = true
    }
}

extension DKKeyboardEmojiCollectionHeaderView: DKEmojiSectionDelegate {
    
    func onSectionChanged(sectionId: DKEmojiSectionType) {
        self.label.text = self.viewModel.sections.filter{ $0.id == sectionId }.first?.title.uppercased()
    }
    
}
