enum DKKeyboardToolbarContent: Equatable {
    case suggestions
    case options

    static func resolve(hasAutosuggestions: Bool, showSettingsView: Bool) -> Self {
        hasAutosuggestions && !showSettingsView ? .suggestions : .options
    }
}
