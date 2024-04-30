//
//  DKAboutViewModel.swift
//  Drukarnik
//
//  Created by Logout on 27.04.24.
//

import UIKit
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
    
    func onTwitter() {
        let url = URL(string: "https://twitter.com/drukarnik")!
        UIApplication.shared.open(url)
    }
    
    func onEmail() {
        let baseUrl = "mailto:belanghelp@gmail.com"
        var urlComponents = URLComponents(string: baseUrl)!
        var appVersion = ""
        let infoDictionaryKey = "CFBundleShortVersionString"
        if let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String {
            appVersion = "v\(currentVersion)"
        }

        let queryItem = URLQueryItem(name: "subject", value: "Drukarnik \(appVersion)")
        urlComponents.queryItems = [queryItem]
        let url = urlComponents.url ?? URL(string: baseUrl)!
        UIApplication.shared.open(url)
    }
}

extension DKAboutViewModel {
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
