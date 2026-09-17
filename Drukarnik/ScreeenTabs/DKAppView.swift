//
//  DKAppView.swift
//  Drukarnik
//

import SwiftUI

struct DKAppView: View {
    @ObservedObject var viewModel: DKAppViewModel

    var body: some View {
        self.content
            .sheet(isPresented: self.$viewModel.isTransliterationChoicePresented, onDismiss: {
                self.viewModel.handleTransliterationChoiceSheetDismissed()
            }) {
                if let choiceViewModel = self.viewModel.transliterationChoiceViewModel {
                    DKTransliterationChoiceView(viewModel: choiceViewModel)
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        if self.viewModel.showsInstallation {
            DKInstallationView {
                self.viewModel.handleKeyboardActivated()
            }
            .ignoresSafeArea()
        } else {
            DKTabsView(viewModel: self.viewModel.tabsViewModel)
        }
    }
}

#Preview {
    DKAppView(viewModel: DKAppViewModel())
}
