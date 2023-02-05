//
//  DKLocalization.swift
//  Keyboard
//
//  Created by Logout on 20.12.22.
//

import BelarusianLacinka
import UIKit

class DKLocalizationKeyboard: Any {

    class var isCyrillic: Bool {
        DKKeyboardSettings.shared.keyboardLayout == .latin
    }

    static let lacinkaConverter = BLConverter()
    
    class func convert(text: String, to: BLDirection) -> String {
        let oldText = " "+text
        let latinType = DKKeyboardSettings.shared.belarusianLatinType
        var convertedText = Self.lacinkaConverter.convert(text: oldText, direction: to, version: latinType, orthograpy: .academic)
        convertedText.removeFirst()
        return convertedText
    }

    class var keyboaredButtonSpace: String { Self.isCyrillic ? "ДРУКАРНІК" : "DRUKARNIK" }
    class var keyboaredButtonSearch: String { Self.isCyrillic ? "Пошук" : "Pošuk" }
    class var keyboaredButtonDone: String { Self.isCyrillic ? "Добра" : "Dobra" }
    class var keyboaredButtonGo: String { Self.isCyrillic ? "Пачаць" : "Pačać" }
    class var keyboaredButtonJoin: String { "Join" }
    class var keyboaredButtonOK: String { "OK" }
    class var keyboaredButtonSend: String { Self.isCyrillic ? "Адправіць" : "Adpravić" }
    class var keyboaredButtonNext: String { Self.isCyrillic ? "Далей" : "Daliej" }
    class var keyboaredButtonContinue: String { Self.isCyrillic ? "Далей" : "Daliej" }
    
    class var keyboaredButtonConvertText: String { Self.isCyrillic ? "u kirylicu →" : "у лацінку →" }
}
