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
        
        switch(keyboardLayout) {
        case .cyrillic:
            self.inputSetProvider = DKByCyrillicInputSetProvider()
            if let calloutActionProvide = try? DKByCyrillicCalloutActionProvider() {
                self.calloutActionProvider = calloutActionProvide
            }
            self.keyboardLayoutProvider = DKByCyrillicLayoutProvider()
        case .latin:
            self.inputSetProvider = DKByLacinInputSetProvider()
            if let calloutActionProvide = try? DKByLacinCalloutActionProvider() {
                self.calloutActionProvider = calloutActionProvide
            }
            self.keyboardLayoutProvider = DKByLacinLayoutProvider()
        }

        self.keyboardActionHandler = DKByActionHandler(inputViewController: self, swicthKeyboardBlock: { keyboardLayout in
            DKByKeyboardSettings.shared.keyboardLayout = keyboardLayout
            self.keyboardContext.locale = keyboardLayout.locale
            switch(keyboardLayout) {
            case .latin:
                self.inputSetProvider = DKByLacinInputSetProvider()
                if let calloutActionProvide = try? DKByLacinCalloutActionProvider() {
                    self.calloutActionProvider = calloutActionProvide
                }
                self.keyboardLayoutProvider = DKByLacinLayoutProvider()
            case .cyrillic:
                self.inputSetProvider = DKByCyrillicInputSetProvider()
                if let calloutActionProvide = try? DKByCyrillicCalloutActionProvider() {
                    self.calloutActionProvider = calloutActionProvide
                }
                self.keyboardLayoutProvider = DKByCyrillicLayoutProvider()
            }
            self.keyboardContext.sync(with: self)
        })
        self.keyboardAppearance = DKByKeyboardAppearance(context: self.keyboardContext)
        super.viewDidLoad()
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
