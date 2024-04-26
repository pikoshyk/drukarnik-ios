//
//  DKKeyboardView.swift
//  Keyboard
//
//  Created by Logout on 29.11.22.
//

import BelarusianLacinka
import KeyboardKit
import SwiftUI

/**
 This is the main view that is registered when the extension
 runs `setup(with:)` in ``KeyboardViewController``. The view
 is used by all `SystemKeyboard`-based keyboards.
 
 The view must observe a `KeyboardContext` as an environment
 object, or take a context instance as an init parameter and
 set it to an observed object. Otherwise, it will not change
 when the context changes. This is not how it should be, but
 I have not yet figured out why this is needed.
 */
struct DKKeyboardView: View {
    
    @StateObject var viewModel: DKKeyboardViewModel
    unowned var keyboardSettings: DKKeyboardSettings
    unowned var keyboardController: DKKeyboardViewController

    init(keyboardController: DKKeyboardViewController, keyboardSettings: DKKeyboardSettings) {
        self._viewModel = .init(wrappedValue: DKKeyboardViewModel(keyboardSettings: keyboardSettings, state: keyboardController.state))
        self.keyboardController = keyboardController
        self.keyboardSettings = keyboardSettings
    }
    
    var body: some View {
        SystemKeyboard(
            state: self.keyboardController.state,
            services: self.keyboardController.services,
            buttonContent:  { $0.view },
            buttonView:  { $0.view },
            emojiKeyboard:  { emojiKeyboardParams in
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
            },
            toolbar: { (autocompleteAction: @escaping (Autocomplete.Suggestion) -> Void,
                        style: Autocomplete.ToolbarStyle,
                        view: Autocomplete.Toolbar<Autocomplete.ToolbarItem, Autocomplete.ToolbarSeparator>) in
                self.toolbarConverter(autocompleteAction)
            }
        )
    }
    
    @ViewBuilder
    func toolbarConverter(_ autocompleteAction: @escaping (Autocomplete.Suggestion) -> Void) -> some View {
        HStack(spacing: 8) {
            convertButtonStyled
            if self.viewModel.hasAutosuggestions {
                Spacer(minLength: 0)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 2) {
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
            } else {
                Text(self.keyboardSettings.keyboardLayout == .cyrillic ? DKLocalizationKeyboard.keyboardButtonConvertToLatinText : DKLocalizationKeyboard.keyboardButtonConvertToCyrillicText)
                    .foregroundColor(Color(.quaternaryLabel))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(height: 50)
        .padding(EdgeInsets(top: 4, leading: 3, bottom: 0, trailing: 0))
    }
}


// MARK: - Private Views
private extension DKKeyboardView {

    var convertButtonStyled: some View {
        Group {
            if #available(iOS 15.0, *) {
                self.convertButton
                    .buttonStyle(.bordered)
            } else {
                self.convertButton
                    .buttonStyle(.automatic)
            }
        }
    }
    
    var convertButton: some View {
        Button {
            let settings = self.keyboardSettings
            let direction: BelarusianLacinka.BLDirection = settings.keyboardLayout == .latin ? .toCyrillic : .toLacin
            let version = settings.belarusianLatinType
            let orthograpy = settings.belarusianCyrillicType
            
            self.keyboardController.state.keyboardContext.convertAndReplaceFullText(converter: settings.lacinkaConverter, direction: direction, version: version, orthography: orthograpy)
        } label: {
            let lettersSet = CharacterSet.letters
            let fullText = self.keyboardController.state.keyboardContext.originalTextDocumentProxy.documentContext ?? ""
            if String(fullText.unicodeScalars.filter { lettersSet.contains($0) }).count > 0 {
                Image("autotransliteration-active")
            } else {
                Image("autotransliteration-inactive")
            }
        }
        .frame(width: 60.0)
    }
}
