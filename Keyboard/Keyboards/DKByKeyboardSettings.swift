//
//  DKByKeyboardSettings.swift
//  Keyboard
//
//  Created by Logout on 19.12.22.
//

import BelarusianLacinka
import UIKit

enum DKByKeyboardLayout: String {
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

class DKByKeyboardSettingsKeys {
    class var keyboardLayout: String { "DKByKeyboardSettings.keyboard_layout" }
    class var interfaceTransliteration: String { "DKByKeyboardSettings.interface_transliteration" }
}

class DKByKeyboardSettings: Any {
    static let shared = DKByKeyboardSettings()

    lazy var userDefaults = UserDefaults.standard
    fileprivate var _keybaordLayout: DKByKeyboardLayout?
    fileprivate var _interfaceTransliteration: DKByKeyboardLayout?
    
    static let lacinkaConverter = BLConverter()
    
    fileprivate init() {
    }
    
    var keyboardLayout: DKByKeyboardLayout {
        get {
            if let layout = self._keybaordLayout {
                return layout
            }
            let keybaordLayout = DKByKeyboardLayout(rawValue: self.userDefaults.string(forKey: DKByKeyboardSettingsKeys.keyboardLayout) ?? DKByKeyboardLayout.latin.rawValue)
            self._keybaordLayout = keybaordLayout ?? .latin
            return self._keybaordLayout!
        }
        set {
            self._keybaordLayout = newValue
            self.userDefaults.set(newValue.rawValue, forKey: DKByKeyboardSettingsKeys.keyboardLayout)
            self.userDefaults.synchronize()
        }
    }
    
    var interfaceTransliteration: DKByKeyboardLayout {
        get {
            if let interfaceTransliteration = self._interfaceTransliteration {
                return interfaceTransliteration
            }
            let interfaceTransliteration = DKByKeyboardLayout(rawValue: self.userDefaults.string(forKey: DKByKeyboardSettingsKeys.interfaceTransliteration) ?? DKByKeyboardLayout.latin.rawValue)
            self._interfaceTransliteration = interfaceTransliteration ?? .latin
            return self._interfaceTransliteration!
        }
        set {
            self._interfaceTransliteration = newValue
            self.userDefaults.set(newValue.rawValue, forKey: DKByKeyboardSettingsKeys.interfaceTransliteration)
            self.userDefaults.synchronize()
        }
    }
    
    
}
