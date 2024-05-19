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
//            .background(Color.secondarySystemBackground)
    }
    
    var contentView: some View {
        VStack(spacing: 0) {
            self.listView
            Spacer(minLength: 0)
            Divider()
            self.searchView
        }
    }
    
    var searchView: some View {
        Group {
            GeometryReader(content: { geometry in
                ZStack {
                    TextField("Увядзіце слова для пошуку", text: self.$viewModel.presentSearchText)
                        .textFieldStyle(.plain)
                        .padding()
                        .zIndex(2)
                    RoundedRectangle(cornerRadius: geometry.size.height/2.0)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1))
                        .foregroundColor(.secondary.opacity(0.3))
                        .zIndex(1)
                }
            })
        }
        .frame(height: 50.0)
        .padding()
        .background(Color.systemBackground)
    }
    
    var listView: some View {
        List {
            ForEach(self.viewModel.words, id: \.id) { wordModel in
                NavigationLink {
                    DKDictionaryWordView(viewModel: self.viewModel.wordViewModel(wordModel))
                } label: {
                    DKDictionaryWordRowView(viewModel: wordModel)
                }
            }
        }
        .listStyle(.plain)
        .gesture(DragGesture().onChanged { _ in
            self.viewModel.onDrag()
        })
    }
}

#Preview {
    NavigationView {
        DKDictionaryView(viewModel: DKDictionaryViewModel())
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(DKLocalizationApp.dictionaryTitleFull)
    }
}
