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

    init(inputViewController ivc: KeyboardInputViewController, spaceDragGestureHandler: DragGestureHandler? = nil, spaceDragSensitivity: SpaceDragSensitivity = .medium, swicthKeyboardBlock: @escaping(DKKeyboardLayout) -> Void) {
        super.init(keyboardController: ivc,
                   keyboardContext: ivc.keyboardContext,
                   keyboardBehavior: ivc.keyboardBehavior,
                   keyboardFeedbackSettings: ivc.keyboardFeedbackSettings,
                   autocompleteContext: ivc.autocompleteContext,
                   spaceDragGestureHandler: spaceDragGestureHandler,
                   spaceDragSensitivity: spaceDragSensitivity)
        self.swicthKeyboardBlock = swicthKeyboardBlock
    }
    
    /**
     Try to handling a certain `gesture` n a certain `action`.
     */
    open override func handle(_ gesture: KeyboardGesture, on action: KeyboardAction) {
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
    
    open override func tryApplyAutocompleteSuggestion(before gesture: KeyboardGesture, on action: KeyboardAction) {
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
        guard let handler = spaceDragGestureHandler as? SpaceCursorDragGestureHandler else { return false }
        return handler.currentDragTextPositionOffset != 0
    }
}
