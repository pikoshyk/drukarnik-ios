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
    private let state: Keyboard.KeyboardState
    
    init(state: Keyboard.KeyboardState) {
        self.state = state
    }
    
    var hasAutosuggestions: Bool {
        self.state.autocompleteContext.suggestions.count > 0
    }
    var autosuggestions: [Autocomplete.Suggestion] {
        self.state.autocompleteContext.suggestions
    }
}
