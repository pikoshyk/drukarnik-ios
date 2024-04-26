//
//  DKKeyboardViewModel.swift
//  Keyboard
//
//  Created by Logout on 11.12.23.
//

import KeyboardKit
import Foundation
import Combine

class DKKeyboardViewModel: ObservableObject {
    private unowned var state: Keyboard.KeyboardState
    private unowned var keyboardSettings: DKKeyboardSettings
    
    lazy var emojiViewModel = DKKeyboardEmojiViewModel()
    
    private var emojiRecents: [DKKeyboardEmojiRecentsItem] = []
    
    init(keyboardSettings: DKKeyboardSettings, state: Keyboard.KeyboardState) {
        self.state = state
        self.keyboardSettings = keyboardSettings
    }
    
    var hasAutosuggestions: Bool {
        self.state.autocompleteContext.suggestions.count > 0
    }

    var autosuggestions: [Autocomplete.Suggestion] {
        self.state.autocompleteContext.suggestions
    }
    
    private func reloadEmoji() {
        self.emojiRecents = self.keyboardSettings.keyboardEmojiRecents
        self.emojiViewModel.reloadData()
    }
}

extension DKKeyboardViewModel {
    
    func onAlphabeticalKeyboard() {
        self.state.keyboardContext.keyboardType = .alphabetic(.auto)
        self.reloadEmoji()
    }
    
    func onEmojiAppear() {
        self.emojiRecents = self.keyboardSettings.keyboardEmojiRecents
        self.reloadEmoji()
    }
    
    func onEmojiDisappear() {
    }
    
    func onEmoji(_ emoji: String) {
        autoreleasepool {
            self.state.keyboardContext.textDocumentProxy.insertText(emoji)
            if let emojiItem = self.emojiRecents.filter({  $0.emoji == emoji }).first {
                emojiItem.usage.insert(Date(), at: 0)
                if emojiItem.usage.count > 10 {
                    emojiItem.usage.removeLast()
                }
            } else {
                let item = DKKeyboardEmojiRecentsItem(emoji: emoji)
                self.emojiRecents.insert(item, at: 0)
            }
            
            self.emojiRecents.sort { item1, item2 in
                item1.usage.first! > item2.usage.first!
            }
            
            if self.emojiRecents.count > 30 {
                self.emojiRecents.removeLast()
            }
            
            
            self.keyboardSettings.keyboardEmojiRecents = self.emojiRecents
//            let items = self.emojiRecents.compactMap { $0.emoji }.joined()
//            self.emojiViewModel.recentSection.items = items
//            self.emojiViewModel.reloadData()
        }
    }
    
    func onEmojiDelete() {
        self.state.keyboardContext.textDocumentProxy.deleteBackward(times: 1)
    }
    
    func onEmojiRecents() -> [String] {
        return self.emojiRecents.compactMap { $0.emoji }
    }
}
