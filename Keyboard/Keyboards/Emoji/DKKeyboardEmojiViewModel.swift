//
//  DKKeyboardEmojiViewModel.swift
//  Keyboard
//
//  Created by Logout on 24.11.23.
//

import UIKit

enum DKEmojiSectionType: Int {
    case none = -1
    case resents = 0
    case smileys
    case animals
    case food
    case activity
    case travel
    case objects
    case symbols
    case union
}

class DKEmojiSection: Identifiable {
    let id: DKEmojiSectionType
    let title: String
    let imageName: String
    var items: [String]
    
    init(id: DKEmojiSectionType, title: String, imageName: String, items: [String]) {
        self.id = id
        self.title = title
        self.imageName = imageName
        self.items = items
    }
}

extension DKEmojiSection {
    func emoji(_ index: Int) -> String {
        self.items[index]
    }
    
    func chunkedItems(maxRows: Int) -> [[String]] {
        let emojis = self.items
        let count = emojis.count
        let chunks = stride(from: 0, to: count, by: maxRows).map {
                    Array(emojis[$0 ..< Swift.min($0 + maxRows, count)])
                }
        return chunks
    }
}

protocol DKEmojiSectionDelegate {
    func onSectionChanged(sectionId: DKEmojiSectionType)
    func scrollToSection(sectionId: DKEmojiSectionType)
}

extension DKEmojiSectionDelegate {
    func onSectionChanged(sectionId: DKEmojiSectionType) {}
    func scrollToSection(sectionId: DKEmojiSectionType) {}
}

class DKKeyboardEmojiViewModel: Any {
    var recentSection: DKEmojiSection
    var sections: [DKEmojiSection]
    var headerDelegate: DKEmojiSectionDelegate?
    var collectionDelegate: DKEmojiSectionDelegate?
    var toolbarDelegate: DKEmojiSectionDelegate?

    var onAlphabeticalKeyboardBlock: (() -> Void)?
    var onDeleteBlock: (() -> Void)?
    var onEmojiBlock: ((String) -> Void)?
    var onRecentsBlock: (() -> [String])?
    
    var onReloadCollectionViewData: (() -> Void)?
    
    func reloadData() {
        self.recentSection.items = self.onRecentsBlock?() ?? []
        self.onReloadCollectionViewData?()
    }

    func onSectionPress(_ sectionId: DKEmojiSectionType) {
        UISelectionFeedbackGenerator().selectionChanged()
        self.headerDelegate?.scrollToSection(sectionId: sectionId)
        self.toolbarDelegate?.scrollToSection(sectionId: sectionId)
        self.collectionDelegate?.scrollToSection(sectionId: sectionId)
        self.headerDelegate?.onSectionChanged(sectionId: sectionId)
        self.toolbarDelegate?.onSectionChanged(sectionId: sectionId)
        self.collectionDelegate?.onSectionChanged(sectionId: sectionId)
    }
    
    func onSectionChanged(_ sectionId: DKEmojiSectionType) {
        self.headerDelegate?.onSectionChanged(sectionId: sectionId)
        self.toolbarDelegate?.onSectionChanged(sectionId: sectionId)
        self.collectionDelegate?.onSectionChanged(sectionId: sectionId)
    }

    init() {
        self.recentSection = DKEmojiSection(id: .resents,
                                            title: "Нядаўнія",
                                            imageName: "keyboard-emoji-category-recents",
                                            items:[])
        let emojiModel = KDEmojiModel()
        self.sections = [
            self.recentSection,
            DKEmojiSection(id: .smileys,
                           title: "Усмешкі і людзі",
                           imageName: "keyboard-emoji-category-smileys",
                           items: emojiModel.smileys),
            DKEmojiSection(id: .animals,
                           title: "Жывёлы і расліны",
                           imageName: "keyboard-emoji-category-animals",
                           items:emojiModel.nature),
            DKEmojiSection(id: .food,
                           title: "Ежа і пітво",
                           imageName: "keyboard-emoji-category-food",
                           items:emojiModel.fooddrink),
            DKEmojiSection(id: .activity,
                           title: "Актыўнасці",
                           imageName: "keyboard-emoji-category-activity",
                           items:emojiModel.activity),
            DKEmojiSection(id: .travel,
                           title: "Падарожжы і месцы",
                           imageName: "keyboard-emoji-category-travel",
                           items:emojiModel.travelplaces),
            DKEmojiSection(id: .objects,
                           title: "Рэчы",
                           imageName: "keyboard-emoji-category-objects",
                           items:emojiModel.objects),
            DKEmojiSection(id: .symbols,
                           title: "Сімвалы",
                           imageName: "keyboard-emoji-category-symbols",
                           items:emojiModel.symbols),
            DKEmojiSection(id: .union,
                           title: "Сцягі",
                           imageName: "keyboard-emoji-category-union",
                           items:emojiModel.flags),
            
        ]
    }
}
