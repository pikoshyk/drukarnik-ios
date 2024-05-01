//
//  DKDictionaryView.swift
//  Drukarnik
//
//  Created by Logout on 1.05.24.
//

import SwiftUI

struct DKDictionaryView: View {
    @StateObject var viewModel: DKDictionaryViewModel
    var body: some View {
        self.contentView
            .background(Color.secondarySystemBackground)
    }
    
    var contentView: some View {
        VStack(spacing: 0) {
            self.searchView
            List {
               EmptyView()
            }
            Divider()
        }
    }
    
    var searchView: some View {
        TextField("Увядзіце слова для пошуку", text: self.$viewModel.presentSearchText)
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)

    }
}

#Preview {
    NavigationView {
        DKDictionaryView(viewModel: DKDictionaryViewModel())
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(DKLocalizationApp.dictionaryTitleFull)
    }
}
