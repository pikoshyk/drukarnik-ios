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
    @StateObject var viewModel: DKTabsViewModel
    @State var selectedTab: DKTabs = .settings
    
    var body: some View {
        NavigationView {
            self.tabsView
                .navigationTitle(self.selectedTab.fullTitle)
        }
    }
    
    var tabsView: some View {
        TabView(selection: self.$selectedTab) {
            DKSettingsView(viewModel: self.viewModel.viewModelSettings)
                .tabItem {
                    Image(systemName: SystemImage.keyboardIcon)
                    Text(DKLocalizationApp.settingsTitle)
                }
                .tag(DKTabs.settings)
            DKConverterView(viewModel: self.viewModel.viewModelConverter)
                .tabItem {
                    Image(systemName: SystemImage.educationIcon)
                    Text(DKLocalizationApp.converterTitle)
                }
                .tag(DKTabs.converter)
            DKAboutView(viewModel: self.viewModel.viewModelAbout)
                .tabItem {
                    Image(systemName: SystemImage.informationIcon)
                    Text(DKLocalizationApp.aboutTitle)
                }
                .tag(DKTabs.about)
        }
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
