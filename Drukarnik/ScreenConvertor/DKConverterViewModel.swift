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
import UIKit

class DKConverterViewModel: ObservableObject {
    private var disableAutoChanges: Bool = false
    private var listeners: [NSObjectProtocol] = []
    
    @Published var textCyrillic: String = "" {
        didSet {
            self.cyrillicToLatin()
        }
    }
    
    @Published var textLatin: String = "" {
        didSet {
            self.latinToCyrillic()
        }
    }
    
    @Published var converterVersion: BelarusianLacinka.BLVersion {
        didSet {
            DKKeyboardSettings.shared.converterVersion = self.converterVersion
            self.cyrillicToLatin()
        }
    }
    
    @Published var converterOrthography: BelarusianLacinka.BLOrthography {
        didSet {
            DKKeyboardSettings.shared.converterOrthography = self.converterOrthography
            self.latinToCyrillic()
        }
    }
    
    init() {
        self.converterVersion = DKKeyboardSettings.shared.converterVersion
        self.converterOrthography = DKKeyboardSettings.shared.converterOrthography
        self.subscribeListeners()
    }
    
    deinit {
        self.unsubscribeListeners()
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
    
    func onDrag() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension DKConverterViewModel {
    func subscribeListeners() {
        self.unsubscribeListeners()
        self.listeners.append(NotificationCenter.default.addObserver(forName: .interfaceChanged, object: nil, queue: .main) { notification in
            self.objectWillChange.send()
        })
    }
    
    func unsubscribeListeners() {
        for listener in self.listeners {
            NotificationCenter.default.removeObserver(listener)
        }
    }
}
