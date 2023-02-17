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
        super.init(inputViewController: ivc, spaceDragGestureHandler: spaceDragGestureHandler, spaceDragSensitivity: spaceDragSensitivity)
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
        guard gesture == .tap else { return }
        guard action.shouldApplyAutocompleteSuggestion else { return }
        guard let suggestion = (autocompleteContext.suggestions.first { $0.isAutocomplete }) else { return }
        var fullTextReplaceRequired = false
        if let standardSuggestion = suggestion as? StandardAutocompleteSuggestion {
            fullTextReplaceRequired = standardSuggestion.fullTextReplaceRequired
        }
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
