//
//  DKTabsView.swift
//  Drukarnik
//
//  Created by Logout on 1.05.24.
//

import SwiftUI

struct DKTabsView: View {
    @StateObject var viewModel: DKTabsViewModel
    @State var selectedTab: DKTabType = .dictionary
    
    var body: some View {
        NavigationView {
            self.tabsView
                .navigationTitle(self.selectedTab.fullTitle)
        }
    }
    
    var tabsView: some View {
        TabView(selection: self.$selectedTab) {
            self.tabView(.dictionary) {
                DKDictionaryView(viewModel: self.viewModel.viewModelDictionary)
            }
            self.tabView(.converter) {
                DKConverterView(viewModel: self.viewModel.viewModelConverter)
            }
            self.tabView(.settings) {
                DKSettingsView(viewModel: self.viewModel.viewModelSettings)
            }
            self.tabView(.about) {
                DKAboutView(viewModel: self.viewModel.viewModelAbout)
            }
        }
    }
    
    @ViewBuilder
    func tabView(_ type: DKTabType, content: () -> some View) -> some View {
        content()
            .tabItem {
                Image(systemName: type.systemImage)
                Text(type.shortTitle)
            }
            .tag(type)
    }
}

#Preview {
    DKTabsView(viewModel: DKTabsViewModel())
}
