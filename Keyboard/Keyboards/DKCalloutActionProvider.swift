//
//  DKCalloutActionProvider.swift
//  Keyboard
//
//  Created by Logout on 20.12.22.
//

import KeyboardKit

class DKCalloutActionProvider: KeyboardKit.Callouts.BaseActionProvider {
    
    weak var settings: DKKeyboardSettings?
    
    init(settings: DKKeyboardSettings) throws {
        super.init()
        self.settings = settings
    }

    open override func calloutActions(for char: String) -> [KeyboardAction] {
        let charValue = char.lowercased()
        let result = calloutActionString(for: charValue)
        let string = char.isUppercasedWithLowercaseVariant
            ? DKCalloutStringCasing.uppercased(result)
            : result
        return string.map { .character(String($0)) }
    }
    
    open override func calloutActionString(for char: String) -> String {
        switch char {
        case ".": return ".,?!-…"
        case "$": return "$€£¥₩₽₿¢"
        case "-": return "-–—•"
        case "/": return "/\\"
        case "&": return "&§"
        case "\"": return "\"”“„»«"
        case "?": return "?¿"
        case "!": return "!¡"
        case "'": return "'’`"
        case "%": return "%‰"
        case "=": return "=≠≈"
        default: return ""
        }
    }
}


