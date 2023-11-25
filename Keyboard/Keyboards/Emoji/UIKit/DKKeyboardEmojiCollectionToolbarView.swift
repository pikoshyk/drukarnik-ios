//
//  DKKeyboardEmojiCollectionToolbarView.swift
//  Drukarnik
//
//  Created by Logout on 25.11.23.
//

import UIKit

extension UIImage {
    enum ContentMode {
        case contentFill
        case contentAspectFill
        case contentAspectFit
    }
    
    func resizePhone() -> UIImage? {
        self.resize(withSize: CGSize(width: 50, height: 15), contentMode: .contentAspectFit)?.withRenderingMode(.alwaysTemplate)
    }
    
    func resize(withSize size: CGSize, contentMode: ContentMode = .contentAspectFill) -> UIImage? {
        let aspectWidth = size.width / self.size.width
        let aspectHeight = size.height / self.size.height
        
        switch contentMode {
        case .contentFill:
            return resize(withSize: size)
        case .contentAspectFit:
            let aspectRatio = min(aspectWidth, aspectHeight)
            return resize(withSize: CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio))
        case .contentAspectFill:
            let aspectRatio = max(aspectWidth, aspectHeight)
            return resize(withSize: CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio))
        }
    }
    
    private func resize(withSize size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

class DKKeyboardEmojiCollectionToolbarView: UIStackView {
    private let viewModel: DKKeyboardEmojiViewModel

    init(_ viewModel: DKKeyboardEmojiViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.viewModel.toolbarDelegate = self
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
            self.heightAnchor.constraint(equalToConstant: 40)
        ])

        self.addArrangedSubview(UIView.fixedSizeView(width: 9, height: 1))
        self.addArrangedSubview(self.buttonsStackView)
        self.addArrangedSubview(UIView.fixedSizeView(width: 20, height: 1))

    }
    
    var buttonsStackView: UIStackView {
        let internalStackView = UIStackView()
        internalStackView.axis = .horizontal
        internalStackView.spacing = 0
        internalStackView.distribution = .equalCentering

        internalStackView.addArrangedSubview(self.buttonAlphabeticalKeyboard)
//        internalStackView.addArrangedSubview(self.buttonCategoryRecent)
        
        for section in self.viewModel.sections {
            let button = self.button(section: section)
            internalStackView.addArrangedSubview(button)
        }

        internalStackView.addArrangedSubview(self.buttonDelete)
        return internalStackView
    }
    
    var buttonAlphabeticalKeyboard: UIButton {
        let button = UIButton()
        button.setTitle("ABC", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.addTarget(self.viewModel, action: #selector(self.viewModel.onAlphabeticalKeyboard), for: .touchUpInside)
        return button
    }
    
    var buttonCategoryRecent: UIButton {
        let image = UIImage(named: "keyboard-emoji-category-recents")!.resizePhone()!
        let button = UIButton()
                    button.tintColor = .secondaryLabel
        button.setImage(image, for: .normal)
        button.tag = DKEmojiSectionType.resents.rawValue
        button.addTarget(self.viewModel, action: #selector(self.viewModel.onSectionPress(_:)), for: .touchUpInside)
        return button
    }
    
    var buttonDelete: UIButton {
        let image = UIImage(named: "keyboard-emoji-button-delete")!.resizePhone()!
        let button = UIButton()
        button.tintColor = .label
        button.addTarget(self.viewModel, action: #selector(self.viewModel.onDelete), for: .touchUpInside)
        button.setImage(image, for: .normal)
        return button
    }
    
    func button(section: DKEmojiSection) -> UIButton {
        let image = UIImage(named: section.imageName)!.resizePhone()!
        let button = UIButton()
        button.tintColor = .secondaryLabel
        button.tag = section.id.rawValue
        button.addTarget(self.viewModel, action: #selector(self.viewModel.onSectionPress(_:)), for: .touchUpInside)
        button.setImage(image, for: .normal)
        return button
    }
}

extension DKKeyboardEmojiCollectionToolbarView: DKEmojiSectionDelegate {
    func onSectionChanged(sectionId: DKEmojiSectionType) {
        
    }
}

@available(iOS, introduced: 17.0)
#Preview {
    let view = DKKeyboardEmojiCollectionToolbarView(DKKeyboardEmojiViewModel())
    view.backgroundColor = .gray
    NSLayoutConstraint.activate([
        view.widthAnchor.constraint(equalToConstant: 380)
    ])
    return view
}

