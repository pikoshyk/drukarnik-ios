//
//  DKSettingsView.swift
//  Drukarnik
//
//  Created by Logout on 21.11.23.
//

import SwiftUI

struct DKSettingsView: View {
    
    @StateObject var viewModel: DKSettingsViewModel
    
    var body: some View {
        List {
            Section {
                self.cellInterfaceTransliteration
            }
            Section {
                self.cellLettersCyrillic
                self.cellLettersLatin
                self.cellNavigationOtherLanguages
                self.cellAutocapitalization
                self.cellKeyboardFeedback
            }
        }
        .listStyle(.plain)
        .navigationTitle(self.viewModel.navigationTitle)
    }
    
    var cellLettersCyrillic: some View {
        DKSettingsCellView(title: self.viewModel.cyrillicTypeCellTitle, availableOptions: self.viewModel.cyrillicTypeAvailableOptions, selectedOption: self.viewModel.cyrillicTypeCurrent) { cyrillicType in
            self.viewModel.cyrillicTypeCurrent = cyrillicType
        }
    }
    
    var cellLettersLatin: some View {
        DKSettingsCellView(title: self.viewModel.latinTypeCellTitle, availableOptions: self.viewModel.latinTypeAvailableOptions, selectedOption: self.viewModel.latinTypeCurrent) { latinType in
            self.viewModel.latinTypeCurrent = latinType
        }
    }
    
    var cellAutocapitalization: some View {
        DKSettingsCellView(title: self.viewModel.autocapitalizationCellTitle, availableOptions: self.viewModel.autocapitalizationAvailableOptions, selectedOption: self.viewModel.autocapitalizationCurrent) { latinType in
            self.viewModel.autocapitalizationCurrent = latinType
        }
    }
    
    var cellKeyboardFeedback: some View {
        DKSettingsCellView(title: self.viewModel.keyboardFeedbackCellTitle, availableOptions: self.viewModel.keyboardFeedbackAvailableOptions, selectedOption: self.viewModel.keyboardFeedbackCurrent) { latinType in
            self.viewModel.keyboardFeedbackCurrent = latinType
        }
    }
    
    var cellInterfaceTransliteration: some View {
        VStack(alignment: .leading) {
            Text(self.viewModel.interfaceTransliterationCellTitle)
                .font(.headline)
            Picker("", selection: self.$viewModel.interfaceTransliteration) {
                ForEach(self.viewModel.interfaceTransliterationOptions, id: \.value) { option in
                    Text(option.title).tag(option.value)
                }
            }
            .pickerStyle(.segmented)
        }
    }
    
    var cellNavigationOtherLanguages: some View {
        ZStack {
            self.cellOtherLanguages
            NavigationLink {
                DKSettingsLanguagesView(viewModel: self.viewModel.otherLanguagesViewModel)
            } label: {
                EmptyView()
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    var cellOtherLanguages: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(self.viewModel.otherLanguagesCellTitle)
                    .font(.headline)
                Text(self.viewModel.otherLanguagesCellDescription)
                    .font(.subheadline)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.body)
                .foregroundColor(.secondary)

        }
    }
}

#Preview {
    NavigationView {
        DKSettingsView(viewModel: DKSettingsViewModel())
    }
}
