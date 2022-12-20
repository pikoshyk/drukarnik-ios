//
//  DKKeyboardView.swift
//  Keyboard
//
//  Created by Logout on 29.11.22.
//

import KeyboardKit
import SwiftUI

/**
 This is the main view that is registered when the extension
 runs `setup(with:)` in ``KeyboardViewController``. The view
 is used by all `SystemKeyboard`-based keyboards.
 
 The view must observe a `KeyboardContext` as an environment
 object, or take a context instance as an init parameter and
 set it to an observed object. Otherwise, it will not change
 when the context changes. This is not how it should be, but
 I have not yet figured out why this is needed.
 */
struct DKKeyboardView: View {
    
    @State
    private var text = "Text"
    
    @EnvironmentObject
    private var autocompleteContext: AutocompleteContext

    @EnvironmentObject
    private var keyboardContext: KeyboardContext
    
    var body: some View {
        VStack(spacing: 0) {
            if keyboardContext.keyboardType != .emojis {
                autocompleteToolbar
            }
            SystemKeyboard()
        }
    }
}


// MARK: - Private Views
private extension DKKeyboardView {

    var autocompleteToolbar: some View {
        HStack(spacing: 8) {
            AutocompleteToolbar(
                suggestions: autocompleteContext.suggestions,
                locale: keyboardContext.locale
            )
            
//            Button("Ŭ ⇨ Ў") {
//
//            }.buttonStyle(.bordered)

        }.frame(height: 50)
    }

    /// This text field can be added to the VStack above, to
    /// test typing in a text field within the keyboard view.
    var textField: some View {
        KeyboardTextField(text: $text) {
            $0.placeholder = "Try typing here, press return to stop."
            $0.borderStyle = .roundedRect
            $0.autocapitalizationType = .sentences
        }.padding(3)
    }
}
