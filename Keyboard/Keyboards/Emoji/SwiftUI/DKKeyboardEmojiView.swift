//
//  DKKeyboardEmojiView.swift
//  Keyboard
//
//  Created by Logout on 24.11.23.
//

import UIKit
import SwiftUI

struct DKKeyboardEmojiView: UIViewRepresentable {
    let viewModel: DKKeyboardEmojiViewModel
    
    init(_ viewModel: DKKeyboardEmojiViewModel, onAlphabeticalKeyboard: @escaping () -> Void, onDelete: @escaping () -> Void, onEmoji: @escaping (String) -> Void, onRecents: @escaping () -> String) {
        self.viewModel = viewModel
        self.viewModel.onAlphabeticalKeyboardBlock = onAlphabeticalKeyboard
        self.viewModel.onDeleteBlock = onDelete
        self.viewModel.onEmojiBlock = onEmoji
        self.viewModel.onRecentsBlock = onRecents
    }

    typealias UIViewType = DKKeyboardEmojiStackView

    func makeUIView(context: Context) -> DKKeyboardEmojiStackView {
        return DKKeyboardEmojiStackView(self.viewModel)
    }
    
    func updateUIView(_ uiView: DKKeyboardEmojiStackView, context: Context) {
    }
}

