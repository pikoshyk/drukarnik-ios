//
//  DKTabsView.swift
//  Drukarnik
//
//  Created by Logout on 1.05.24.
//

import SwiftUI

enum DKTabs {
    case settings
    case converter
    case about
    
    var shortTitle: String {
        switch self {
        case .settings:
            DKLocalizationApp.settingsTitle
        case .converter:
            DKLocalizationApp.converterTitle
        case .about:
            DKLocalizationApp.aboutTitle
        }
    }
    
    var fullTitle: String {
        switch self {
        case .settings:
            DKLocalizationApp.settingsTitleFull
        case .converter:
            DKLocalizationApp.converterTitleFull
        case .about:
            DKLocalizationApp.aboutTitle
        }
    }
}

struct DKTabsView: View {
    @ObservedObject var viewModel: DKTabsViewModel
    @State var selectedTab: DKTabs = .settings
    
    var body: some View {
        self.tabsView
            .sheet(isPresented: self.$viewModel.isTransliterationChoicePresented, onDismiss: {
                self.viewModel.handleTransliterationChoiceSheetDismissed()
            }) {
                if let choiceViewModel = self.viewModel.transliterationChoiceViewModel {
                    DKTransliterationChoiceView(viewModel: choiceViewModel)
                }
            }
    }
    
    var tabsView: some View {
        TabView(selection: self.$selectedTab) {
            self.tab(DKTabs.settings) {
                DKSettingsView(viewModel: self.viewModel.viewModelSettings)
            } tabItem: {
                Image(systemName: SystemImage.keyboardIcon)
                Text(DKLocalizationApp.settingsTitle)
            }
            self.tab(DKTabs.converter) {
                DKConverterView(viewModel: self.viewModel.viewModelConverter)
            } tabItem: {
                Image(systemName: SystemImage.educationIcon)
                Text(DKLocalizationApp.converterTitle)
            }
            self.tab(DKTabs.about) {
                DKAboutView(viewModel: self.viewModel.viewModelAbout)
            } tabItem: {
                Image(systemName: SystemImage.informationIcon)
                Text(DKLocalizationApp.aboutTitle)
            }
        }
        .background(Color.secondarySystemBackground)
    }

    func tab<Content: View>(
        _ tab: DKTabs,
        @ViewBuilder content: () -> Content,
        @ViewBuilder tabItem: () -> some View
    ) -> some View {
        NavigationStack {
            content()
                .navigationTitle(tab.fullTitle)
        }
        .tabItem(tabItem)
        .tag(tab)
    }
}

extension DKTabsView {
    struct SystemImage {
        static let keyboardIcon = "keyboard.fill"
        static let educationIcon = "graduationcap.fill"
        static let informationIcon = "info.circle.fill"
    }
}

#Preview {
    DKTabsView(viewModel: DKTabsViewModel())
}
