import BelarusianLacinka
import KeyboardKit
import SwiftUI

struct DKKeyboardView: View {

    @ObservedObject var viewModel: DKKeyboardViewModel
    unowned var keyboardController: DKKeyboardViewController

    static let TOOLBAR_FRAME_HEIGHT: CGFloat = 54

    init(keyboardController: DKKeyboardViewController, viewModel: DKKeyboardViewModel) {
        self.keyboardController = keyboardController
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            SystemKeyboard(
                state: self.viewModel.state,
                services: self.keyboardController.services,
                buttonContent:  { $0.view },
                buttonView:  { $0.view },
                emojiKeyboard:  { _ in self.emojiKeyboardView },
                toolbar: { autocompleteAction, _, _ in self.toolbarView(autocompleteAction) }
            )
            .zIndex(1.0)
            if self.showSetingsView {
                VStack(spacing: 0) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: Self.TOOLBAR_FRAME_HEIGHT)
                    self.overlayKeyboardView
                }
                .zIndex(2.0)
            }
        }
    }

    var emojiKeyboardView: some View {
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

    @ViewBuilder
    func toolbarView(_ autocompleteAction: @escaping (Autocomplete.Suggestion) -> Void) -> some View {
        Group {
            if self.viewModel.hasAutosuggestions {
                self.autosuggestionsView(autocompleteAction: autocompleteAction)
            } else {
                self.baseToolbarView
            }
        }
        .padding(EdgeInsets(top: 4, leading: 3, bottom: 0, trailing: 0))
        .frame(height: DKKeyboardView.TOOLBAR_FRAME_HEIGHT)
    }

    var baseToolbarView: some View {
        HStack(spacing: 0) {
            self.settingsButtonView
            Text(Localization.optionsButtonTitle)
                .foregroundColor(Color(.quaternaryLabel))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @State var showSetingsView: Bool = false

    var overlayKeyboardView: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.keyboardBackground)
                .zIndex(1.0)
            ScrollView {
                VStack {
                    if self.viewModel.overlayHasLetters {
                        HStack(spacing: 0) {
                            self.conversionLatCyrButtonStyledView(direction: .toCyrillic, customLabel: Text(Localization.optionsConvertButtonToCyrillicTitle))
                                .font(.body)
                            Spacer(minLength: 2)
                            Text(Localization.optionsConvertLabelTitle)
                                .foregroundColor(Color(.quaternaryLabel))
                                .font(.callout)
                            Spacer(minLength: 2)
                            self.conversionLatCyrButtonStyledView(direction: .toLacin, customLabel: Text(Localization.optionsConvertButtonToLatinTitle))
                                .font(.body)
                        }
                    } else {
                        Text(Localization.optionsConvertUnaccessableTitle)
                            .foregroundColor(Color(.quaternaryLabel))
                            .font(.callout)
                    }
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 8)
            .frame(width: .infinity, height: .infinity)
            .zIndex(2.0)
        }
    }

    var conversionToolbarView: some View {
        HStack(spacing: 8) {
            self.conversionLatCyrButtonStyledView()
            Text(self.viewModel.keyboardSettings.keyboardLayout == .cyrillic ? DKLocalizationKeyboard.keyboardButtonConvertToLatinText : DKLocalizationKeyboard.keyboardButtonConvertToCyrillicText)
                .foregroundColor(Color(.quaternaryLabel))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}


private extension DKKeyboardView {
    var settingsButtonView: some View {
        Button(action: {
            self.showSetingsView.toggle()
            if self.showSetingsView {
                self.viewModel.refreshOverlayTextAvailability()
            }
        }, label: {
            Image(systemName: self.showSetingsView ? SystemImage.optionsButtonIconActive : SystemImage.optionsButtonIconInactive)
                .resizable()
                .frame(width: 24, height: 24)
                .padding(12)
                .frame(width: 60.0)
        })
        .background(Color.keyboardBackground.opacity(0.01))
        .foregroundColor(.primary)
    }
}

private extension DKKeyboardView {
    @ViewBuilder
    func autosuggestionsView(autocompleteAction: @escaping (Autocomplete.Suggestion) -> Void) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 2) {
                Spacer()
                    .frame(width: 8)
                ForEach(self.viewModel.autosuggestions, id: \.text) { suggestion in
                    Group {
                        Button {
                            autocompleteAction(suggestion)
                        } label: {
                            Text(suggestion.text)
                                .font(Font.system(size: 24))
                        }


                    }
                    .frame(width: 44)
                }
            }
        }
    }
}

private extension DKKeyboardView {

    func conversionLatCyrButtonStyledView(direction: BelarusianLacinka.BLDirection? = nil, customLabel: Text? = nil) -> some View {
        Group {
            if #available(iOS 15.0, *) {
                self.conversionLatCyrButtonView(direction: direction, customLabel: customLabel)
                    .buttonStyle(.bordered)
            } else {
                self.conversionLatCyrButtonView(direction: direction, customLabel: customLabel)
                    .buttonStyle(.automatic)
            }
        }
    }

    @ViewBuilder
    func conversionLatCyrButtonView(direction initialDirection: BelarusianLacinka.BLDirection? = nil, customLabel: Text?) -> some View {
        Button {
            self.viewModel.convertText(direction: initialDirection)
        } label: {
            if let customLabel = customLabel {
                customLabel
            } else {
                Group {
                    if self.viewModel.overlayHasLetters {
                        Image("autotransliteration-active")
                    } else {
                        Image("autotransliteration-inactive")
                    }
                }
                .frame(width: 60.0)
            }
        }
        .foregroundColor(.accent)
    }
}

private extension DKKeyboardView {
    struct Localization {
        static var optionsConvertButtonToLatinTitle: String { DKLocalizationKeyboard.convert(text: "Лацінка") }
        static var optionsConvertButtonToCyrillicTitle: String { DKLocalizationKeyboard.convert(text: "Кірыліца")
        }
        static var optionsConvertLabelTitle: String { DKLocalizationKeyboard.convert(text: "канвертаваць тэкст у")
        }
        static var optionsConvertUnaccessableTitle: String { DKLocalizationKeyboard.convert(text: "Опцыі канвертацыі тэксту ў Лацінку і Кірыліцу адлюструюцца тут, калі будзе ўведзены тэкст.")
        }
        static var optionsButtonTitle: String { DKLocalizationKeyboard.convert(text: "← Дадатковыя опцыі клавіятуры")
        }
    }

    struct SystemImage {
        static let optionsButtonIconActive = "gearshape.fill"
        static let optionsButtonIconInactive = "gearshape"
    }
}
