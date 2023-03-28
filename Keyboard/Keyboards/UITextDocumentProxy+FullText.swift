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
        guard let text = self.documentContext else { return }
        let offset = text.count
        adjustTextPosition(byCharacterOffset: offset)
        deleteBackward(times: text.count)
        insertText(replacement)
    }

}
