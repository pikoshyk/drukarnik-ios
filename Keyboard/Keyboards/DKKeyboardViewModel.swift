import BelarusianLacinka
import KeyboardKit
import Foundation
import Combine

class DKKeyboardViewModel: ObservableObject {
    private(set) var state: Keyboard.State
    private(set) var keyboardSettings: DKKeyboardSettings

    private var _emojiViewModel: DKKeyboardEmojiViewModel?
    private var emojiRecents: [DKKeyboardEmojiRecentsItem] = []

    @Published private(set) var overlayHasLetters = false

    init(keyboardSettings: DKKeyboardSettings, state: Keyboard.State) {
        self.state = state
        self.keyboardSettings = keyboardSettings
    }

    var emojiViewModel: DKKeyboardEmojiViewModel {
        if let viewModel = self._emojiViewModel {
            return viewModel
        }
        let viewModel = DKKeyboardEmojiViewModel()
        self._emojiViewModel = viewModel
        return viewModel
    }

    var hasAutosuggestions: Bool {
        self.state.autocompleteContext.suggestions.count > 0
    }

    var autosuggestions: [Autocomplete.Suggestion] {
        self.state.autocompleteContext.suggestions
    }

    func refreshOverlayTextAvailability() {
        let fullText = self.state.keyboardContext.originalTextDocumentProxy.documentContext ?? ""
        self.overlayHasLetters = fullText.unicodeScalars.contains { CharacterSet.letters.contains($0) }
    }

    func convertText(direction initialDirection: BelarusianLacinka.BLDirection? = nil) {
        let settings = self.keyboardSettings
        let direction = initialDirection ?? (settings.keyboardLayout == .latin ? .toCyrillic : .toLacin)
        let version = settings.belarusianLatinType
        let orthograpy = settings.belarusianCyrillicType

        self.state.keyboardContext.convertAndReplaceFullText(converter: settings.lacinkaConverter, direction: direction, version: version, orthography: orthograpy)
        self.refreshOverlayTextAvailability()
    }

    private func reloadEmoji() {
        self.emojiRecents = self.keyboardSettings.keyboardEmojiRecents
        self.emojiViewModel.reloadData()
    }
}


extension DKKeyboardViewModel {

    func onAlphabeticalKeyboard() {
        self.state.keyboardContext.keyboardType = .alphabetic(.auto)
        self.reloadEmoji()
    }

    func onEmojiAppear() {
        self.emojiRecents = self.keyboardSettings.keyboardEmojiRecents
        self.reloadEmoji()
    }

    func onEmojiDisappear() {
    }

    func onEmoji(_ emoji: String) {
        autoreleasepool {
            self.state.keyboardContext.textDocumentProxy.insertText(emoji)
            if let emojiItem = self.emojiRecents.filter({  $0.emoji == emoji }).first {
                emojiItem.usage.insert(Date(), at: 0)
                if emojiItem.usage.count > 10 {
                    emojiItem.usage.removeLast()
                }
            } else {
                let item = DKKeyboardEmojiRecentsItem(emoji: emoji)
                self.emojiRecents.insert(item, at: 0)
            }

            self.emojiRecents.sort { item1, item2 in
                item1.usage.first! > item2.usage.first!
            }

            if self.emojiRecents.count > 30 {
                self.emojiRecents.removeLast()
            }

            self.keyboardSettings.keyboardEmojiRecents = self.emojiRecents
        }
    }

    func onEmojiDelete() {
        self.state.keyboardContext.textDocumentProxy.deleteBackward(times: 1)
    }

    func onEmojiRecents() -> [String] {
        return self.emojiRecents.compactMap { $0.emoji }
    }
}
