//
//  DKAdditionalLanguage.swift
//  Drukarnik
//
//  Created by Logout on 24.01.23.
//

import Foundation

struct DKAdditionalLanguage: Codable {
    var id: String
    private var name_cyrillic: String
    var code: String
    var layout: DKKeyboardLayout
    var chars: [String: [String]]
    
    var name: String {
        self.name_cyrillic
    }
    
    func extendedChars(baseChar: String) -> String? {
        let extendedChars = self.chars[baseChar]
        let extendedCharsStr = extendedChars?.joined()
        return extendedCharsStr
    }
}


/*
 "id": "polish",
 "name": "Польская",
 "type": "latin",
 "chars": {
     "z": ["ż","ź"],
     "s": ["ś"],
     "o": ["ó"],
     "a": ["ą"],
     "l": ["ł"],
     "n": ["ń"],
     "c": ["ć"],
     "e": ["ę"]
 }
 */
