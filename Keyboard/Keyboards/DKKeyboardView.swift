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
    
    unowned var keyboardSettings: DKKeyboardSettings
    unowned var keyboardController: DKKeyboardViewController

    init(keyboardController: DKKeyboardViewController, keyboardSettings: DKKeyboardSettings) {
        self.keyboardController = keyboardController
        self.keyboardSettings = keyboardSettings
    }
    
    var body: some View {
        SystemKeyboard(
            state: self.keyboardController.state,
            services: self.keyboardController.services,
            buttonContent:  { $0.view },
            buttonView:  { $0.view },
            emojiKeyboard:  {
                $0.view
//                DKKeyboardEmojiView(viewModel: DKKeyboardEmojiViewModel())
            },
            toolbar: { (autocompleteAction: (Autocomplete.Suggestion) -> Void,
                        style: KeyboardStyle.AutocompleteToolbar,
                        view: AutocompleteToolbar<Autocomplete.ToolbarItem, Autocomplete.ToolbarSeparator>) in
                self.toolbarConverter
        })
    }
    
    var toolbarConverter: some View {
        Group {
            if self.keyboardController.state.keyboardContext.keyboardType != .emojis {
                HStack(spacing: 8) {
                    convertButtonStyled
                    Text(self.keyboardSettings.keyboardLayout == .cyrillic ? DKLocalizationKeyboard.keyboardButtonConvertToLatinText : DKLocalizationKeyboard.keyboardButtonConvertToCyrillicText)
                        .foregroundColor(Color(.quaternaryLabel))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.frame(height: 50).padding(EdgeInsets(top: 4, leading: 3, bottom: 0, trailing: 0))
            } else {
                HStack(spacing: 8) {
                    Text("Тут некалі будзе пошук emoji")
                        .foregroundColor(Color(.quaternaryLabel))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.frame(height: 50).padding(EdgeInsets(top: 4, leading: 3, bottom: 0, trailing: 0))
            }
        }
    }
}


// MARK: - Private Views
private extension DKKeyboardView {

    var convertButtonStyled: some View {
        if #available(iOS 15.0, *) {
            return self.convertButton.buttonStyle(.bordered)
        }

        return self.convertButton.buttonStyle(.automatic)
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
