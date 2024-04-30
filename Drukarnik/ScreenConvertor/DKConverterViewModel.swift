//
//  DKConverterViewModel.swift
//  Drukarnik
//
//  Created by Logout on 30.04.24.
//

import BelarusianLacinka
import Foundation
import Combine
import SwiftUI

class DKConverterViewModel: ObservableObject {
    private var disableAutoChanges: Bool = false
    
    @Published var textCyrillic: String = "" {
        didSet {
            self.cyrillicToLatin()
            self.latinToCyrillic()
        }
    }
    
    @Published var textLatin: String = "" {
        didSet {
            self.latinToCyrillic()
            self.cyrillicToLatin()
        }
    }
    
    @Published var converterVersion: BelarusianLacinka.BLVersion = .traditional {
        didSet {
            self.cyrillicToLatin()
            self.latinToCyrillic()
        }
    }
    
    @Published var converterOrthography: BelarusianLacinka.BLOrthography = .academic {
        didSet {
            self.latinToCyrillic()
            self.cyrillicToLatin()
        }
    }
    
    private func latinToCyrillic() {
        if self.disableAutoChanges {
            return
        }
        self.disableAutoChanges = true
        self.textCyrillic = DKKeyboardSettings.shared.lacinkaConverter.convert(text: self.textLatin, direction: .toCyrillic, version: self.converterVersion, orthograpy: self.converterOrthography)
        self.disableAutoChanges = false
    }
    
    private func cyrillicToLatin() {
        if self.disableAutoChanges {
            return
        }
        self.disableAutoChanges = true
        self.textLatin = DKKeyboardSettings.shared.lacinkaConverter.convert(text: self.textCyrillic, direction: .toLacin, version: self.converterVersion, orthograpy: self.converterOrthography)
        self.disableAutoChanges = false
    }
}
