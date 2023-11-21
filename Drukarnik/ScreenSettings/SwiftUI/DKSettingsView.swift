//
//  DKSettingsView.swift
//  Drukarnik
//
//  Created by Logout on 21.11.23.
//

import SwiftUI

struct DKSettingsView: View {
    
    @State var viewModel: DKSettingsViewModel
    
    var body: some View {
        List {
            self.cellLettersCyrillic
            self.cellLettersLatin
            self.cellAutocapitalization
            self.cellKeyboardFeedback
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
}

#Preview {
    NavigationView {
        DKSettingsView(viewModel: DKSettingsViewModel())
    }
}
