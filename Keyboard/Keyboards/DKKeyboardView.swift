import KeyboardKit
import SwiftUI

struct DKKeyboardView: View {

    @ObservedObject var viewModel: DKKeyboardViewModel
    unowned var keyboardController: DKKeyboardViewController

    @State private var showSetingsView = false

    init(keyboardController: DKKeyboardViewController, viewModel: DKKeyboardViewModel) {
        self.keyboardController = keyboardController
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            SystemKeyboard(
                state: self.viewModel.state,
                services: self.keyboardController.services,
                buttonContent: { $0.view },
                buttonView: { $0.view },
                emojiKeyboard: { _ in self.emojiKeyboardView },
                toolbar: { autocompleteAction, _, _ in
                    DKKeyboardToolbarView(
                        viewModel: self.viewModel,
                        showSettingsView: self.$showSetingsView,
                        autocompleteAction: autocompleteAction
                    )
                }
            )
            .zIndex(1.0)
            if self.showSetingsView {
                VStack(spacing: 0) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: DKKeyboardToolbarMetrics.height)
                        .allowsHitTesting(false)
                    DKKeyboardConversionOverlayView(viewModel: self.viewModel)
                }
                .zIndex(2.0)
            }
        }
    }

    private var emojiKeyboardView: some View {
        DKKeyboardEmojiView(self.viewModel.emojiViewModel, onAlphabeticalKeyboard: {
            self.viewModel.onAlphabeticalKeyboard()
        }, onDelete: {
            self.viewModel.onEmojiDelete()
        }, onEmoji: { emoji in
            self.viewModel.onEmoji(emoji)
        }, onRecents: {
            return self.viewModel.onEmojiRecents()
        })
        .onAppear {
            self.viewModel.onEmojiAppear()
        }
        .onDisappear {
            self.viewModel.onEmojiDisappear()
        }
    }
}
