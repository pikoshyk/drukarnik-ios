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
        DKSettingViewOption(title: "Адключана", value: .none),
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
        DKSettingViewOption(title: "Адключана", value: .none),
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

    init() {
        
    }
}
