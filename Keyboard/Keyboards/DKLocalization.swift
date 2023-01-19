//
//  DKLocalization.swift
//  Keyboard
//
//  Created by Logout on 20.12.22.
//

import BelarusianLacinka
import UIKit

class DKLocalization: Any {
    static func processedWord(_ word: String, convert: Bool = true) -> String {
        var convertedWord = word
        if convert == false {
            return convertedWord
        }

        if DKByKeyboardSettings.shared.keyboardLayout == .latin {
            convertedWord = DKByKeyboardSettings.lacinkaConverter.convert(text: word, direction: .toLacin, version: .traditional, orthograpy: .academic)
        }
        return convertedWord
    }
    
    class var keyboaredButtonSpace: String { Self.processedWord("ДРУКАРНІК") }
    class var keyboaredButtonSearch: String { Self.processedWord("Пошук") }
    class var keyboaredButtonDone: String { Self.processedWord("Добра") }
    class var keyboaredButtonGo: String { Self.processedWord("Пачаць") }
    class var keyboaredButtonJoin: String { Self.processedWord("Join") }
    class var keyboaredButtonOK: String { Self.processedWord("OK") }
    class var keyboaredButtonSend: String { Self.processedWord("Адправіць") }
    class var keyboaredButtonNext: String { Self.processedWord("Далей") }
    class var keyboaredButtonContinue: String { Self.processedWord("Далей") }
}
