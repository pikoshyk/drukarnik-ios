//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Logout on 29.11.22.
//

import KeyboardKit
import SwiftUI

class KeyboardViewController: KeyboardInputViewController {

    override func viewDidLoad() {
        
        let keyboardLayout = DKByKeyboardSettings.shared.keyboardLayout
        self.keyboardContext.locale = keyboardLayout.locale
        self.keyboardLayout = keyboardLayout
        self.keyboardActionHandler = DKByActionHandler(inputViewController: self, swicthKeyboardBlock: { keyboardLayout in
            DKByKeyboardSettings.shared.keyboardLayout = keyboardLayout
            self.keyboardLayout = keyboardLayout
        })
        self.keyboardAppearance = DKByKeyboardAppearance(context: self.keyboardContext)
        super.viewDidLoad()
    }
    
    var keyboardLayout: DKByKeyboardLayout? {
        didSet {
            guard let keyboardLayout = keyboardLayout else {
                return
            }
            self.keyboardContext.locale = keyboardLayout.locale

            switch keyboardLayout {
            case .latin:
                self.inputSetProvider = DKByLatinInputSetProvider()
                if let calloutActionProvide = try? DKByLatinCalloutActionProvider() {
                    self.calloutActionProvider = calloutActionProvide
                }
                self.keyboardLayoutProvider = DKByLatinLayoutProvider()
                self.autocompleteProvider = DKByLatinAutocompleteProvider()
                
            case .cyrillic:
                self.inputSetProvider = DKByCyrillicInputSetProvider()
                if let calloutActionProvide = try? DKByCyrillicCalloutActionProvider() {
                    self.calloutActionProvider = calloutActionProvide
                }
                self.keyboardLayoutProvider = DKByCyrillicLayoutProvider()
                self.autocompleteProvider = DKByCyrillycAutocompleteProvider()
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
