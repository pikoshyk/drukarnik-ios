//
//  DKAboutView.swift
//  Drukarnik
//
//  Created by Logout on 27.04.24.
//

import SwiftUI

struct DKAboutView: View {
    
    @ObservedObject var viewModel: DKAboutViewModel

    var body: some View {
        self.content
    }
    
    var content: some View {
        VStack(alignment: .leading, spacing: 20) {
            self.descriptionView
                .textCase(.none)
                .padding(.horizontal, 20)
            HStack(spacing: 0) {
                List {
                    Section {
                        self.twitterView
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.viewModel.onTwitter()
                            }
                        self.emailView
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.viewModel.onEmail()
                            }
                    } header: {
                        Text(DKLocalizationApp.aboutSectionContactsTitle)
                    } footer: {
                        EmptyView()
                    }
                }
                .listStyle(.insetGrouped)
                .frame(maxWidth: 500)
                Spacer(minLength: 0)
            }
        }
    }
    
    var twitterView: some View {
        HStack {
            self.twitterIconView
            VStack(alignment: .leading) {
                Text("@drukarnik")
                    .foregroundColor(.primary)
                    .font(.headline)
            }
            Spacer(minLength: 0)
            Image(systemName: SystemImage.accessoryDisclosureIcon)
                .foregroundColor(.secondary)
        }
    }
    
    var twitterIconView: some View {
        ZStack(alignment: .center) {
            Text(" 𝕏 ")
                .foregroundColor(Color.systemBackground)
                .font(.system(size: 17))
                .zIndex(2.0)
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.primary)
                .zIndex(1.0)
                .frame(width: 40, height: 40)
        }
        .frame(width: 40, height: 40)
    }
    
    var emailView: some View {
        HStack {
            self.emailIconView
            VStack(alignment: .leading) {
                Text("belanghelp"+"@"+"gmail.com")
                    .foregroundColor(.primary)
                    .font(.body)
            }
            Spacer(minLength: 0)
            Image(systemName: SystemImage.accessoryDisclosureIcon)
                .foregroundColor(.secondary)
        }
    }
    
    var emailIconView: some View {
        ZStack(alignment: .center) {
            Text(" @ ")
                .foregroundColor(.secondary)
                .font(.system(size: 17))
                .zIndex(2.0)
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(style: .init(lineWidth: 1))
                .foregroundColor(.secondary)
                .zIndex(1.0)
                .frame(width: 40, height: 40)
        }
        .frame(width: 40, height: 40)
    }
    
    var descriptionView: some View {
        Text(self.viewModel.presentAppDescription)
            .foregroundColor(.secondary)
            .font(.body)
    }
}

extension DKAboutView {
    struct SystemImage {
        static let accessoryDisclosureIcon = "chevron.right"
    }
}

#Preview {
    DKAboutView(viewModel: DKAboutViewModel())
}
