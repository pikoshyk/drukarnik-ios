//
//  DKAdditionalLanguage+Localization.swift
//  Drukarnik
//
//  Created by Logout on 24.01.23.
//

import Foundation
import BelarusianLacinka

extension DKAdditionalLanguage {
    var localizedName: String {
        DKLocalizationApp.processedWord(self.name)
    }
    
    var charsListStr: String {
        var chars = self.chars.compactMap{ $1.joined() }.joined()
        var set = Set<Character>()
        chars = chars.filter{ set.insert($0).inserted }
        chars = String(chars.sorted())
        if chars.count > 0 {
            chars = chars.compactMap { String($0) }.joined(separator: ", ")
        }

        return chars
    }
}
