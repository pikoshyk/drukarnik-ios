import KeyboardKit

enum DKAutocompleteSuggestionAction {
    static func perform(
        suggestion: Autocomplete.Suggestion,
        autocompleteAction: (Autocomplete.Suggestion) -> Void,
        recordRecentEmoji: (String) -> Void
    ) {
        autocompleteAction(suggestion)
        if DKAutocompleteWordSuggestions.isEmojiSuggestion(suggestion) {
            recordRecentEmoji(suggestion.text)
        }
    }
}
