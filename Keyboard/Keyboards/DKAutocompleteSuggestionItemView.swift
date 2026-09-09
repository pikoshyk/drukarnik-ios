import KeyboardKit
import SwiftUI

struct DKAutocompleteSuggestionDelimiter: View {
    var body: some View {
        Color(.separator)
            .opacity(0.5)
            .frame(width: 1, height: 30)
    }
}

struct DKAutocompleteSuggestionButton: View {
    let suggestion: Autocomplete.Suggestion
    let autocompleteAction: (Autocomplete.Suggestion) -> Void

    var body: some View {
        let isEmoji = DKAutocompleteWordSuggestions.isEmojiSuggestion(suggestion)
        Button {
            autocompleteAction(suggestion)
        } label: {
            if isEmoji {
                Text(suggestion.title)
                    .font(.system(size: 28))
            } else {
                DKAutocompleteSuggestionWordLabel(suggestion: suggestion)
            }
        }
        .buttonStyle(.plain)
        .frame(width: isEmoji ? 44 : nil, height: isEmoji ? 44 : nil)
    }
}

struct DKAutocompleteSuggestionWordLabel: View {
    let suggestion: Autocomplete.Suggestion

    var body: some View {
        let title = suggestion.isUnknown ? "\"\(suggestion.title)\"" : suggestion.title
        Text(title)
            .font(.system(size: 17))
            .foregroundColor(Color(.label))
            .lineLimit(1)
            .padding(.horizontal, 12)
    }
}
