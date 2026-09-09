import KeyboardKit
import SwiftUI

struct DKAutocompleteSuggestionsView: View {
    let suggestions: [Autocomplete.Suggestion]
    let autocompleteAction: (Autocomplete.Suggestion) -> Void

    var body: some View {
        let partition = DKAutocompleteWordSuggestions.partition(suggestions)
        if partition.words.isEmpty && partition.emojis.isEmpty {
            EmptyView()
        } else {
            self.threeColumnBar(word: partition.words.first, emojis: partition.emojis)
        }
    }

    private func threeColumnBar(
        word: Autocomplete.Suggestion?,
        emojis: [Autocomplete.Suggestion]
    ) -> some View {
        GeometryReader { geometry in
            let columnWidth = geometry.size.width / 3
            let needsScroll = DKAutocompleteWordSuggestions.shouldScrollThreeColumnBar(
                emojiCount: emojis.count,
                in: geometry.size.width
            )

            if needsScroll {
                ScrollView(.horizontal, showsIndicators: false) {
                    self.scrollableRow(word: word, emojis: emojis, columnWidth: columnWidth)
                }
            } else {
                self.staticRow(word: word, emojis: emojis)
            }
        }
        .frame(height: DKAutocompleteWordSuggestions.emojiItemWidth)
    }

    private func staticRow(
        word: Autocomplete.Suggestion?,
        emojis: [Autocomplete.Suggestion]
    ) -> some View {
        HStack(spacing: 0) {
            Color.clear
                .frame(maxWidth: .infinity)
            DKAutocompleteSuggestionDelimiter()
            self.centerColumn(word: word)
            DKAutocompleteSuggestionDelimiter()
            Group {
                if emojis.isEmpty {
                    Color.clear
                } else {
                    HStack(spacing: 0) {
                        Spacer(minLength: 0)
                        self.emojiRow(emojis)
                        Spacer(minLength: 0)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    private func scrollableRow(
        word: Autocomplete.Suggestion?,
        emojis: [Autocomplete.Suggestion],
        columnWidth: CGFloat
    ) -> some View {
        HStack(spacing: 0) {
            Color.clear
                .frame(width: columnWidth)
            DKAutocompleteSuggestionDelimiter()
            self.centerColumn(word: word)
                .frame(width: columnWidth)
            DKAutocompleteSuggestionDelimiter()
            if emojis.isEmpty {
                Color.clear
                    .frame(width: columnWidth)
            } else {
                self.emojiRow(emojis)
            }
        }
    }

    private func centerColumn(word: Autocomplete.Suggestion?) -> some View {
        HStack {
            Spacer(minLength: 0)
            if let word {
                DKAutocompleteSuggestionButton(suggestion: word, autocompleteAction: autocompleteAction)
                    .fixedSize(horizontal: true, vertical: false)
            }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity)
    }

    private func emojiRow(_ suggestions: [Autocomplete.Suggestion]) -> some View {
        HStack(spacing: 0) {
            ForEach(Array(suggestions.enumerated()), id: \.offset) { _, suggestion in
                DKAutocompleteSuggestionButton(suggestion: suggestion, autocompleteAction: autocompleteAction)
            }
        }
    }
}
