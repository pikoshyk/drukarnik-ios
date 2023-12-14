//
//  DKLocalizationApp.swift
//  Drukarnik
//
//  Created by Logout on 19.01.23.
//

import BelarusianLacinka
import UIKit

class DKLocalizationApp: Any {
    
    static func processedWord(_ word: String,
                              convert: Bool = true,
                              defaultInterfaceTransliteration: DKKeyboardLayout = DKKeyboardSettings.shared.defaultInterfaceTransliteration) -> String {
        var convertedWord = word
        if convert == false {
            return convertedWord
        }
        
        if (DKKeyboardSettings.shared.interfaceTransliteration ?? defaultInterfaceTransliteration) == .latin {
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
    
    class var settingsAutocapitalizationTypeTitle: String { Self.processedWord("Аўтаматычна вялікая літара") }

    class var settingsAutocapitalizationTypeNever: String { Self.processedWord("Ніколі") }
    class var settingsAutocapitalizationTypeWord: String { Self.processedWord("На пачатку слова") }
    class var settingsAutocapitalizationTypeSentense: String { Self.processedWord("На пачатку сказа") }
    
    class var settingsKeyboardFeedbackTypeTitle: String { Self.processedWord("Водгук на націсканне кнопак") }
    class var settingsKeyboardFeedbackTypeNone: String { Self.processedWord("Няма") }
    class var settingsKeyboardFeedbackTypeAudio: String { Self.processedWord("Аўдыя") }
    class var settingsKeyboardFeedbackTypeVibro: String { Self.processedWord("Вібрацыя") }
    class var settingsKeyboardFeedbackTypeAudioAndVibro: String { Self.processedWord("Аўдыя і вібрацыя") }
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
    
    class var aboutTitle: String { Self.processedWord("Пра аплікацыю") }
    class var aboutDescription: String { Self.processedWord("Друкарнік — беларуская клавіятура, якая сумяшчае кірыліцу з беларускай лацінкай, мае дадатковыя літары для расейскай, украінскай, польскай ды іншых моў і нават эмаджы, то-бок адзіная клавіятура амаль на ўсе выпадкі жыцця беларуса.") }
    class var aboutSupportHtml: String { Self.processedWord("Праекту патрэбна дапамога: Android, UX/UI. Прапановы пісаць <a href=\"mailto:belanghelp@gmail.com\">сюды</a>.")}
    
}

extension DKLocalizationApp { // Transliteration
    
    class func transliterationTitle(direction: BLDirection) -> String { Self.processedWord("Беларуская мова", convert: direction == .toLacin, defaultInterfaceTransliteration: .latin) }
    class var transliterationSegmentedLatin: String { "Łacinka" }
    class var transliterationSegmentedCyrillic: String { "Кірыліца" }
    class func transliterationHistory(direction: BLDirection) -> String { Self.processedWord("Пачынаючы з позняга сярэднявечча (XVI ст.) беларуская мова мае апроч кірылічнага альфабэту яшчэ і ўласны лацінкавы альфабэт.", convert: direction == .toLacin, defaultInterfaceTransliteration: .latin) }
    class func transliterationAppeal(direction: BLDirection) -> String { Self.processedWord("Абярыце транслітарацыю інтэрфейса", convert: direction == .toLacin, defaultInterfaceTransliteration: .latin) }
    class var transliterationButtonLatinTitle: String { "Łacinka" }
    class var transliterationButtonLatinSubtitle: String { "bełaruskaja" }
    class var transliterationButtonCyrillicTitle: String { "Кірыліца" }
    class var transliterationButtonCyrillicSubtitle: String { "беларуская" }
    class func transliterationNote(direction: BLDirection) -> String { Self.processedWord("Пасля, у наладах, можна будзе змяніць транслітарацыю інтэрфейса на адваротную.", convert: direction == .toLacin, defaultInterfaceTransliteration: .latin) }
    
}

extension DKLocalizationApp { // Installation
    // Description Screen
    class var installationDescriptionTitle: String { Self.processedWord("Друкарнік") }
    class var installationDescriptionDescription: String { Self.processedWord("Беларуская клавіятура, якая сумяшчае кірыліцу з беларускай лацінкай, мае дадатковыя літары для расейскай, украінскай, польскай ды іншых моў і нават эмаджы, то-бок адзіная клавіятура амаль на ўсе выпадкі жыцця беларуса.") }
    class var installationDescriptionActionButton: String { Self.processedWord("Пачаць") }
    
    // SharingData Screen
    class var installationSharingDataTitle: String { Self.processedWord("Палепшыць Друкарнік") }
    class var installationSharingDataDescription: String { Self.processedWord("Вы можаце ананімна дзяліцца дадзенымі як і што набіраеце, у тым ліку, як часта выкарыстоўваеце пэўныя словы і іх паслядоўнасць. Гэта дапаможа нам паляпшаць набор тэксту і дадаваць новыя сучасныя словы ў падказкі.") }
    class var installationSharingDataQuestion: String { Self.processedWord("Згодны дзяліцца?") }
    class var installationSharingDataActionButtonYes: String { Self.processedWord("Так") }
    class var installationSharingDataActionButtonNo: String { Self.processedWord("Не") }

    // Keyboard Screen
    class var installationKeyboardTitle: String { Self.processedWord("Уключыць клавіятуру") }
    class var installationKeyboardDescription: String { Self.processedWord("Крокі, якія трэба зрабіць, каб уключыць клавіятуру «Друкарнік»:") }
    class var installationKeyboardStep1: String { Self.processedWord("Перайсці ў Налады") }
    class var installationKeyboardStep2: String { "Drukarnik" }
    class var installationKeyboardStep2Helper: String { Self.processedWord("Перайсці сюды") }
    class var installationKeyboardStep3: String { Self.processedWord("Клавіятуры") }
    class var installationKeyboardStep4: String { Self.processedWord("Уключыць")+" «Drukarnik»" }
    class var installationKeyboardStep5: String { Self.processedWord("Даць шырокі доступ")+"\n(Allow Full Access)" }
    class var installationKeyboardStep6: String { Self.processedWord("Вярнуцца зноў сюды, каб завяршыць усталёўку") }
}

