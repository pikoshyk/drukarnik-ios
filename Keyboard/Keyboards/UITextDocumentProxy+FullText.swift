//
//  UITextDocumentProxy+AutocompleteFullText.swift
//  Keyboard
//
//  Created by Logout on 25.01.23.
//

import UIKit
import KeyboardKit

extension UITextDocumentProxy {
    
    func insertAutocompleteSuggestionFullText(_ suggestion: AutocompleteSuggestion, tryInsertSpace: Bool = true) {
        replaceFullText(with: suggestion.text)
        guard tryInsertSpace else { return }
        tryInsertSpaceAfterAutocomplete()
    }

    func replaceFullText(with replacement: String) {
        guard let text = self.fullText else { return }
        let offset = self.fullText?.count ?? 0
        adjustTextPosition(byCharacterOffset: offset)
        deleteBackward(times: text.count)
        insertText(replacement)
    }
    
    var fullText: String? {
        let text = self.documentContext
        return text
    }

}
