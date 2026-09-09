import KeyboardKit
import SwiftUI

enum DKKeyboardToolbarMetrics {
    static let height: CGFloat = 50
}

struct DKKeyboardToolbarView: View {
    @ObservedObject var viewModel: DKKeyboardViewModel
    @Binding var showSettingsView: Bool
    let autocompleteAction: (Autocomplete.Suggestion) -> Void

    var body: some View {
        Group {
            if DKKeyboardToolbarContent.resolve(
                hasAutosuggestions: viewModel.hasAutosuggestions,
                showSettingsView: showSettingsView
            ) == .suggestions {
                DKAutocompleteSuggestionsView(
                    suggestions: viewModel.autosuggestions,
                    autocompleteAction: autocompleteAction
                )
            } else {
                DKKeyboardOptionsToolbarView(
                    showSettingsView: showSettingsView,
                    onToggleSettings: {
                        showSettingsView.toggle()
                        if showSettingsView {
                            viewModel.refreshOverlayTextAvailability()
                        }
                    }
                )
            }
        }
        .padding(EdgeInsets(top: 4, leading: 3, bottom: 0, trailing: 0))
        .frame(height: DKKeyboardToolbarMetrics.height)
    }
}

private struct DKKeyboardOptionsToolbarView: View {
    let showSettingsView: Bool
    let onToggleSettings: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            DKKeyboardSettingsButton(
                isActive: showSettingsView,
                action: onToggleSettings
            )
            Text(DKKeyboardToolbarLocalization.optionsButtonTitle)
                .foregroundColor(Color(.quaternaryLabel))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

private struct DKKeyboardSettingsButton: View {
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isActive ? "gearshape.fill" : "gearshape")
                .resizable()
                .frame(width: 24, height: 24)
                .padding(12)
                .frame(width: 60.0)
        }
        .background(Color.keyboardBackground.opacity(0.01))
        .foregroundColor(.primary)
    }
}

private enum DKKeyboardToolbarLocalization {
    static var optionsButtonTitle: String {
        DKLocalizationKeyboard.convert(text: "← Дадатковыя опцыі клавіятуры")
    }
}
