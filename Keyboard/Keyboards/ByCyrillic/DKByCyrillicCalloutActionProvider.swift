//
//  DKBeCyrillicCalloutActionProvider.swift
//  Keyboard
//
//  Created by Logout on 5.12.22.
//

import KeyboardKit

class DKByCyrillicCalloutActionProvider: DKByCalloutActionProvider, KeyboardKit.LocalizedService {
    
    public let localeKey: String = DKByKeyboardLayout.cyrillic.localeIdentifier
    
    open override func calloutActionString(for char: String) -> String {
        switch char {
        case "ў": return "ўщ"
        case "’": return "’ъ"
        case "э": return "эє"
        case "г": return "гґ"
        case "і": return "іїи"
        default: return super.calloutActionString(for: char)
        }
    }
}

