//
//  DKKeyboardEmojiView.swift
//  Keyboard
//
//  Created by Logout on 24.11.23.
//

import UIKit
import SwiftUI

struct DKKeyboardEmojiView: UIViewRepresentable {
    let viewModel = DKKeyboardEmojiViewModel()

    typealias UIViewType = DKKeyboardEmojiStackView

    func makeUIView(context: Context) -> DKKeyboardEmojiStackView {
        return DKKeyboardEmojiStackView(self.viewModel)
    }
    
    func updateUIView(_ uiView: DKKeyboardEmojiStackView, context: Context) {
    }
}

