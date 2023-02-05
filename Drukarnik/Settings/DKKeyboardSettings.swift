//
//  DKKeyboardSettings.swift
//  Keyboard
//
//  Created by Logout on 19.12.22.
//

import BelarusianLacinka
import UIKit

extension Notification.Name {
    static let interfaceChanged = Notification.Name("interfaceChanged")
    static let interfaceTransliterationChanged = Notification.Name("interfaceTransliterationChanged")
    static let belarusianLatinTypeChanged = Notification.Name("belarusianLatinTypeChanged")
    static let belarusianCyrillicTypeChanged = Notification.Name("belarusianCyrillicTypeChanged")
}

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

class DKKeyboardSettingsKeys {
    class var keyboardLayout: String { "DKKeyboardSettings.keyboard_layout" }
    class var interfaceTransliteration: String { "DKKeyboardSettings.interface_transliteration" }
    class var additionalLanguageIds: String { "DKKeyboardSettings.additional_language_ids" }
    class var belarusianLatinType: String { "DKKeyboardSettings.belarusian_latin_type" }
    class var belarusianCyrillicType: String { "DKKeyboardSettings.belarusian_cyrillic_type" }
}

class DKKeyboardSettings: Any {
#if MAIN_APP
    static let shared = DKKeyboardSettings()
#endif
    let lacinkaConverter = BLConverter()

    let userDefaultsGroupIdeintifier = "group.com.belanghelp.drukarnik"
    lazy var userDefaults = UserDefaults(suiteName: self.userDefaultsGroupIdeintifier)!
    fileprivate var _keybaordLayout: DKKeyboardLayout?
    fileprivate var _interfaceTransliteration: DKKeyboardLayout?
    fileprivate var _supportedAdditionalLanguages: [DKAdditionalLanguage]?

    init() {
#if MAIN_APP
//        NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: OperationQueue.main) { notification in
//            let center = CFNotificationCenterGetDarwinNotifyCenter()
//            CFNotificationCenterPostNotification(center, CFNotificationName.init("defaultsChangedOnTheOtherSide" as CFString), nil, nil, true)
//        }

//    https://gist.github.com/phatblat/f640416c15e11b685511
#endif
        self.firstInitialization()
    }
    
    func firstInitialization() {
        if self.userDefaults.stringArray(forKey: DKKeyboardSettingsKeys.additionalLanguageIds) == nil {
            self.supportedAdditionalLanguages = self.prefferedLanguages
        }
    }
    
    func reloadSettings() {
        self._keybaordLayout = nil
        self._interfaceTransliteration = nil
        self._belarusianLatinType = nil
        self._belarusianCyrillicType = nil
    }
    
    var prefferedLanguages: [DKAdditionalLanguage] {
        var prefferedLanguages: [DKAdditionalLanguage] = []

        let prefferedLanguagesStr = Locale.preferredLanguages
        for prefferedLanguageStr in prefferedLanguagesStr {
            let languages = self.availableAdditionalLanguages.filter { prefferedLanguageStr.starts(with: $0.code) }
            prefferedLanguages.append(contentsOf: languages)
        }
        if prefferedLanguages.count == 0 {
            prefferedLanguages = self.availableAdditionalLanguages.filter {$0.id == "ukranian" || $0.id == "polish"}
        }

//        prefferedLanguages = self.availableAdditionalLanguages.filter {$0.id == "ukranian" || $0.id == "polish"}

        return prefferedLanguages
    }
    
    lazy var availableAdditionalLanguages: [DKAdditionalLanguage] =  DKAdditionalLanguages.load()
    
    var supportedAdditionalLanguages: [DKAdditionalLanguage] {
        get {
            if let value = self._supportedAdditionalLanguages {
                return value
            }
            let value = self.userDefaults.stringArray(forKey: DKKeyboardSettingsKeys.additionalLanguageIds) ?? []
            let languages = self.availableAdditionalLanguages.filter { value.contains($0.id) }
            self._supportedAdditionalLanguages = languages
            return self._supportedAdditionalLanguages!
        }
        set {
            self._supportedAdditionalLanguages = newValue
            let languages = newValue.compactMap { $0.id }
            self.userDefaults.set(languages, forKey: DKKeyboardSettingsKeys.additionalLanguageIds)
            self.userDefaults.synchronize()
        }
    }
    
