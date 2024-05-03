//
//  DKDictionaryViewModel.swift
//  Drukarnik
//
//  Created by Logout on 1.05.24.
//

import UIKit
import Foundation
import Combine

class DKDictionaryViewModel: ObservableObject {
    private lazy var databaseModel = DKDictionaryDatabaseModel()
    @Published var presentSearchText: String = ""
    
    @Published var words: [any DKWordModel] = []
    
    private var subscriptions: Set<AnyCancellable> = []

    init() {
        self.presentSearchText = presentSearchText
        self.subscribeListeners()
    }
    
    deinit {
        self.unscribscribeListeners()
    }
    
    private func subscribeListeners() {
        self.$presentSearchText
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.onSearch(text)
            }.store(in: &self.subscriptions)
    }
    
    private func unscribscribeListeners() {
        self.subscriptions = []
    }

    private func onSearch(_ text: String) {
        Task(priority: .background) {
            let words = await self.databaseModel.find(text: text)
            await MainActor.run {
                self.words = words
            }
        }
    }
    
    func onDrag() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

}
