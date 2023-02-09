//
//  DKKeyboardSettings.swift
//  Keyboard
//
//  Created by Logout on 19.12.22.
//

import BelarusianLacinka
import UIKit

enum DKKeyboardLayout: String, Codable {
case latin
case cyrillic
    
    var label: String {
        self == .latin ? "Ŭŭ" : "Ўў"
    }

    var localeLanguage: String {
        self == .latin ? "be-Latn" : "be-Cyrl"
    }

    var localeIdentifier: String {
        self.localeLanguage + "_BY"
    }
    
    var locale: Locale {
        Locale(identifier: self.localeIdentifier)
    }
}

extension Notification.Name {
    static let interfaceChanged = Notification.Name("interfaceChanged")
    static let interfaceTransliterationChanged = Notification.Name("interfaceTransliterationChanged")
    static let belarusianLatinTypeChanged = Notification.Name("belarusianLatinTypeChanged")
    static let belarusianCyrillicTypeChanged = Notification.Name("belarusianCyrillicTypeChanged")
    static let converterVersionChanged = Notification.Name("converterVersionChanged")
    static let converterOrthographyChanged = Notification.Name("converterOrthographyChanged")
}

class DKKeyboardSettingsKeys {
    class var keyboardLayout: String { "DKKeyboardSettings.keyboard_layout" }
    class var interfaceTransliteration: String { "DKKeyboardSettings.interface_transliteration" }
    class var additionalLanguageIds: String { "DKKeyboardSettings.additional_language_ids" }
    class var belarusianLatinType: String { "DKKeyboardSettings.belarusian_latin_type" }
    class var belarusianCyrillicType: String { "DKKeyboardSettings.belarusian_cyrillic_type" }
    class var converterVersion: String { "DKKeyboardSettings.converter_version" }
    class var converterOrthography: String { "DKKeyboardSettings.converter_orthography" }
    class var autocompleteTransliteration: String { "DKKeyboardSettings.autocomplete_transliteration" }
}

class DKKeyboardSettings: Any {
#if MAIN_APP
    static let shared = DKKeyboardSettings()
#endif
    let lacinkaConverter = BLConverter()
    
    let userDefaultsGroupIdeintifier = "group.com.belanghelp.drukarnik"
    lazy var userDefaults = UserDefaults(suiteName: self.userDefaultsGroupIdeintifier)!

    lazy var availableAdditionalLanguages: [DKAdditionalLanguage] =  DKAdditionalLanguages.load()
    let defaultInterfaceTransliteration: DKKeyboardLayout = .latin
    let defaultBelarusianLatinType: BelarusianLacinka.BLVersion = .traditional
    let defaultBelarusianCyrillicType: BelarusianLacinka.BLOrthography = .academic

    fileprivate var _settings: [String: Any] = [:]
    fileprivate var _settingsSupportedAdditionalLanguages: [DKAdditionalLanguage]?

    init() {
        self.firstInitialization()
    }
    
    func firstInitialization() {
        if self.userDefaults.stringArray(forKey: DKKeyboardSettingsKeys.additionalLanguageIds) == nil {
            self.supportedAdditionalLanguages = self.prefferedLanguages
        }
    }
    
    func reloadSettings() {
        self._settingsSupportedAdditionalLanguages = nil
        self._settings = [:]
    }
    
    func getter<T: Encodable>(key: String) -> T? {
        if let value = self._settings[key] as? T {
            return value
        }
        let value = self.userDefaults.object(forKey: key) as? T
        self._settings[key] = value
        return value
    }

    func getter<T: Encodable>(key: String, defaultValue: T) -> T {
        if let value = self._settings[key] as? T {
            return value
        }
        let value = (self.userDefaults.object(forKey: key) as? T) ?? defaultValue

        self._settings[key] = value
        return value
    }

    func setter<T: Encodable>(key: String, value: T, notificationName: Notification.Name? = nil) {
        self._settings[key] = value
        self.userDefaults.set(value, forKey: key)
        self.userDefaults.synchronize()
        if let notificationName = notificationName {
            NotificationCenter.default.post(name: notificationName, object: value)
            NotificationCenter.default.post(name: .interfaceChanged, object: value)
        }
    }
}

extension DKKeyboardSettings { // App Settings

    var converterVersion: BelarusianLacinka.BLVersion {
        get {
            let defaultValue = BelarusianLacinka.BLVersion.traditional
            let value = self.getter(key: DKKeyboardSettingsKeys.converterVersion, defaultValue: defaultValue.rawValue)
            return BelarusianLacinka.BLVersion(rawValue: value) ?? defaultValue
        }
        set {
            self.setter(key: DKKeyboardSettingsKeys.converterVersion, value: newValue.rawValue, notificationName: .converterVersionChanged)
        }
    }

