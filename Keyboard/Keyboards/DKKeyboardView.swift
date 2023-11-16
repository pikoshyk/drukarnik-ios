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
    
    @State private var text = "Text"
    
    unowned var keyboardSettings: DKKeyboardSettings
    unowned var keyboardController: DKKeyboardViewController

    @EnvironmentObject
    private var autocompleteContext: AutocompleteContext

    @EnvironmentObject
    private var keyboardContext: KeyboardContext
    
    init(keyboardController: DKKeyboardViewController, keyboardSettings: DKKeyboardSettings) {
        self.keyboardController = keyboardController
        self.keyboardSettings = keyboardSettings
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if keyboardContext.keyboardType != .emojis {
                HStack(spacing: 8) {
                    convertButtonStyled
                    Text(self.keyboardSettings.keyboardLayout == .cyrillic ? DKLocalizationKeyboard.keyboardButtonConvertToLatinText : DKLocalizationKeyboard.keyboardButtonConvertToCyrillicText)
                        .foregroundColor(Color(.quaternaryLabel))
                        .frame(maxWidth: .infinity, alignment: .leading)
//                    autocompleteToolbar
                }.frame(height: 50).padding(EdgeInsets(top: 4, leading: 3, bottom: 0, trailing: 0))
            }
            SystemKeyboard(controller: self.keyboardController, autocompleteToolbar: .none)
        }
    }
}


// MARK: - Private Views
private extension DKKeyboardView {

    var autocompleteToolbar: some View {
        AutocompleteToolbar(
            suggestions: autocompleteContext.suggestions,
            locale: keyboardContext.locale,
            suggestionAction: { suggestion in
                DKAutocompleteToolbar.standardActionWithFullTextAutocompleteSupport(for: suggestion, keyboardController: self.keyboardController)
            }
        )
        .frame(maxWidth: .infinity)
    }

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
            
            self.keyboardContext.convertAndReplaceFullText(converter: settings.lacinkaConverter, direction: direction, version: version, orthography: orthograpy)
        } label: {
            let lettersSet = CharacterSet.letters
            let fullText = self.keyboardContext.mainTextDocumentProxy.documentContext ?? ""
            if String(fullText.unicodeScalars.filter { lettersSet.contains($0) }).count > 0 {
                Image("autotransliteration-active")
            } else {
                Image("autotransliteration-inactive")
            }
        }
        .frame(width: 60.0)
    }
    

    /// This text field can be added to the VStack above, to
    /// test typing in a text field within the keyboard view.
    var textField: some View {
        KeyboardTextField(text: $text, controller: self.keyboardController) {
            $0.placeholder = "Try typing here, press return to stop."
            $0.borderStyle = .roundedRect
            $0.autocapitalizationType = .sentences
        }.padding(3)
    }
}
