//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Logout on 29.11.22.
//

import KeyboardKit
import SwiftUI

class DKKeyboardViewController: KeyboardInputViewController {

    let settings = DKKeyboardSettings()

    override func viewDidLoad() {
        
        KeyboardKit.GestureButtonDefaults.longPressDelay = 0.3
        DKLocalizationKeyboard.settings = self.settings

        let keyboardLayout = self.settings.keyboardLayout
        self.keyboardContext.locale = keyboardLayout.locale
        self.keyboardLayout = keyboardLayout
        self.keyboardActionHandler = DKActionHandler(inputViewController: self, swicthKeyboardBlock: self.onSwitchKeyboardLayout)
        self.keyboardAppearance = DKKeyboardAppearance(keyboardContext: self.keyboardContext)
        self.configureFeedback()
        super.viewDidLoad()
    }
    
    private func onSwitchKeyboardLayout(_ keyboardLayout: DKKeyboardLayout) {
        self.keyboardLayout = keyboardLayout
        self.configureFeedback()
    }
    
    private func configureFeedback() {
        let audio: AudioFeedbackConfiguration = self.settings.keyboardFeedbackAudio ? .enabled : .noFeedback
        let haptic: HapticFeedbackConfiguration = self.settings.keyboardFeedbackHaptic ? .enabled : .noFeedback
        self.keyboardFeedbackSettings.audioConfiguration = audio
        self.keyboardFeedbackSettings.hapticConfiguration = haptic
    }
    
    var keyboardLayout: DKKeyboardLayout? {
        didSet {

            guard let keyboardLayout = keyboardLayout else {
                return
            }

            self.settings.keyboardLayout = keyboardLayout
            self.keyboardContext.locale = keyboardLayout.locale
                
            switch keyboardLayout {
            case .latin:
                self.inputSetProvider = DKLatinInputSetProvider()
                if let calloutActionProvide = try? DKLatinCalloutActionProvider(settings: self.settings) {
                    self.calloutActionProvider = calloutActionProvide
                }
                self.keyboardLayoutProvider = DKLatinLayoutProvider(keyboardContext: self.keyboardContext)
                self.autocompleteProvider = DKLatinAutocompleteProvider(settings: self.settings, textDocumentProxy: self.textDocumentProxy)
                
            case .cyrillic:
                self.inputSetProvider = DKCyrillicInputSetProvider()
                if let calloutActionProvide = try? DKCyrillicCalloutActionProvider(settings: self.settings) {
                    self.calloutActionProvider = calloutActionProvide
                }
                self.keyboardLayoutProvider = DKCyrillicLayoutProvider(keyboardContext: self.keyboardContext)
                self.autocompleteProvider = DKCyrillycAutocompleteProvider(settings: self.settings, textDocumentProxy: self.textDocumentProxy)
            }
                
            self.autocompleteProvider.autocompleteSuggestions(for: self.autocompleteText ?? "") { result in
                self.autocompleteContext.suggestions = (try? result.get()) ?? []
            }

//            self.keyboardContext.sync(with: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let keyboardLayout = self.keyboardLayout
        self.settings.reloadSettings()
        self.keyboardLayout = keyboardLayout
        super.viewWillAppear(animated)
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
        setup(with: DKKeyboardView(keyboardController: self, keyboardSettings: self.settings))
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()

        // Add custom view sizing constraints here
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
}
