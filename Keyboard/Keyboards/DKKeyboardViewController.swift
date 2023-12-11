//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Logout on 29.11.22.
//

import KeyboardKit
import SwiftUI

extension DKKeyboardAutocapitalization {
    var systemValue: Keyboard.AutocapitalizationType {
        get {
            switch self {
            case .none: return .none
            case .allCharacters: return .allCharacters
            case .sentences: return .sentences
            case .words: return .words
            }
        }
        set {
            switch newValue {
            case .none: self = .none
            case .allCharacters: self = .allCharacters
            case .sentences: self = .sentences
            case .words: self = .words
            }
        }
    }
}

extension DKKeyboardFeedback {
    var audioConfiguation: AudioFeedback.Configuration {
        switch self {
        case .sound: fallthrough
        case .soundAndVibro:
            return .enabled
        default:
            return .disabled
        }
    }
    var hapticConfiguation: HapticFeedback.Configuration {
        switch self {
        case .vibro: fallthrough
        case .soundAndVibro:
            return .enabled
        default:
            return .disabled
        }
    }
}

class DKKeyboardViewController: KeyboardInputViewController {

    let settings = DKKeyboardSettings()
    
    override func viewDidLoad() {
        
        KeyboardKit.Gestures.Defaults.longPressDelay = 0.3
        DKLocalizationKeyboard.settings = self.settings

        let keyboardLayout = self.settings.keyboardLayout
        self.state.keyboardContext.locale = keyboardLayout.locale
        self.keyboardLayout = keyboardLayout
        self.services.actionHandler = DKActionHandler(inputViewController: self, swicthKeyboardBlock: self.onSwitchKeyboardLayout)
        self.services.styleProvider = DKKeyboardAppearance(keyboardContext: self.state.keyboardContext)
        self.configureKeyboard()
        super.viewDidLoad()
    }
    
    private func onSwitchKeyboardLayout(_ keyboardLayout: DKKeyboardLayout) {
        self.keyboardLayout = keyboardLayout
        self.configureKeyboard()
    }
    
    private func configureKeyboard() {
        self.state.feedbackConfiguration.audio = self.settings.keyboardFeedback.audioConfiguation
        self.state.feedbackConfiguration.haptic = self.settings.keyboardFeedback.hapticConfiguation
        self.state.keyboardContext.autocapitalizationTypeOverride = self.settings.keyboardAutocapitalization.systemValue
    }
    
    var keyboardLayout: DKKeyboardLayout? {
        didSet {

            guard let keyboardLayout = keyboardLayout else {
                return
            }

            self.settings.keyboardLayout = keyboardLayout
            self.state.keyboardContext.locale = keyboardLayout.locale

            switch keyboardLayout {
            case .latin:
                if let calloutActionProvide = try? DKLatinCalloutActionProvider(settings: self.settings) {
                    self.services.calloutActionProvider = calloutActionProvide
                }
                self.services.layoutProvider = DKLatinLayoutProvider()
                self.services.autocompleteProvider = DKEmojiAutocompleteProvider(settings: self.settings, textDocumentProxy: self.textDocumentProxy)
            case .cyrillic:
                if let calloutActionProvide = try? DKCyrillicCalloutActionProvider(settings: self.settings) {
                    self.services.calloutActionProvider = calloutActionProvide
                }
                self.services.layoutProvider = DKCyrillicLayoutProvider(keyboardContext: self.state.keyboardContext)
                self.services.autocompleteProvider = DKEmojiAutocompleteProvider(settings: self.settings, textDocumentProxy: self.textDocumentProxy)
            }

            Task {
                let result = try? await self.services.autocompleteProvider.autocompleteSuggestions(for: self.autocompleteText ?? "")
                self.state.autocompleteContext.suggestions = result ?? []
            }
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
