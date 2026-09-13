//
//  DKTabsViewModel.swift
//  Drukarnik
//
//  Created by Logout on 1.05.24.
//

import Combine
import Foundation

class DKTabsViewModel: ObservableObject {
    private var listeners: [NSObjectProtocol] = []
    private var transliterationChoiceCompletion: ((DKKeyboardLayout) -> Void)?

    @Published var isTransliterationChoicePresented = false
    @Published var transliterationChoiceViewModel: DKTransliterationChoiceViewModel?

    lazy private(set) var viewModelSettings = DKSettingsViewModel()
    lazy private(set) var viewModelConverter = DKConverterViewModel()
    lazy private(set) var viewModelAbout = DKAboutViewModel()
    
    
    init() {
        self.subscribeListeners()
    }
    
    deinit {
        self.unsubscribeListeners()
    }
}

extension DKTabsViewModel {
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
        self.clearTransliterationChoiceViewModel()
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

    func clearTransliterationChoiceViewModel() {
        self.transliterationChoiceViewModel = nil
    }

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
