//
//  DKKeyboardSettings.swift
//  Keyboard
//
//  Created by Logout on 19.12.22.
//

import BelarusianLacinka
import UIKit

class DKKeyboardEmojiRecentsItem: Codable, Identifiable {
    var id: String { self.emoji }
    let emoji: String
    var usage: [Date]
    
    init(emoji: String, usage: [Date] = [Date()]) {
        self.emoji = emoji
        self.usage = usage
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.emoji = try container.decode(String.self, forKey: .emoji)
        self.usage = try container.decode([Date].self, forKey: .usage)
    }
    
    enum CodingKeys: CodingKey {
        case emoji
        case usage
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.emoji, forKey: .emoji)
        try container.encode(self.usage, forKey: .usage)
    }
}

enum DKKeyboardAutocapitalization: String, Codable{
    case allCharacters
    case sentences
    case words
    case none
}

enum DKKeyboardFeedback: String, Codable {
    case none
    case sound
    case vibro
    case soundAndVibro
}

class DKKeyboardSettings: Any {
#if MAIN_APP
    static let shared = DKKeyboardSettings()
    
    class func isKeyboardActivated() -> Bool {
        let keyboardBundleID = "com.belanghelp.drukarnik.keyboard"
        guard let keyboards = UserDefaults.standard.object(forKey: "AppleKeyboards") as? [String] else {
            return false
        }
        for keyboard in keyboards {
            if keyboard == keyboardBundleID {
                Self.shared.keyboardInstallationCompleted = true
                return true
            }
        }
        return false
    }
#endif
    let lacinkaConverter = BLConverter()
    
    let userDefaultsGroupIdeintifier = "group.com.belanghelp.drukarnik"
    lazy var userDefaults = UserDefaults(suiteName: self.userDefaultsGroupIdeintifier)!

    lazy var availableAdditionalLanguages: [DKAdditionalLanguage] =  DKAdditionalLanguages.load()
    let defaultInterfaceTransliteration: DKKeyboardLayout = .cyrillic
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
    
    var shareTypingData: Bool {
        get {
            let defaultValue = false
            let value = self.getter(key: DKKeyboardSettingsKeys.shareTypingData, defaultValue: defaultValue)
            return value
        }
        set {
            self.setter(key: DKKeyboardSettingsKeys.shareTypingData, value: newValue, notificationName: .shareTypingDataChanged)
        }
    }
    
    var keyboardInstallationCompleted: Bool {
        get {
            let defaultValue = false
            let value = (self.userDefaults.object(forKey: DKKeyboardSettingsKeys.keyboardInstallationCompleted) as? Bool) ?? defaultValue
            return value
        }
        set {
            self.setter(key: DKKeyboardSettingsKeys.keyboardInstallationCompleted, value: newValue, notificationName: .keyboardInstallationCompletedChanged)
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

    var keyboardAutocapitalization: DKKeyboardAutocapitalization {
        get {
            let defaultValue = DKKeyboardAutocapitalization.sentences
            let value = self.getter(key: DKKeyboardSettingsKeys.keyboardAutocapitalization, defaultValue: defaultValue.rawValue)
            return DKKeyboardAutocapitalization(rawValue: value) ?? defaultValue
        }
        set {
            self.setter(key: DKKeyboardSettingsKeys.keyboardAutocapitalization, value: newValue.rawValue, notificationName: nil)
        }
    }

    var keyboardFeedback: DKKeyboardFeedback {
        get {
            let defaultValue: DKKeyboardFeedback = .none
            let value = self.getter(key: DKKeyboardSettingsKeys.keyboardFeedback, defaultValue: defaultValue.rawValue)
            return DKKeyboardFeedback(rawValue: value) ?? defaultValue
        }
        set {
            self.setter(key: DKKeyboardSettingsKeys.keyboardFeedback, value: newValue.rawValue, notificationName: nil)
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
    
    var keyboardEmojiRecents: [DKKeyboardEmojiRecentsItem] {
        get {
            let defaultValue: Data = "[]".data(using: .utf8)!
            
            let data = self.getter(key: DKKeyboardSettingsKeys.keyboardEmojiRecents, defaultValue: defaultValue)
            guard let value = try? JSONDecoder().decode([DKKeyboardEmojiRecentsItem].self, from: data) else {
                return []
            }
            return value
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                return
            }
            self.setter(key: DKKeyboardSettingsKeys.keyboardEmojiRecents, value: data)
        }
    }
}
