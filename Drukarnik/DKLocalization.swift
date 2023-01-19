//
//  DKLocalization.swift
//  Drukarnik
//
//  Created by Logout on 19.01.23.
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

    class var aboutTitle: String { Self.processedWord("Друкарнік") }
    class var aboutDone: String { Self.processedWord("Добра") }
    class var aboutSubscriptionDeveloper: String { Self.processedWord("Распрацоўшчык iOS аплікацыі") }
    class var aboutDescription: String { Self.processedWord("Друкарнік - беларуская клавіятура.") }
    class var aboutSupportHtml: String { Self.processedWord("Праекту патрэбна дапамога: Dev, ML, PR, UX/UI. Прапановы пісаць <a href=\"mailto:belanghelp@gmail.com\">сюды</a>.")}

    
    class func transliterationTitle(direction: BLDirection) -> String { Self.processedWord("Беларуская мова", convert: direction == .toLacin) }
    class var transliterationSegmentedLatin: String { "Łacinka" }
    class var transliterationSegmentedCyrillic: String { "Кірыліца" }
    class func transliterationHistory(direction: BLDirection) -> String { Self.processedWord("Пачынаючы з позняга сярэднявечча (XVI ст.) беларуская мова мае апроч кірылічнага альфабэту яшчэ і ўласны лацінкавы альфабэт.", convert: direction == .toLacin) }
    class func transliterationAppeal(direction: BLDirection) -> String { Self.processedWord("Абярыце транслітарацыю інтэрфейса", convert: direction == .toLacin) }
    class var transliterationButtonLatinTitle: String { "Łacinka" }
    class var transliterationButtonLatinSubtitle: String { "bełaruskaja" }
    class var transliterationButtonCyrillicTitle: String { "Кірыліца" }
    class var transliterationButtonCyrillicSubtitle: String { "беларуская" }
    class func transliterationNote(direction: BLDirection) -> String { Self.processedWord("Пасля, у наладах, можна будзе змяніць транслітарацыю інтэрфейса на адваротную.", convert: direction == .toLacin) }

}
