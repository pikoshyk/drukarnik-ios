//
//  DKKeyboardInputSetProvider.swift
//  Keyboard
//
//  Created by Logout on 29.11.22.
//

import KeyboardKit
    
class DKByLacinInputSetProvider: LocalizedInputSetProvider {
    
    public let localeKey: String = DKByKeyboardLayout.latin.localeIdentifier

    let baseProvider = EnglishInputSetProvider()

    var alphabeticInputSet: AlphabeticInputSet {
        AlphabeticInputSet(rows: [
            .init(lowercased: ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
                  uppercased: ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]),
            .init(lowercased: ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
                  uppercased: ["A", "S", "D", "F", "G", "H", "J", "K", "L"]),
            .init(
                phoneLowercased: ["z", "x", "c", "v", "b", "n", "m"],
                phoneUppercased: ["Z", "X", "C", "V", "B", "N", "M"],
                padLowercased: ["z", "x", "c", "v", "b", "n", "m", ",", "."],
                padUppercased: ["Z", "X", "C", "V", "B", "N", "M", ",", "."])
        ])
    }

    var numericInputSet: NumericInputSet {
        baseProvider.numericInputSet
    }

    var symbolicInputSet: SymbolicInputSet {
        baseProvider.symbolicInputSet
    }
}
