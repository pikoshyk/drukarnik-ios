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
    
    var presentNavigationTitle: String { DKLocalizationApp.settingsTitleFull }
    var presentCyrillicTypeCellTitle: String { DKLocalizationApp.settingsBelarusianCyrillicTypeTitle }
    var presentCyrillicTypeAvailableOptions: [DKSettingViewOption<BelarusianLacinka.BLOrthography>] {
        [DKSettingViewOption(title: DKLocalizationApp.converterBelarusianCyrillicTypeNarkamauka, value: .academic),
         DKSettingViewOption(title: DKLocalizationApp.converterBelarusianCyrillicTypeTarashkevica, value: .classic)]
    }
    var presentCyrillicTypeCurrent: BelarusianLacinka.BLOrthography {
        get { DKKeyboardSettings.shared.belarusianCyrillicType }
        set {
            DKKeyboardSettings.shared.belarusianCyrillicType = newValue
            self.objectWillChange.send()
        }
    }

    
    var presentLatinTypeCellTitle: String { DKLocalizationApp.settingsBelarusianLatinTypeTitle }
    var presentLatinTypeAvailableOptions: [DKSettingViewOption<BelarusianLacinka.BLVersion>] {
        [DKSettingViewOption(title: DKLocalizationApp.converterBelarusianLatinTypeTraditional, value: .traditional),
         DKSettingViewOption(title: DKLocalizationApp.converterBelarusianLatinTypeGeographic, value: .geographic)]
    }
    var presentLatinTypeCurrent: BelarusianLacinka.BLVersion {
        get { DKKeyboardSettings.shared.belarusianLatinType }
        set {
            DKKeyboardSettings.shared.belarusianLatinType = newValue
            self.objectWillChange.send()
        }
    }

    var presentAutocapitalizationCellTitle: String { DKLocalizationApp.settingsAutocapitalizationTypeTitle }
    var presentAutocapitalizationAvailableOptions: [DKSettingViewOption<DKKeyboardAutocapitalization>] {
        [DKSettingViewOption(title: DKLocalizationApp.settingsAutocapitalizationTypeNever, value: .none),
         DKSettingViewOption(title: DKLocalizationApp.settingsAutocapitalizationTypeWord, value: .words),
         DKSettingViewOption(title: DKLocalizationApp.settingsAutocapitalizationTypeSentense, value: .sentences)]
    }
    var presentAutocapitalizationCurrent: DKKeyboardAutocapitalization {
        get { DKKeyboardSettings.shared.keyboardAutocapitalization }
        set {
            DKKeyboardSettings.shared.keyboardAutocapitalization = newValue
            self.objectWillChange.send()
        }
    }
    
    var presentKeyboardFeedbackCellTitle: String { DKLocalizationApp.settingsKeyboardFeedbackTypeTitle }
    var presentKeyboardFeedbackAvailableOptions: [DKSettingViewOption<DKKeyboardFeedback>] {
        [DKSettingViewOption(title: DKLocalizationApp.settingsKeyboardFeedbackTypeNone, value: .none),
         DKSettingViewOption(title: DKLocalizationApp.settingsKeyboardFeedbackTypeAudio, value: .sound),
         DKSettingViewOption(title: DKLocalizationApp.settingsKeyboardFeedbackTypeVibro, value: .vibro),
         DKSettingViewOption(title: DKLocalizationApp.settingsKeyboardFeedbackTypeAudioAndVibro, value: .soundAndVibro)]
    }
    var presentKeyboardFeedbackCurrent: DKKeyboardFeedback {
        get { DKKeyboardSettings.shared.keyboardFeedback }
        set {
            DKKeyboardSettings.shared.keyboardFeedback = newValue
            self.objectWillChange.send()
        }
    }
    
    var presentInterfaceTransliterationCellTitle: String { DKLocalizationApp.settingsTransliterationTitle }
    var presentInterfaceTransliteration: DKKeyboardLayout {
        get {
            DKKeyboardSettings.shared.interfaceTransliteration ?? DKKeyboardSettings.shared.defaultInterfaceTransliteration
        }
        set {
            DKKeyboardSettings.shared.interfaceTransliteration = newValue
            self.objectWillChange.send()
        }
    }
    
    var presentInterfaceTransliterationOptions: [DKSettingViewOption<DKKeyboardLayout>] {
        [DKSettingViewOption(title: DKLocalizationApp.settingsTransliterationSegmentedLatin, value: .latin),
         DKSettingViewOption(title: DKLocalizationApp.settingsTransliterationSegmentedCyrillic, value: .cyrillic)]
    }
    
    var presentOtherLanguagesCellTitle: String { DKLocalizationApp.settingsLanguagesTitle }
    var presentOtherLanguagesCellDescription: String {
        DKLocalizationApp.processedWord(self.otherLanguagesCellDescription)
    }
    private var otherLanguagesCellDescription: String = "" {
        didSet { self.objectWillChange.send() }
    }
    let otherLanguagesViewModel: DKSettingsLanguagesViewModel

    init() {
        self.otherLanguagesViewModel = DKSettingsLanguagesViewModel()
        self.otherLanguagesViewModel.$supportedLanguages.sink { [weak self] otherLanguages in
            self?.otherLanguagesCellDescription = otherLanguages
        }.store(in: &self.cancellableSinks)
    }
}
