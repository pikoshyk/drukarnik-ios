//
//  DKDictionaryWordView.swift
//  Drukarnik
//
//  Created by Logout on 20.05.24.
//

import Foundation
import SwiftUI

struct DKDictionaryWordTranslationView: View {
    @State var title: String
    @State var descriptionHtml: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(self.title)
                .font(.headline)
            if let descriptionHtml = self.descriptionHtml {
                Text(descriptionHtml)
                    .font(.body)
            }
        }
    }
}

struct DKDictionaryWordView: View {
    
    @ObservedObject var viewModel: DKDictionaryWordViewModel
    
    var body: some View {
        List {
            ForEach(self.viewModel.translationContent, id: \.word.id) { translation in
                DKDictionaryWordTranslationView(title: translation.word.word, descriptionHtml: translation.content?.html)
            }
        }
        .onAppear {
            self.viewModel.onAppear()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(self.viewModel.presentNavigationTitle)
    }
}
