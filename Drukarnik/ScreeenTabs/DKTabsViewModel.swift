//
//  DKTabsViewModel.swift
//  Drukarnik
//
//  Created by Logout on 1.05.24.
//

import Foundation
import Combine

class DKTabsViewModel: ObservableObject {
    private var listeners: [NSObjectProtocol] = []

    lazy private(set) var viewModelDictionary = DKDictionaryViewModel()
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
