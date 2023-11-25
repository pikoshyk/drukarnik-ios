//
//  DKCalloutActionProvider.swift
//  Keyboard
//
//  Created by Logout on 20.12.22.
//

import KeyboardKit

class DKCalloutActionProvider: KeyboardKit.BaseCalloutActionProvider {
    
    weak var settings: DKKeyboardSettings?
    
    init(settings: DKKeyboardSettings) throws {
        super.init()
        self.settings = settings
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


