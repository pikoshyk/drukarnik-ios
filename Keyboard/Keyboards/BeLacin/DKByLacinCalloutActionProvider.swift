//
//  DKBeCyrillicCalloutActionProvider.swift
//  Keyboard
//
//  Created by Logout on 5.12.22.
//

import KeyboardKit

class DKByLacinCalloutActionProvider: DKByCalloutActionProvider, KeyboardKit.LocalizedService {
    
    public let localeKey: String = DKByKeyboardLayout.latin.localeIdentifier
    
    open override func calloutActionString(for char: String) -> String {
        switch char {
        case "l": return "lĺł"
        case "n": return "nń"
        case "z": return "zźž"
        case "c": return "cćč"
        case "s": return "sśš"
        case "u": return "uŭ"
        default: return super.calloutActionString(for: char)
        }
    }
}

