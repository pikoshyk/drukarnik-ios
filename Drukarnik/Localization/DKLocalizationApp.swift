//
//  DKLocalizationApp.swift
//  Drukarnik
//
//  Created by Logout on 19.01.23.
//

import BelarusianLacinka
import UIKit

class DKLocalizationApp: Any {
    
    static func processedWord(_ word: String, convert: Bool = true) -> String {
        var convertedWord = word
        if convert == false {
            return convertedWord
        }
        
        if (DKKeyboardSettings.shared.interfaceTransliteration ?? DKKeyboardSettings.shared.defaultInterfaceTransliteration) == .latin {
            let latinType = DKKeyboardSettings.shared.belarusianLatinType
            convertedWord = DKKeyboardSettings.shared.lacinkaConverter.convert(text: convertedWord, direction: .toLacin, version: latinType, orthograpy: .academic)
        }
        return convertedWord
    }
}

extension DKLocalizationApp { // Settings
    
    class var settingsTitle: String { Self.processedWord("Налады") }
    class var settingsTitleFull: String { Self.processedWord("Налады клавіятуры") }

    class var settingsBelarusianLatinTypeTraditional: String { Self.processedWord("Традыцыйнай") }
    class var settingsBelarusianLatinTypeGeographic: String { Self.processedWord("Геаграфічнай") }
    class var settingsBelarusianLatinTypeTitle: String { Self.processedWord("Літары беларускай лацінкі") }
    
    class var settingsBelarusianCyrillicTypeNarkamauka: String { Self.processedWord("Наркамаўкі") }
    class var settingsBelarusianCyrillicTypeTarashkevica: String { Self.processedWord("Тарашкевіцы") }
    class var settingsBelarusianCyrillicTypeTitle: String { Self.processedWord("Літары беларускай кірыліцы") }
    
    class var settingsTransliterationSegmentedLatin: String { "Łacinka" }
    class var settingsTransliterationSegmentedCyrillic: String { "Кірыліца" }
    class var settingsTransliterationTitle: String { Self.processedWord("Транслітарацыя інтэрфейсу") }
    
    class var settingsLanguagesTitle: String { Self.processedWord("Падтрымка літар іншых моў") }
    class var settingsLanguagesControllerTitle: String { Self.processedWord("Мовы") }
    class var settingsLanguagesControllerSectionCyrillic: String { Self.processedWord("Кірылічная раскладка") }
    class var settingsLanguagesControllerSectionLatin: String { Self.processedWord("Лацінская раскладка") }
}

extension DKLocalizationApp { // Converter
    
    class var converterTitle: String { Self.processedWord("Канвертар") }
    class var converterTitleFull: String { Self.processedWord("Канвертар лацінкі") }

    class var converterBelarusianLatinTypeTitle: String { Self.processedWord("Лацінка") }
    class var converterBelarusianLatinTypeTraditional: String { Self.processedWord("Традыцыйная") }
    class var converterBelarusianLatinTypeGeographic: String { Self.processedWord("Геаграфічная") }

    class var converterBelarusianCyrillicTypeTitle: String { Self.processedWord("Арфаграфія") }
    class var converterBelarusianCyrillicTypeNarkamauka: String { Self.processedWord("Наркамаўка") }
    class var converterBelarusianCyrillicTypeTarashkevica: String { Self.processedWord("Тарашкевіца") }
    
    class var converterTextViewKeyboardDone: String { Self.processedWord("Добра") }

}

extension DKLocalizationApp { // About
    
    class var aboutTitle: String { Self.processedWord("Аб аплікацыі") }
    class var aboutSubscriptionDeveloper: String { Self.processedWord("Распрацоўшчык iOS аплікацыі") }
    class var aboutDescription: String { Self.processedWord("Друкарнік - беларуская клавіятура.") }
    class var aboutSupportHtml: String { Self.processedWord("Праекту патрэбна дапамога: Android, UX/UI. Прапановы пісаць <a href=\"mailto:belanghelp@gmail.com\">сюды</a>.")}
    
}

extension DKLocalizationApp { // Transliteration
    
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
