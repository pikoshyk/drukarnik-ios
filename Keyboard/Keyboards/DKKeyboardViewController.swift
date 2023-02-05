//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Logout on 29.11.22.
//

import KeyboardKit
import SwiftUI

class DKKeyboardViewController: KeyboardInputViewController {

    override func viewDidLoad() {
        
        let keyboardLayout = DKKeyboardSettings.shared.keyboardLayout
        self.keyboardContext.locale = keyboardLayout.locale
        self.keyboardLayout = keyboardLayout
        self.keyboardActionHandler = DKActionHandler(inputViewController: self, swicthKeyboardBlock: { keyboardLayout in
            DKKeyboardSettings.shared.keyboardLayout = keyboardLayout
            self.keyboardLayout = keyboardLayout
        })
        self.keyboardAppearance = DKKeyboardAppearance(keyboardContext: self.keyboardContext)
        super.viewDidLoad()
    }
    
    var keyboardLayout: DKKeyboardLayout? {
        didSet {
            guard let keyboardLayout = keyboardLayout else {
                return
            }
            self.keyboardContext.locale = keyboardLayout.locale

            switch keyboardLayout {
            case .latin:
                self.inputSetProvider = DKLatinInputSetProvider()
                if let calloutActionProvide = try? DKLatinCalloutActionProvider() {
                    self.calloutActionProvider = calloutActionProvide
                }
                self.keyboardLayoutProvider = DKLatinLayoutProvider(keyboardContext: self.keyboardContext)
                self.autocompleteProvider = DKLatinAutocompleteProvider(textDocumentProxy: self.textDocumentProxy)
                
            case .cyrillic:
                self.inputSetProvider = DKCyrillicInputSetProvider()
                if let calloutActionProvide = try? DKCyrillicCalloutActionProvider() {
                    self.calloutActionProvider = calloutActionProvide
                }
                self.keyboardLayoutProvider = DKCyrillicLayoutProvider(keyboardContext: self.keyboardContext)
                self.autocompleteProvider = DKCyrillycAutocompleteProvider(textDocumentProxy: self.textDocumentProxy)
            }
            
            self.autocompleteProvider.autocompleteSuggestions(for: self.autocompleteText ?? "") { result in
                self.autocompleteContext.suggestions = (try? result.get()) ?? []
            }

            self.keyboardContext.sync(with: self)
        }
    }
    
    /**
     This function is called whenever the keyboard should be
     created or updated.
     Here, we use the ``KeyboardView`` to setup the keyboard.
     This will create a `SystemKeyboard`-based keyboard that
     looks like a native keyboard.
     */
    override func viewWillSetupKeyboard() {
        super.viewWillSetupKeyboard()
        setup(with: DKKeyboardView())
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()

        // Add custom view sizing constraints here
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
}
