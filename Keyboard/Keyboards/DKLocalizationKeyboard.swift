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

    class var keyboaredButtonSpace: String { Self.convert(text: "ДРУКАРНІК") }
    class var keyboaredButtonSearch: String { Self.convert(text: "Пошук") }
    class var keyboaredButtonDone: String { Self.convert(text: "Добра") }
    class var keyboaredButtonGo: String { Self.convert(text: "Пачаць") }
    class var keyboaredButtonJoin: String { "Join" }
    class var keyboaredButtonOK: String { "OK" }
    class var keyboaredButtonSend: String { Self.convert(text: "Адправіць") }
    class var keyboaredButtonNext: String { Self.convert(text: "Далей") }
    class var keyboaredButtonContinue: String { Self.convert(text: "Далей") }
    
    class var keyboaredButtonConvertText: String { Self.convert(text: "у лацінку →") }
}
