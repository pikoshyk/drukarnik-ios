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
    
    private var dict: [String: String] = [:]
    
    override init(settings: DKKeyboardSettings, textDocumentProxy: UITextDocumentProxy) {
        super.init(settings: settings, textDocumentProxy: textDocumentProxy)
        autoreleasepool {
            self.loadDict()
        }
    }
    
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
            guard let emoji = emojiStr.components(separatedBy: " ").first else {
                continue
            }
            self.dict[key] = emoji
        }
    }
    
    override func autocompleteSuggestions(for text: String) async throws -> [Autocomplete.Suggestion] {
        let word = text.components(separatedBy: CharacterSet(charactersIn: String.wordDelimiters.joined())).last ?? ""
        if text == "ooo" {
            return [Autocomplete.Suggestion(text: "oh", isAutocorrect: false)]
        }
        if text.isEmpty { return [] }
        guard let emoji = self.dict[word.lowercased()] else {
            return []
        }
        return [Autocomplete.Suggestion(text: emoji, isAutocorrect: false)]
    }
}
