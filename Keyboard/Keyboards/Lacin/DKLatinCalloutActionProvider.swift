//
//  DKBeCyrillicCalloutActionProvider.swift
//  Keyboard
//
//  Created by Logout on 5.12.22.
//

import KeyboardKit

class DKLatinCalloutActionProvider: DKCalloutActionProvider, KeyboardKit.LocalizedService {
    
    public let localeKey: String = DKKeyboardLayout.latin.localeIdentifier
    
    open override func calloutActionString(for char: String) -> String {
        var symbols: String = char
        
        let belarusian = true

        if belarusian {
            let latinType = DKKeyboardSettings.shared.belarusianLatinType
            switch char {
            case "l": symbols = self.appendUnknownSymbols(base: symbols, new: (latinType == .traditional) ? "lł" : "lĺ")
            case "n": symbols = self.appendUnknownSymbols(base: symbols, new: "nń")
            case "z": symbols = self.appendUnknownSymbols(base: symbols, new: "zźž")
            case "c": symbols = self.appendUnknownSymbols(base: symbols, new: "cćč")
            case "s": symbols = self.appendUnknownSymbols(base: symbols, new: "sśš")
            case "u": symbols = self.appendUnknownSymbols(base: symbols, new: "uŭ")
            default: break
            }
        }
        
        let extendedChars = DKKeyboardSettings.shared.supportedAdditionalLanguages.compactMap{ $0.layout == .latin ? $0.extendedChars(baseChar:char) : nil }.joined()
        
        symbols = self.appendUnknownSymbols(base: symbols, new: extendedChars)

        if symbols.count == 1 { return super.calloutActionString(for: char) }
        
        return symbols
    }
    
    func appendUnknownSymbols(base: String, new: String) -> String {
        var result = base
        for char in new {
            if result.contains(char) == false {
                result.append(char)
            }
        }
        return result
    }
}

// чэшская: čďňřšťžáéíóúýůě
// польская: żśóąłńćźę
// літоўская: ąčęėįšųūž
// латышская: āčēģīķļņšūž
