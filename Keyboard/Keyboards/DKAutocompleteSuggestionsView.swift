import KeyboardKit
import SwiftUI
import UIKit

enum DKAutocompleteToolbarClipMetrics {
    static let contentInset: CGFloat = 1
    static let fallbackTopCornerRadius: CGFloat = 10

    private(set) static var resolvedTopCornerRadius: CGFloat = fallbackTopCornerRadius

    static func updateResolvedCornerRadius(from view: UIView) {
        if let radius = chromeCornerRadius(from: view) {
            resolvedTopCornerRadius = radius
        }
    }

    private static func chromeCornerRadius(from view: UIView) -> CGFloat? {
        var current: UIView? = view
        while let candidate = current {
            let radius = candidate.layer.cornerRadius
            if radius > 0 {
                return radius
            }
            current = candidate.superview
        }
        return nil
    }
}

struct DKAutocompleteSuggestionsView: View {
    let suggestions: [Autocomplete.Suggestion]
    let autocompleteAction: (Autocomplete.Suggestion) -> Void

    var body: some View {
        let partition = DKAutocompleteWordSuggestions.partition(suggestions)
        if partition.words.isEmpty && partition.emojis.isEmpty {
            EmptyView()
        } else {
            let columns = DKAutocompleteWordSuggestions.toolbarWordColumns(from: partition.words)
            self.threeColumnBar(rawWord: columns.raw, convertedWord: columns.converted, emojis: partition.emojis)
        }
    }

    private func threeColumnBar(
        rawWord: Autocomplete.Suggestion?,
        convertedWord: Autocomplete.Suggestion?,
        emojis: [Autocomplete.Suggestion]
    ) -> some View {
        GeometryReader { geometry in
            let columnWidth = geometry.size.width / 3
            let needsScroll = DKAutocompleteWordSuggestions.shouldScrollThreeColumnBar(
                emojiCount: emojis.count,
                in: geometry.size.width
            )

            Group {
                if needsScroll {
                    ScrollView(.horizontal, showsIndicators: false) {
                        self.scrollableRow(
                            rawWord: rawWord,
                            convertedWord: convertedWord,
                            emojis: emojis,
                            columnWidth: columnWidth
                        )
                    }
                } else {
                    self.staticRow(rawWord: rawWord, convertedWord: convertedWord, emojis: emojis)
                }
            }
            .overlay(
                DKAutocompleteToolbarClipBridge()
                    .allowsHitTesting(false)
            )
            .compositingGroup()
            .mask(DKAutocompleteToolbarTopClipShape())
        }
        .frame(height: DKAutocompleteWordSuggestions.emojiItemWidth)
    }

    private func staticRow(
        rawWord: Autocomplete.Suggestion?,
        convertedWord: Autocomplete.Suggestion?,
        emojis: [Autocomplete.Suggestion]
    ) -> some View {
        HStack(spacing: 0) {
            self.sideColumn(word: rawWord, quoteTitle: true)
            DKAutocompleteSuggestionDelimiter()
            self.centerColumn(word: convertedWord)
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
        rawWord: Autocomplete.Suggestion?,
        convertedWord: Autocomplete.Suggestion?,
        emojis: [Autocomplete.Suggestion],
        columnWidth: CGFloat
    ) -> some View {
        HStack(spacing: 0) {
            self.sideColumn(word: rawWord, quoteTitle: true)
                .frame(width: columnWidth)
            DKAutocompleteSuggestionDelimiter()
            self.centerColumn(word: convertedWord)
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

    private func sideColumn(word: Autocomplete.Suggestion?, quoteTitle: Bool) -> some View {
        HStack {
            Spacer(minLength: 0)
            if let word {
                DKAutocompleteSuggestionButton(
                    suggestion: word,
                    quoteTitle: quoteTitle,
                    autocompleteAction: autocompleteAction
                )
                .fixedSize(horizontal: true, vertical: false)
            }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity)
    }

    private func centerColumn(word: Autocomplete.Suggestion?) -> some View {
        self.sideColumn(word: word, quoteTitle: false)
    }

    private func emojiRow(_ suggestions: [Autocomplete.Suggestion]) -> some View {
        HStack(spacing: 0) {
            ForEach(Array(suggestions.enumerated()), id: \.offset) { _, suggestion in
                DKAutocompleteSuggestionButton(suggestion: suggestion, autocompleteAction: autocompleteAction)
            }
        }
        .padding(.horizontal, DKAutocompleteWordSuggestions.emojiRowHorizontalInset)
    }
}

private struct DKAutocompleteToolbarTopClipShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path(DKAutocompleteToolbarClipGeometry.topRoundedPath(in: rect).cgPath)
    }
}

private enum DKAutocompleteToolbarClipGeometry {
    static func topRoundedPath(in rect: CGRect) -> UIBezierPath {
        let inset = DKAutocompleteToolbarClipMetrics.contentInset
        let bounds = rect.insetBy(dx: inset, dy: inset)
        guard bounds.width > 0, bounds.height > 0 else { return UIBezierPath() }

        let radius = min(
            DKAutocompleteToolbarClipMetrics.resolvedTopCornerRadius,
            min(bounds.width / 2, bounds.height / 2)
        )

        return UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
    }

    static func applyMask(to layer: CALayer, bounds: CGRect) {
        let path = topRoundedPath(in: bounds)
        let maskLayer: CAShapeLayer
        if let existing = layer.mask as? CAShapeLayer {
            maskLayer = existing
        } else {
            maskLayer = CAShapeLayer()
            layer.mask = maskLayer
        }
        maskLayer.frame = bounds
        maskLayer.path = path.cgPath
    }

    static func applyScrollClip(to scrollView: UIScrollView) {
        scrollView.clipsToBounds = true
        applyMask(to: scrollView.layer, bounds: scrollView.bounds)
    }
}

private struct DKAutocompleteToolbarClipBridge: UIViewRepresentable {
    func makeUIView(context: Context) -> DKAutocompleteToolbarClipBridgeView {
        let view = DKAutocompleteToolbarClipBridgeView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = .clear
        return view
    }

    func updateUIView(_ uiView: DKAutocompleteToolbarClipBridgeView, context: Context) {
        uiView.refreshClip()
    }
}

private final class DKAutocompleteToolbarClipBridgeView: UIView {
    override func didMoveToWindow() {
        super.didMoveToWindow()
        refreshClip()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        refreshClip()
    }

    func refreshClip() {
        DKAutocompleteToolbarClipMetrics.updateResolvedCornerRadius(from: self)
        guard let scrollView = enclosingScrollView() else { return }
        DKAutocompleteToolbarClipGeometry.applyScrollClip(to: scrollView)
    }

    private func enclosingScrollView() -> UIScrollView? {
        var view: UIView? = self
        while let current = view {
            if let scrollView = current as? UIScrollView {
                return scrollView
            }
            view = current.superview
        }
        return nil
    }
}
