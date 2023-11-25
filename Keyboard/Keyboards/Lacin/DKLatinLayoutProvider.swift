//
//  DKLatinLayoutProvider.swift
//  Keyboard
//
//  Created by Logout on 11.12.22.
//

import Foundation
import KeyboardKit

class DKLatinLayoutProvider: DKKeyboardLayoutProvider {
    
    static let latAlphabeticInputSet = InputSet(rows: [
        .init(lowercased: ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
              uppercased: ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]),
        .init(lowercased: ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
              uppercased: ["A", "S", "D", "F", "G", "H", "J", "K", "L"]),
        .init(phoneLowercased: ["z", "x", "c", "v", "b", "n", "m"],
              phoneUppercased: ["Z", "X", "C", "V", "B", "N", "M"],
              padLowercased: ["z", "x", "c", "v", "b", "n", "m", ",", "."],
              padUppercased: ["Z", "X", "C", "V", "B", "N", "M", ",", "."])
    ])

    static let latNumericInputSet =  InputSet(rows: [
        .init(chars: "1234567890"),
        .init(phone: "-/:;()$&@\"", pad: "@#$&*()'\""),
        .init(phone: ".,?!'", pad: "%-+=/;:!?")
    ])

    static let latSymbolicInputSet = InputSet(rows: [
        .init(phone: "[]{}#%^*+=", pad: "1234567890"),
        .init(phone: "_\\|~<>$€£•", pad: "$€£_^[]{}"),
        .init(phone: ".,?!'", pad: "§|~…\\<>!?")
    ])

    init() {
        super.init(alphabeticInputSet: Self.latAlphabeticInputSet,
                   numericInputSet: Self.latNumericInputSet,
                   symbolicInputSet: Self.latSymbolicInputSet)
        self.localeKey = DKKeyboardLayout.latin.localeIdentifier
//        EnglishKeyboardLayoutProvider()
    }
    
    override func keyboardLayout(for context: KeyboardContext) -> KeyboardLayout {
        let layout = super.keyboardLayout(for: context)

        if context.keyboardType.isAlphabetic {
            if let cyrillicKeyboardItem = layout.keyboardLayoutSystemItem(action: .custom(named: DKKeyboardLayout.cyrillic.rawValue)) {
                layout.insertButtomItem(cyrillicKeyboardItem, at: 1)
            }
        }

        return layout
    }
}
