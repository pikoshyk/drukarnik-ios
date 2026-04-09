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

    var buttons: [DKEmojiSectionType: UIButton] = [:]

    var activeSectionId: DKEmojiSectionType = .resents {
        didSet {
            for sectionId in self.viewModel.sections.map(\.id) {
                let currentSection = sectionId == self.activeSectionId
                let button = self.buttons[sectionId]
                button?.tintColor = currentSection ? .label : .secondaryLabel
                button?.viewWithTag(1000)?.isHidden = !currentSection
                
                if currentSection, let size = button?.frame.size {
                    let buttonCenterX = size.width / 2.0
                    let buttonCenterY = size.height / 2.0
                    button?.viewWithTag(1000)?.center = CGPoint(x: buttonCenterX, y: buttonCenterY)
                }
            }
        }
    }

    init(_ viewModel: DKKeyboardEmojiViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.viewModel.toolbarDelegate = self
        self.configureStackView()
        self.buttons[self.activeSectionId]?.tintColor = .label
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureStackView() {
        self.axis = .horizontal
        self.distribution = .fill
        self.spacing = 0

        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 44)
        ])

        self.addArrangedSubview(UIView.fixedSizeView(width: 9, height: 1))
        self.addArrangedSubview(self.buttonsStackView)
        self.addArrangedSubview(UIView.fixedSizeView(width: 0, height: 1))

        self.layoutSubviews()
    }
    
    var buttonsStackView: UIStackView {
        let internalStackView = UIStackView()
        internalStackView.axis = .horizontal
        internalStackView.spacing = 0
        internalStackView.distribution = .fillEqually

        internalStackView.addArrangedSubview(self.buttonAlphabeticalKeyboard)
        
        for section in self.viewModel.sections {
            let button = self.button(section: section)
            self.addBackgroundViewForButton(button: button)
            internalStackView.addArrangedSubview(button)
        }

        internalStackView.addArrangedSubview(self.buttonDelete)

        return internalStackView
    }
    
    private func addBackgroundViewForButton(button: UIButton) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30.0, height: 30.0))
        view.layer.cornerRadius = 15.0
        view.clipsToBounds = true
        view.backgroundColor = .quaternaryLabel
        view.isHidden = true
        view.tag = 1000
        button.addSubview(view)
        let buttonCenterX = button.frame.origin.x + button.frame.width / 2
        let buttonCenterY = button.frame.origin.y + button.frame.height
        let buttonCenter = CGPoint(x: buttonCenterX, y: buttonCenterY)
        view.center = buttonCenter
        button.sendSubviewToBack(view)
    }
    
    var buttonAlphabeticalKeyboard: UIButton {
        let button = UIButton()
        button.setTitle("ABC", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.addAction(UIAction(handler: { action in
            self.viewModel.onAlphabeticalKeyboardBlock?()
        }), for: .touchUpInside)
        return button
    }
    
    var buttonDelete: UIButton {
        let image = UIImage(named: "keyboard-emoji-button-delete")!.resizePhone()!
        let button = UIButton()
        button.tintColor = .label
        button.addAction(UIAction(handler: { action in
            self.viewModel.onDeleteBlock?()
        }), for: .touchDown)
        button.setImage(image, for: .normal)
        
        return button
    }
    
    func button(section: DKEmojiSection) -> UIButton {
        let image = UIImage(named: section.imageName)!.resizePhone()!
        let button = UIButton()
        button.tintColor = .secondaryLabel
        button.tag = section.id.rawValue
        button.addAction(UIAction(handler: { action in
            self.viewModel.onSectionPress(section.id)
        }), for: .touchUpInside)
        button.setImage(image, for: .normal)
        self.buttons[section.id] = button
        return button
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        for sectionId in self.viewModel.sections.map(\.id) {
//            let button = self.buttons[sectionId]
//            if let buttoncenter = button?.center {
//                button?.viewWithTag(1000)?.center = buttoncenter
//            }
//        }
    }
}

extension DKKeyboardEmojiCollectionToolbarView: DKEmojiSectionDelegate {
    func onSectionChanged(sectionId: DKEmojiSectionType) {
        self.activeSectionId = sectionId
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

