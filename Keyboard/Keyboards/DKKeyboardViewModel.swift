import BelarusianLacinka
import KeyboardKit
import Foundation
import Combine

class DKKeyboardViewModel: ObservableObject {
    private(set) var state: Keyboard.State
    private(set) var keyboardSettings: DKKeyboardSettings

    private var _emojiViewModel: DKKeyboardEmojiViewModel?
    private var emojiRecents: [DKKeyboardEmojiRecentsItem] = []
    private var cancellables = Set<AnyCancellable>()

    @Published private(set) var overlayHasLetters = false

    init(keyboardSettings: DKKeyboardSettings, state: Keyboard.State) {
        self.state = state
        self.keyboardSettings = keyboardSettings
        state.autocompleteContext.$suggestions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        state.keyboardContext.$keyboardType
            .receive(on: DispatchQueue.main)
            .sink { [weak self] keyboardType in
                guard let self, keyboardType == .emojis else { return }
                self.emojiRecents = self.keyboardSettings.keyboardEmojiRecents
                self.refreshEmojiRecentsForDisplay()
            }
            .store(in: &cancellables)
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

    private func refreshEmojiRecentsForDisplay() {
        self.emojiViewModel.reloadRecentSection()
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
            self.persistEmojiRecents(emoji: emoji)
        }
    }

    func recordRecentEmoji(_ emoji: String) {
        self.persistEmojiRecents(emoji: emoji)
    }

    func performAutocompleteSuggestion(
        _ suggestion: Autocomplete.Suggestion,
        autocompleteAction: (Autocomplete.Suggestion) -> Void
    ) {
        DKAutocompleteSuggestionAction.perform(
            suggestion: suggestion,
            autocompleteAction: autocompleteAction,
            recordRecentEmoji: { self.recordRecentEmoji($0) }
        )
    }

    private func persistEmojiRecents(emoji: String) {
        self.emojiRecents = DKKeyboardEmojiRecents.record(emoji: emoji, in: self.emojiRecents)
        self.keyboardSettings.keyboardEmojiRecents = self.emojiRecents
        self.refreshEmojiRecentsForDisplay()
    }

    func onEmojiDelete() {
        self.state.keyboardContext.textDocumentProxy.deleteBackward(times: 1)
    }

    func onEmojiRecents() -> [String] {
        return self.emojiRecents.compactMap { $0.emoji }
    }
}
