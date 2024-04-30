//
//  View+NavigationBackButton.swift
//  Drukarnik
//
//  Created by Logout on 30.04.24.
//

import SwiftUI
import Foundation

extension View {
    
    func navigationTitle(_ title: String, backButton: String) -> some View {
        return self.modifier(DKCustomNavigationTitle(navigationTitle: title, backButton: backButton))
    }
}

struct DKCustomNavigationTitle: ViewModifier {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var navigationTitle: String
    var backButton: String
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationTitle(self.navigationTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: SystemImage.backIcon)
                            Text(backButton)
                        }
                    }
                }
            }
    }
}

extension DKCustomNavigationTitle {
    struct SystemImage {
        static let backIcon = "chevron.backward"
    }
}
