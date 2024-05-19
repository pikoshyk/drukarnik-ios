//
//  DKDictionaryWordViewModel.swift
//  Drukarnik
//
//  Created by Logout on 20.05.24.
//

import GRDB
import Foundation
import Combine

class DKDictionaryWordViewModel: ObservableObject {
    @Published private var word: any DKWordModel
    private unowned var db: DatabaseQueue
    @Published @MainActor private(set) var translationContent: [DKWordTranslation] = []
    
    init(word: any DKWordModel, db: DatabaseQueue) {
        self.word = word
        self.db = db
    }
    
    func onAppear() {
        Task {
            let translationContent = await self.word.translationContent(self.db)
            await MainActor.run {
                self.translationContent = translationContent
            }
        }
    }
    
    var presentNavigationTitle: String {
        self.word.word
    }
    
    var presentWordDescription: String = ""
}
