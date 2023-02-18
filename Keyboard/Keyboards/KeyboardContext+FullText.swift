//
//  KeyboardContext+FullText.swift
//  Keyboard
//
//  Created by Logout on 12.02.23.
//

import BelarusianLacinka
import KeyboardKit
import Foundation

extension KeyboardContext {
    
    func convertAndReplaceFullText(converter: BelarusianLacinka.BLConverter,
                                   direction: BelarusianLacinka.BLDirection,
                                   version: BelarusianLacinka.BLVersion,
                                   orthography: BelarusianLacinka.BLOrthography) {
        DispatchQueue.main.async {
            if let fullText = self.originalTextDocumentProxy.fullText {
                let newText = converter.convert(text: fullText,
                                                direction: direction,
                                                version: version,
                                                orthograpy: orthography)
                
                let offset = (self.originalTextDocumentProxy.documentContextAfterInput ?? "").count
                self.textDocumentProxy.adjustTextPosition(byCharacterOffset: offset)
                self.textDocumentProxy.replaceFullText(with: newText)
            }
        }

    }
}
