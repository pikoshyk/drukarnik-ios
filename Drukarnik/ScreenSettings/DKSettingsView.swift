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
        NavigationView {
            self.settingsList
        }
    }

    var settingsList: some View {
        List {
            Section {
                self.cellLettersCyrillic
                self.cellLettersLatin
                self.cellNavigationOtherLanguages
#warning("TODO: Fix Autocapitalization")
//                self.cellAutocapitalization
#warning("TODO: Fix KeyboardFeedback")
//                self.cellKeyboardFeedback
            }
            Section {
                self.cellInterfaceTransliteration
            }
        }
        .listStyle(.insetGrouped)
        .background(Color.secondarySystemBackground)
        .navigationTitle(self.viewModel.presentNavigationTitle)
    }
#warning("TODO: Fix 'back' button for 'Keyboard Settings' navigation title")

    var cellLettersCyrillic: some View {
        DKSettingsCellView(title: self.viewModel.presentCyrillicTypeCellTitle, availableOptions: self.viewModel.presentCyrillicTypeAvailableOptions, selectedOption: self.viewModel.presentCyrillicTypeCurrent) { cyrillicType in
            self.viewModel.presentCyrillicTypeCurrent = cyrillicType
        }
    }
    
    var cellLettersLatin: some View {
        DKSettingsCellView(title: self.viewModel.presentLatinTypeCellTitle, availableOptions: self.viewModel.presentLatinTypeAvailableOptions, selectedOption: self.viewModel.presentLatinTypeCurrent) { latinType in
            self.viewModel.presentLatinTypeCurrent = latinType
        }
    }
    
    var cellAutocapitalization: some View {
        DKSettingsCellView(title: self.viewModel.presentAutocapitalizationCellTitle, availableOptions: self.viewModel.presentAutocapitalizationAvailableOptions, selectedOption: self.viewModel.presentAutocapitalizationCurrent) { latinType in
            self.viewModel.presentAutocapitalizationCurrent = latinType
        }
    }
    
    var cellKeyboardFeedback: some View {
        DKSettingsCellView(title: self.viewModel.presentKeyboardFeedbackCellTitle, availableOptions: self.viewModel.presentKeyboardFeedbackAvailableOptions, selectedOption: self.viewModel.presentKeyboardFeedbackCurrent) { feedbackType in
            self.viewModel.presentKeyboardFeedbackCurrent = feedbackType
        }
    }
    
    var cellInterfaceTransliteration: some View {
        VStack(alignment: .leading) {
            Text(self.viewModel.presentInterfaceTransliterationCellTitle)
                .font(.headline)
            HStack {
                Picker("", selection: self.$viewModel.presentInterfaceTransliteration) {
                    ForEach(self.viewModel.presentInterfaceTransliterationOptions, id: \.value) { option in
                        Text(option.title).tag(option.value)
                    }
                }
                .pickerStyle(.segmented)
                .frame(minWidth: 0, maxWidth: 400)
                Spacer(minLength: 0)
            }
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
                Text(self.viewModel.presentOtherLanguagesCellTitle)
                    .font(.headline)
                Text(self.viewModel.presentOtherLanguagesCellDescription)
                    .font(.subheadline)
            }
            Spacer()
            Image(systemName: SystemImage.accessoryDisclosureIcon)
                .font(.body)
                .foregroundColor(.secondary)

        }
    }
}

import UIKit
extension DKSettingsView {
    
    struct SystemImage {
        static let accessoryDisclosureIcon = "chevron.right"
    }
}

#Preview {
    DKSettingsView(viewModel: DKSettingsViewModel())
}
