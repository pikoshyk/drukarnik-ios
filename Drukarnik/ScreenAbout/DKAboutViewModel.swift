//
//  DKAboutViewModel.swift
//  Drukarnik
//
//  Created by Logout on 27.04.24.
//

import Foundation
import Combine

class DKAboutViewModel: ObservableObject {
    var presentNavigationTitle: String {
        DKLocalizationApp.aboutTitle
    }
    
    var presentAppDescription: String {
        DKLocalizationApp.aboutDescription
    }
    
    private var listeners: [NSObjectProtocol] = []

    init() {
        self.subscribeListeners()
    }
    
    deinit {
        self.unsubscribeListeners()
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
