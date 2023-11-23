//
//  DKSettingsViewModel.swift
//  Drukarnik
//
//  Created by Logout on 22.11.23.
//

import BelarusianLacinka
import Foundation
import Combine

struct DKSettingViewOption<T: Hashable> {
    let title: String
    let value: T
}

class DKSettingsViewModel: ObservableObject {
    
    var cancellableSinks: Set<AnyCancellable> = []
    
    let navigationTitle = "Налады клавіятуры"
    
    let cyrillicTypeCellTitle = "Літары беларускай кірыліцы"
    lazy var cyrillicTypeAvailableOptions: [DKSettingViewOption<BelarusianLacinka.BLOrthography>] = [
        DKSettingViewOption(title: "Наркамаўка", value: .academic),
        DKSettingViewOption(title: "Тарашкевіца", value: .classic)
    ]
    var cyrillicTypeCurrent: BelarusianLacinka.BLOrthography {
        get { DKKeyboardSettings.shared.belarusianCyrillicType }
        set {
            DKKeyboardSettings.shared.belarusianCyrillicType = newValue
            self.objectWillChange.send()
        }
    }

    
    let latinTypeCellTitle = "Літары беларускай лацінкі"
    lazy var latinTypeAvailableOptions: [DKSettingViewOption<BelarusianLacinka.BLVersion>] = [
        DKSettingViewOption(title: "Традыцыйная", value: .traditional),
        DKSettingViewOption(title: "Геаграфічная", value: .geographic)
    ]
    var latinTypeCurrent: BelarusianLacinka.BLVersion {
        get { DKKeyboardSettings.shared.belarusianLatinType }
        set {
            DKKeyboardSettings.shared.belarusianLatinType = newValue
            self.objectWillChange.send()
        }
    }

    let autocapitalizationCellTitle = "Аўтаматычна вялікая літара"
    lazy var autocapitalizationAvailableOptions: [DKSettingViewOption<DKKeyboardAutocapitalization>] = [
        DKSettingViewOption(title: "Ніколі", value: .none),
        DKSettingViewOption(title: "Слова", value: .words),
        DKSettingViewOption(title: "Сказ", value: .sentences)
    ]
    var autocapitalizationCurrent: DKKeyboardAutocapitalization {
        get { DKKeyboardSettings.shared.keyboardAutocapitalization }
        set {
            DKKeyboardSettings.shared.keyboardAutocapitalization = newValue
            self.objectWillChange.send()
        }
    }
    
    let keyboardFeedbackCellTitle = "Водгук націскання кнопак"
    lazy var keyboardFeedbackAvailableOptions: [DKSettingViewOption<DKKeyboardFeedback>] = [
        DKSettingViewOption(title: "Няма", value: .none),
        DKSettingViewOption(title: "Аудыя", value: .sound),
        DKSettingViewOption(title: "Вібрацыя", value: .vibro),
        DKSettingViewOption(title: "Аудыя і вібрацыя", value: .soundAndVibro)
    ]
    var keyboardFeedbackCurrent: DKKeyboardFeedback {
        get { DKKeyboardSettings.shared.keyboardFeedback }
        set {
            DKKeyboardSettings.shared.keyboardFeedback = newValue
            self.objectWillChange.send()
        }
    }
    
    let interfaceTransliterationCellTitle = "Транслітэрацыя інтэрфейсу"
    @Published var interfaceTransliteration: DKKeyboardLayout = DKKeyboardSettings.shared.interfaceTransliteration ?? DKKeyboardSettings.shared.defaultInterfaceTransliteration {
        didSet {
            DKKeyboardSettings.shared.interfaceTransliteration = interfaceTransliteration
        }
    }
    lazy var interfaceTransliterationOptions: [DKSettingViewOption<DKKeyboardLayout>] = [
        DKSettingViewOption(title: "Łacinka", value: .latin),
        DKSettingViewOption(title: "Кірыліца", value: .cyrillic),
    ]
    
    let otherLanguagesCellTitle = "Падтрымка літар іншых моў"
    @Published var otherLanguagesCellDescription: String = ""
    let otherLanguagesViewModel = DKSettingsLanguagesViewModel()

    init() {
        self.otherLanguagesViewModel.$supportedLanguages.sink { otherLanguages in
            self.otherLanguagesCellDescription = otherLanguages
        }.store(in: &self.cancellableSinks)
    }
}
