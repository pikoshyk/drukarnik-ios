//
//  DKCyrillicLayoutProvider.swift
//  Keyboard
//
//  Created by Logout on 11.12.22.
//

import Foundation
import KeyboardKit

class DKCyrillicLayoutProvider: DKKeyboardLayoutProvider {
    
    private static let cyrAlphabeticInputSet = InputSet(rows: [
        .init(lowercased: ["й", "ц", "у", "к", "е", "н", "г", "ш", "ў", "з", "х", "’"],
              uppercased: ["Й", "Ц", "У", "К", "Е", "Н", "Г", "Ш", "Ў", "З", "Х", "’"]),
        .init(lowercased: ["ф", "ы", "в", "а", "п", "р", "о", "л", "д", "ж", "э", "ё"],
              uppercased: ["Ф", "Ы", "В", "А", "П", "Р", "О", "Л", "Д", "Ж", "Э", "Ё"]),
        .init(
              phoneLowercased: ["я", "ч", "с", "м", "і", "т", "ь", "б", "ю"],
              phoneUppercased: ["Я", "Ч", "С", "М", "І", "Т", "Ь", "Б", "Ю"],
              padLowercased: ["я", "ч", "с", "м", "і", "т", "ь", "б", "ю", ",", "."],
              padUppercased: ["Я", "Ч", "С", "М", "І", "Т", "Ь", "Б", "Ю", ",", "."])
    ])

    private static let cyrNumericInputSet =  InputSet(rows: [
        .init(chars: "1234567890"),
        .init(phone: "-/:;()$&@\"", pad: "@#$&*()'\""),
        .init(phone: ".,?!'", pad: "%-+=/;:!?")
    ])

    private static let cyrSymbolicInputSet = InputSet(rows: [
        .init(phone: "[]{}#%^*+=", pad: "1234567890"),
        .init(phone: "_\\|~<>$€£•", pad: "$€£_^[]{}"),
        .init(phone: ".,?!'", pad: "§|~…\\<>!?")
    ])

    init(keyboardContext: KeyboardContext) {
        super.init(alphabeticInputSet: Self.cyrAlphabeticInputSet,
                   numericInputSet: Self.cyrNumericInputSet,
                   symbolicInputSet: Self.cyrSymbolicInputSet)
        self.localeKey = DKKeyboardLayout.cyrillic.localeIdentifier
    }

    override func keyboardLayout(for context: KeyboardContext) -> KeyboardLayout {
        let layout = super.keyboardLayout(for: context)

        if context.keyboardType.isAlphabetic {
            let latinKeyboardItem = layout.keyboardLayoutSystemItem(action: .custom(named: DKKeyboardLayout.latin.rawValue))
            if let latinKeyboardItem = latinKeyboardItem {
                layout.insertButtomItem(latinKeyboardItem, at: 1)
            }
        }
        
        return layout
    }
}
