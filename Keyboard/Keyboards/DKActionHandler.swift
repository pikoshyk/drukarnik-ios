//
//  DKActionHandler.swift
//  Keyboard
//
//  Created by Logout on 11.12.22.
//

import UIKit
import KeyboardKit

class DKActionHandler: StandardKeyboardActionHandler {
    var swicthKeyboardBlock: ((DKKeyboardLayout) -> Void)?

    convenience init(inputViewController controller: KeyboardInputViewController, swicthKeyboardBlock: @escaping(DKKeyboardLayout) -> Void) {
        self.init(controller: controller)
        self.swicthKeyboardBlock = swicthKeyboardBlock
    }
    
    /**
     Try to handling a certain `gesture` n a certain `action`.
     */
    open override func handle(_ gesture: Gestures.KeyboardGesture, on action: KeyboardAction) {
        if gesture == .release {
            autoreleasepool {
                if action == .custom(named: DKKeyboardLayout.latin.rawValue) {
                    self.swicthKeyboardBlock?(.latin)
                } else if action == .custom(named: DKKeyboardLayout.cyrillic.rawValue) {
                    self.swicthKeyboardBlock?(.cyrillic)
                }
            }
        }
        super.handle(gesture, on: action)
    }
    
    open override func tryApplyAutocorrectSuggestion(before gesture: Gestures.KeyboardGesture, on action: KeyboardAction) {
        let textDocumentProxy = self.keyboardContext.textDocumentProxy

        if self.isSpaceCursorDrag(action) { return }
        if textDocumentProxy.isCursorAtNewWord { return }
        guard gesture == .release else { return }
        guard action.shouldApplyAutocorrectSuggestion else { return }
        guard let suggestion = (autocompleteContext.suggestions.first { $0.isAutocorrect }) else { return }
        var fullTextReplaceRequired = false
        fullTextReplaceRequired = suggestion.fullTextReplaceRequired
        if fullTextReplaceRequired {
            textDocumentProxy.insertAutocompleteSuggestionFullText(suggestion, tryInsertSpace: false)
        } else {
            textDocumentProxy.insertAutocompleteSuggestion(suggestion, tryInsertSpace: false)
        }
    }
    
    func isSpaceCursorDrag(_ action: KeyboardAction) -> Bool {
        guard action == .space else { return false }
        return self.spaceDragGestureHandler.currentDragTextPositionOffset != 0
    }
}
