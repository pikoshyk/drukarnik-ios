//
//  DKSettingsLanguagesView.swift
//  Drukarnik
//
//  Created by Logout on 23.11.23.
//

import SwiftUI

struct DKSettingsLanguagesView: View {
    
    @StateObject var viewModel: DKSettingsLanguagesViewModel
    
    var body: some View {
        List {
            ForEach(self.viewModel.cellSections) { section in
                self.listSection(section)
            }
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(self.viewModel.navigationTitle, backButton: "")
    }
    
    @ViewBuilder
    func listSection(_ section: DKSettingsLanguagesViewModel.LanguageSection) -> some View {
        Section {
            ForEach(section.cells) { cell in
                Button {
                    self.viewModel.toogleLanguage(cell.language)
                } label: {
                    self.cellLanguage(cell)
                }
            }
        } header: {
            if let title = section.title {
                Text(title)
            }
        }
    }
    
    @ViewBuilder
    func cellLanguage(_ language: DKSettingsLanguagesViewModel.LanguageCell) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(language.language.localizedName)
                    .font(.body)
                Text(language.language.charsListStr)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if language.selected {
                Image(systemName: "checkmark")
                    .foregroundColor(.accentColor)
            }
        }
    }
}

#Preview {
    NavigationView(content: {
        DKSettingsLanguagesView(viewModel: DKSettingsLanguagesViewModel())
    })
}
