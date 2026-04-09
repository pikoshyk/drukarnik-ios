//
//  DKWordModel+DictionaryType.swift
//  Drukarnik
//
//  Created by Logout on 6.05.24.
//

import Foundation

extension DKWordModel {
    var dictionaryName: String? {
        switch self.dictionaryType {
        case .rus: String("рус")
        case .bel: String("бел")
        case .unknown: nil
        }
    }
}
