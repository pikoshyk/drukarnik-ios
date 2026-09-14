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
    var quoteTitle: Bool = false
    let autocompleteAction: (Autocomplete.Suggestion) -> Void

    var body: some View {
        let isEmoji = DKAutocompleteWordSuggestions.isEmojiSuggestion(suggestion)
        if isEmoji {
            Button {
                autocompleteAction(suggestion)
            } label: {
                Text(suggestion.title)
                    .font(.system(size: DKAutocompleteWordSuggestions.emojiFontSize))
            }
            .buttonStyle(.plain)
            .frame(width: DKAutocompleteWordSuggestions.emojiItemWidth, height: DKAutocompleteWordSuggestions.emojiItemWidth)
            .contentShape(Rectangle())
        } else {
            Button {
                autocompleteAction(suggestion)
            } label: {
                ZStack {
                    Color.clearInteractable
                    DKAutocompleteSuggestionWordLabel(suggestion: suggestion, quoteTitle: quoteTitle)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
        }
    }
}

struct DKAutocompleteSuggestionWordLabel: View {
    let suggestion: Autocomplete.Suggestion
    var quoteTitle: Bool = false

    var body: some View {
        let title = quoteTitle ? "\"\(suggestion.title)\"" : suggestion.title
        Text(title)
            .font(.system(size: 17))
            .foregroundColor(Color(.label))
            .lineLimit(1)
            .padding(.horizontal, 12)
    }
}
