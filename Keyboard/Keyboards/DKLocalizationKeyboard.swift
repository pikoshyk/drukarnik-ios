//
//  DKLocalization.swift
//  Keyboard
//
//  Created by Logout on 20.12.22.
//

import BelarusianLacinka
import UIKit

class DKLocalizationKeyboard: Any {
    
    weak static var settings: DKKeyboardSettings?

    class var isCyrillic: Bool {
        Self.settings?.keyboardLayout == .latin
    }

    class func convert(text: String, to: BLDirection = DKLocalizationKeyboard.isCyrillic ? .toLacin : .toCyrillic) -> String {
        let oldText = " "+text
        let latinType = Self.settings?.belarusianLatinType ?? .traditional
        let cyrillicType = Self.settings?.belarusianCyrillicType ?? .academic
        var convertedText = Self.settings?.lacinkaConverter.convert(text: oldText, direction: to, version: latinType, orthograpy: cyrillicType) ?? oldText
        convertedText.removeFirst()
        return convertedText
    }

    class var keyboardButtonSpace: String { Self.convert(text: "ДРУКАРНІК") }
    class var keyboardButtonSearch: String { Self.convert(text: "Пошук") }
    class var keyboardButtonDone: String { Self.convert(text: "Добра") }
    class var keyboardButtonGo: String { Self.convert(text: "Пачаць") }
    class var keyboardButtonJoin: String { "Join" }
    class var keyboardButtonOK: String { "OK" }
    class var keyboardButtonSend: String { Self.convert(text: "Адправіць") }
    class var keyboardButtonNext: String { Self.convert(text: "Далей") }
    class var keyboardButtonContinue: String { Self.convert(text: "Далей") }
    
    class var keyboardButtonConvertToLatinText: String { Self.convert(text: "← Канвертаваць у лацінку") }
    class var keyboardButtonConvertToCyrillicText: String { Self.convert(text: "← Канвертаваць у кірыліцу") }
}