    var converterOrthography: BelarusianLacinka.BLOrthography {
        get {
            let defaultValue = BelarusianLacinka.BLOrthography.academic
            let value = self.getter(key: DKKeyboardSettingsKeys.converterOrthography, defaultValue: defaultValue.rawValue)
            return BelarusianLacinka.BLOrthography(rawValue: value) ?? defaultValue
        }
        set {
            self.setter(key: DKKeyboardSettingsKeys.converterOrthography, value: newValue.rawValue, notificationName: .converterOrthographyChanged)
        }
    }

    var belarusianCyrillicType: BelarusianLacinka.BLOrthography {
        get {
            let defaultValue = self.defaultBelarusianCyrillicType
            let value = self.getter(key: DKKeyboardSettingsKeys.belarusianCyrillicType, defaultValue: defaultValue.rawValue)
            return BelarusianLacinka.BLOrthography(rawValue: value) ?? defaultValue
        }
        set {
            self.setter(key: DKKeyboardSettingsKeys.belarusianCyrillicType, value: newValue.rawValue, notificationName: .belarusianCyrillicTypeChanged)
        }
    }
    
    var belarusianLatinType: BelarusianLacinka.BLVersion {
        get {
            let defaultValue = self.defaultBelarusianLatinType
            let value = self.getter(key: DKKeyboardSettingsKeys.belarusianLatinType, defaultValue: defaultValue.rawValue)
            return BelarusianLacinka.BLVersion(rawValue: value) ?? defaultValue
        }
        set {
            self.setter(key: DKKeyboardSettingsKeys.belarusianLatinType, value: newValue.rawValue, notificationName: .belarusianLatinTypeChanged)
        }
    }
    
    var interfaceTransliteration: DKKeyboardLayout? {
        get {
            var layout: DKKeyboardLayout?
            if let value = self.getter(key: DKKeyboardSettingsKeys.interfaceTransliteration) as String? {
                layout = DKKeyboardLayout(rawValue: value)
            }
            return layout
        }
        set {
            self.setter(key: DKKeyboardSettingsKeys.interfaceTransliteration, value: newValue?.rawValue, notificationName: .interfaceTransliterationChanged)
        }
    }
}

extension DKKeyboardSettings { // Keyboard Settings
    
    var autocompleteTransliteration: Bool {
        get {
            let defaultValue = false
            let value = self.getter(key: DKKeyboardSettingsKeys.autocompleteTransliteration, defaultValue: defaultValue)
            return value
        }
        set {
            self.setter(key: DKKeyboardSettingsKeys.autocompleteTransliteration, value: newValue, notificationName: nil)
        }
    }
    
    var keyboardLayout: DKKeyboardLayout {
        get {
            let defaultValue = DKKeyboardLayout.latin
            let value = self.getter(key: DKKeyboardSettingsKeys.keyboardLayout, defaultValue: defaultValue.rawValue)
            return DKKeyboardLayout(rawValue: value) ?? defaultValue
        }
        set {
            self.setter(key: DKKeyboardSettingsKeys.keyboardLayout, value: newValue.rawValue)
        }
    }

    var prefferedLanguages: [DKAdditionalLanguage] {
        var prefferedLanguages: [DKAdditionalLanguage] = []
        
        let prefferedLanguagesStr = Locale.preferredLanguages
        for prefferedLanguageStr in prefferedLanguagesStr {
            let languages = self.availableAdditionalLanguages.filter { prefferedLanguageStr.starts(with: $0.code) }
            prefferedLanguages.append(contentsOf: languages)
        }
        if prefferedLanguages.count == 0 {
            prefferedLanguages = self.availableAdditionalLanguages.filter { ["ukranian", "polish"].contains($0.id) }
        }
        
        return prefferedLanguages
    }

    var supportedAdditionalLanguages: [DKAdditionalLanguage] {
        get {
            if let value = self._settingsSupportedAdditionalLanguages {
                return value
            }
            let value = self.userDefaults.stringArray(forKey: DKKeyboardSettingsKeys.additionalLanguageIds) ?? []
            let languages = self.availableAdditionalLanguages.filter { value.contains($0.id) }
            self._settingsSupportedAdditionalLanguages = languages
            return self._settingsSupportedAdditionalLanguages!
        }
        set {
            self._settingsSupportedAdditionalLanguages = newValue
            let languages = newValue.compactMap { $0.id }
            self.userDefaults.set(languages, forKey: DKKeyboardSettingsKeys.additionalLanguageIds)
            self.userDefaults.synchronize()
        }
    }
    
}
