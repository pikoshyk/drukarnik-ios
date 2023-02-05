//
//  DKBeCyrillicCalloutActionProvider.swift
//  Keyboard
//
//  Created by Logout on 5.12.22.
//

import KeyboardKit

class DKCyrillicCalloutActionProvider: DKCalloutActionProvider, KeyboardKit.LocalizedService {
    
    public let localeKey: String = DKKeyboardLayout.cyrillic.localeIdentifier
    
    open override func calloutActionString(for char: String) -> String {
        var symbols: String = char
        
        let belarusian = true


        if belarusian {
            let cyrillicType = DKKeyboardSettings.shared.belarusianCyrillicType
            if cyrillicType == .classic {
                switch char {
                case "г": symbols = self.appendUnknownSymbols(base: symbols, new: "гґ")
                default: break
                }
            }
        }

        let extendedChars = DKKeyboardSettings.shared.supportedAdditionalLanguages.compactMap{ $0.layout == .cyrillic ? $0.extendedChars(baseChar:char) : nil }.joined()
        
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

