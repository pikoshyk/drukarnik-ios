//
//  DKEmojiAutocompleteProvider.swift
//  Keyboard
//
//  Created by Logout on 11.12.23.
//

import Foundation
import BelarusianLacinka
import KeyboardKit
import UIKit

class DKEmojiAutocompleteProvider: DKAutocompleteProvider {
    
    private var dict: [String: [String]] = [:]
    
    override init(settings: DKKeyboardSettings, textDocumentProxy: UITextDocumentProxy) {
        super.init(settings: settings, textDocumentProxy: textDocumentProxy)
        autoreleasepool {
            self.loadDict()
        }
    }
    
    override func autocompleteSuggestions(for text: String) async throws -> [Autocomplete.Suggestion] {
        guard let word = text.components(separatedBy: CharacterSet(charactersIn: String.wordDelimiters.joined())).last?.lowercased() else {
            return []
        }
        if text.isEmpty { return [] }
        
        var emoji = self.dict[word]
        if emoji == nil {
            let trWord = DKLocalizationKeyboard.convert(text: word, to: .toCyrillic)
            emoji = self.dict[trWord]
        }
        guard let emoji = emoji else {
            return []
        }
        let suggestions = emoji.compactMap { Autocomplete.Suggestion(text: $0) }
        return suggestions
    }
}

extension DKEmojiAutocompleteProvider {
    func loadDict() {
        guard let fileUrl = Bundle.main.url(forResource: "emoji", withExtension: "json") else {
            return
        }
        guard let data = try? Data(contentsOf: fileUrl) else {
            return
        }
        
        guard let json: [String: String] = try? JSONDecoder().decode([String: String].self, from: data) else {
            return
        }
        
        
        for key in Array(json.keys) {
            guard let emojiStr = json[key] else {
                continue
            }
            let emoji = emojiStr.components(separatedBy: " ")
            self.dict[key] = emoji
        }
    }
    

}
