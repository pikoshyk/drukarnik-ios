//
//  DKCalloutActionProvider.swift
//  Keyboard
//
//  Created by Logout on 20.12.22.
//

import KeyboardKit

class DKCalloutActionProvider: KeyboardKit.BaseCalloutActionProvider {
    
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


