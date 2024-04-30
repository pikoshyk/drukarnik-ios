//
//  DKKeyboardLayout.swift
//  Drukarnik
//
//  Created by Logout on 30.04.24.
//

import Foundation

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
