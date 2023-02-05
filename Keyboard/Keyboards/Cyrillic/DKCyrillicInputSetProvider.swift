//
//  DKKeyboardInputSetProvider.swift
//  Keyboard
//
//  Created by Logout on 29.11.22.
//

import KeyboardKit
    
class DKCyrillicInputSetProvider: LocalizedInputSetProvider {
    
    public let localeKey: String = DKKeyboardLayout.cyrillic.localeIdentifier

    let baseProvider = EnglishInputSetProvider()

    var alphabeticInputSet: AlphabeticInputSet {
        AlphabeticInputSet(rows: [
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
    }

    var numericInputSet: NumericInputSet {
        let currency = "$"
        return NumericInputSet(rows: [
            .init(chars: "1234567890"),
            .init(phone: "-/:;()\(currency)&@\"", pad: "@#\(currency)&*()'\""),
            .init(phone: ".,?!'", pad: "%-+=/;:!?")
        ])
    }

    var symbolicInputSet: SymbolicInputSet {
        let currencies = ["$", "€", "£"]
        return SymbolicInputSet(rows: [
            .init(phone: "[]{}#%^*+=", pad: "1234567890"),
            .init(
                phone: "_\\|~<>\(currencies.joined())•",
                pad: "\(currencies.joined())_^[]{}"),
            .init(phone: ".,?!'", pad: "§|~…\\<>!?")
        ])
    }
}
