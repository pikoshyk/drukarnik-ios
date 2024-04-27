//
//  DKAboutView.swift
//  Drukarnik
//
//  Created by Logout on 27.04.24.
//

import SwiftUI

struct DKAboutView: View {
    
    @StateObject var viewModel: DKAboutViewModel
    
    var body: some View {
        NavigationView {
            self.content
                .background(Color.secondarySystemBackground)
                .navigationTitle(self.viewModel.presentNavigationTitle)
        }
    }
    
    var content: some View {
        List {
            Section {
                self.descriptionView
            }
        }
        .listStyle(.insetGrouped)
        
    }
    
    var descriptionView: some View {
        Text(self.viewModel.presentAppDescription)
            .foregroundColor(.secondary)
            .font(.body)
    }
}

#Preview {
    DKAboutView(viewModel: DKAboutViewModel())
}
