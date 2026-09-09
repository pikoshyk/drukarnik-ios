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
    var audioConfiguation: Feedback.AudioConfiguration {
        switch self {
        case .sound: fallthrough
        case .soundAndVibro:
            return .enabled
        default:
            return .disabled
        }
    }
    var hapticConfiguation: Feedback.HapticConfiguration {
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

    let localSettings = DKKeyboardSettings()
    private var layoutApplicator = DKKeyboardLayoutApplicator()
    private lazy var keyboardViewModel = DKKeyboardViewModel(keyboardSettings: self.localSettings, state: self.state)

    override func viewDidLoad() {

        KeyboardKit.Gestures.Defaults.longPressDelay = 0.3
        DKLocalizationKeyboard.settings = self.localSettings

        let keyboardLayout = self.localSettings.keyboardLayout
        self.state.keyboardContext.locale = keyboardLayout.locale
        self.applyKeyboardLayout(keyboardLayout)
        self.services.actionHandler = DKActionHandler(inputViewController: self, swicthKeyboardBlock: self.onSwitchKeyboardLayout)
        self.services.styleProvider = DKKeyboardAppearance(keyboardContext: self.state.keyboardContext)
        self.configureKeyboard()
        super.viewDidLoad()
    }

    private func onSwitchKeyboardLayout(_ keyboardLayout: DKKeyboardLayout) {
        self.applyKeyboardLayout(keyboardLayout)
        self.configureKeyboard()
    }

    private func configureKeyboard() {
        self.state.feedbackContext.audioConfiguration = self.localSettings.keyboardFeedback.audioConfiguation
        self.state.feedbackContext.hapticConfiguration = self.localSettings.keyboardFeedback.hapticConfiguation
        self.state.keyboardContext.autocapitalizationTypeOverride = self.localSettings.keyboardAutocapitalization.systemValue
    }

    func applyKeyboardLayout(_ layout: DKKeyboardLayout, force: Bool = false) {
        guard self.layoutApplicator.applyLayout(layout, force: force) else {
            return
        }

        self.localSettings.keyboardLayout = layout
        self.state.keyboardContext.locale = layout.locale

        switch layout {
        case .latin:
            if let calloutActionProvide = try? DKLatinCalloutActionProvider(settings: self.localSettings) {
                self.services.calloutActionProvider = calloutActionProvide
            }
            self.services.layoutProvider = DKLatinLayoutProvider()
            self.services.autocompleteProvider = DKLatinAutocompleteProvider(settings: self.localSettings, textDocumentProxy: self.textDocumentProxy)
        case .cyrillic:
            if let calloutActionProvide = try? DKCyrillicCalloutActionProvider(settings: self.localSettings) {
                self.services.calloutActionProvider = calloutActionProvide
            }
            self.services.layoutProvider = DKCyrillicLayoutProvider(keyboardContext: self.state.keyboardContext)
            self.services.autocompleteProvider = DKCyrillycAutocompleteProvider(settings: self.localSettings, textDocumentProxy: self.textDocumentProxy)
        }

        Task {
            let result = try? await self.services.autocompleteProvider.autocompleteSuggestions(for: self.autocompleteText ?? "")
            self.state.autocompleteContext.suggestions = result ?? []
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.localSettings.reloadSettings()
        self.applyKeyboardLayout(self.localSettings.keyboardLayout)
        self.configureKeyboard()
        super.viewWillAppear(animated)
    }

    override func viewWillSetupKeyboard() {
        super.viewWillSetupKeyboard()
        setup(with: DKKeyboardView(keyboardController: self, viewModel: self.keyboardViewModel))
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
}
