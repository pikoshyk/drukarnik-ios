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
    class var keyboardLayout: String { "keyboard_layout" }
}

class DKByKeyboardSettings: Any {
    static let shared = DKByKeyboardSettings()

    lazy var userDefaults = UserDefaults.standard
    fileprivate var _layout: DKByKeyboardLayout?
    
    static let lacinkaConverter = BLConverter()
    
    fileprivate init() {
    }
    
    var keyboardLayout: DKByKeyboardLayout {
        get {
            if let layout = self._layout {
                return layout
            }
            let layout = DKByKeyboardLayout(rawValue: self.userDefaults.string(forKey: DKByKeyboardSettingsKeys.keyboardLayout) ?? DKByKeyboardLayout.latin.rawValue)
            self._layout = layout ?? .latin
            return self._layout!
        }
        set {
            self._layout = newValue
            self.userDefaults.set(newValue.rawValue, forKey: DKByKeyboardSettingsKeys.keyboardLayout)
            self.userDefaults.synchronize()
        }
    }
    
}
