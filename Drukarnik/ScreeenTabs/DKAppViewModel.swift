//
//  DKAppViewModel.swift
//  Drukarnik
//

import Combine
import Foundation

class DKAppViewModel: ObservableObject {
    let tabsViewModel = DKTabsViewModel()

    @Published var showsInstallation = false
    @Published var isTransliterationChoicePresented = false
    @Published var transliterationChoiceViewModel: DKTransliterationChoiceViewModel?

    private var transliterationChoiceCompletion: ((DKKeyboardLayout) -> Void)?

    init() {
        self.refreshInstallationVisibility()
    }

    func refreshInstallationVisibility() {
        let needsInstallation = DKKeyboardSettings.isKeyboardActivated() == false
            && DKKeyboardSettings.shared.keyboardInstallationCompleted == false
        self.showsInstallation = needsInstallation
    }

    func handleKeyboardActivated() {
        self.showsInstallation = false
    }
}

extension DKAppViewModel {
    func requestTransliterationChoice(completion: @escaping (DKKeyboardLayout) -> Void) {
        guard self.isTransliterationChoicePresented == false else {
            return
        }
        self.transliterationChoiceCompletion = completion
        self.transliterationChoiceViewModel = DKTransliterationChoiceViewModel { [weak self] layout in
            self?.finishTransliterationChoice(layout)
        }
        self.isTransliterationChoicePresented = true
    }

    func finishTransliterationChoice(_ layout: DKKeyboardLayout) {
        self.transliterationChoiceCompletion?(layout)
        self.transliterationChoiceCompletion = nil
        self.isTransliterationChoicePresented = false
    }

    func handleTransliterationChoiceSheetDismissed() {
        let needsChoice = self.transliterationChoiceCompletion != nil
        self.transliterationChoiceViewModel = nil
        guard needsChoice else {
            return
        }
        self.transliterationChoiceViewModel = DKTransliterationChoiceViewModel { [weak self] layout in
            self?.finishTransliterationChoice(layout)
        }
        DispatchQueue.main.async {
            self.isTransliterationChoicePresented = true
        }
    }
}