    var keyboardLayout: DKKeyboardLayout {
        get {
            if let layout = self._keybaordLayout {
                return layout
            }
            let keybaordLayout = DKKeyboardLayout(rawValue: self.userDefaults.string(forKey: DKKeyboardSettingsKeys.keyboardLayout) ?? DKKeyboardLayout.latin.rawValue)
            self._keybaordLayout = keybaordLayout ?? .latin
            return self._keybaordLayout!
        }
        set {
            self._keybaordLayout = newValue
            self.userDefaults.set(newValue.rawValue, forKey: DKKeyboardSettingsKeys.keyboardLayout)
            self.userDefaults.synchronize()
        }
    }
    
    let defaultInterfaceTransliteration: DKKeyboardLayout = .latin

    var interfaceTransliteration: DKKeyboardLayout? {
        get {
            if let interfaceTransliteration = self._interfaceTransliteration {
                return interfaceTransliteration
            }
            guard let interfaceStr = self.userDefaults.string(forKey: DKKeyboardSettingsKeys.interfaceTransliteration) else {
                return nil
            }
            let interfaceTransliteration = DKKeyboardLayout(rawValue: interfaceStr)
            self._interfaceTransliteration = interfaceTransliteration
            return self._interfaceTransliteration
        }
        set {
            guard let newValue = newValue else {
                return
            }
            self._interfaceTransliteration = newValue
            self.userDefaults.set(newValue.rawValue, forKey: DKKeyboardSettingsKeys.interfaceTransliteration)
            self.userDefaults.synchronize()
            NotificationCenter.default.post(name: .interfaceTransliterationChanged, object: newValue)
            NotificationCenter.default.post(name: .interfaceChanged, object: newValue)
        }
    }
    
    fileprivate var _belarusianLatinType: BelarusianLacinka.BLVersion?
    let defaultBelarusianLatinType: BelarusianLacinka.BLVersion = .traditional

    var belarusianLatinType: BelarusianLacinka.BLVersion {
        get {
            if let belarusianLatinType = self._belarusianLatinType {
                return belarusianLatinType
            }
            guard let belarusianLatinTypeStr = self.userDefaults.string(forKey: DKKeyboardSettingsKeys.belarusianLatinType) else {
                return self.defaultBelarusianLatinType
            }
            let belarusianLatinType = BelarusianLacinka.BLVersion(rawValue: belarusianLatinTypeStr)
            self._belarusianLatinType = belarusianLatinType
            return self._belarusianLatinType ?? self.defaultBelarusianLatinType
        }
        set {
            self._belarusianLatinType = newValue
            self.userDefaults.set(newValue.rawValue, forKey: DKKeyboardSettingsKeys.belarusianLatinType)
            self.userDefaults.synchronize()
            NotificationCenter.default.post(name: .belarusianLatinTypeChanged, object: newValue)
            NotificationCenter.default.post(name: .interfaceChanged, object: newValue)
        }
    }
    
    fileprivate var _belarusianCyrillicType: BelarusianLacinka.BLOrthography?
    let defaultBelarusianCyrillicType: BelarusianLacinka.BLOrthography = .academic

    var belarusianCyrillicType: BelarusianLacinka.BLOrthography {
        get {
            if let belarusianCyrillicType = self._belarusianCyrillicType {
                return belarusianCyrillicType
            }
            guard let belarusianCyrillicTypeStr = self.userDefaults.string(forKey: DKKeyboardSettingsKeys.belarusianCyrillicType) else {
                return self.defaultBelarusianCyrillicType
            }
            let belarusianCyrillicType = BelarusianLacinka.BLOrthography(rawValue: belarusianCyrillicTypeStr)
            self._belarusianCyrillicType = belarusianCyrillicType
            return self._belarusianCyrillicType ?? self.defaultBelarusianCyrillicType
        }
        set {
            self._belarusianCyrillicType = newValue
            self.userDefaults.set(newValue.rawValue, forKey: DKKeyboardSettingsKeys.belarusianCyrillicType)
            self.userDefaults.synchronize()
            NotificationCenter.default.post(name: .belarusianCyrillicTypeChanged, object: newValue)
            NotificationCenter.default.post(name: .interfaceChanged, object: newValue)
        }
    }
}
