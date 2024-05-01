//
//  DKConverterView.swift
//  Drukarnik
//
//  Created by Logout on 30.04.24.
//

import BelarusianLacinka
import SwiftUI

struct DKConverterView: View {
    @StateObject var viewModel: DKConverterViewModel
    var body: some View {
        self.contentView
            .background(Color.secondarySystemBackground)
    }
    
    var contentView: some View {
        List {
            Section {
                self.textCyrillicView
                self.textLatinView
            } header: {
                self.conversionSettings
                .textCase(.none)
                .padding(.bottom)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            } footer: {
                EmptyView()
            }
        }
        .listStyle(.insetGrouped)
        .gesture(DragGesture().onChanged { _ in
            self.viewModel.onDrag()
        })

    }
    
    var textCyrillicView: some View {
        ZStack {
            if self.viewModel.textCyrillic.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        Text(DKLocalizationApp.converterTextCyrillic)
                            .foregroundColor(.secondary)
                            .padding(.leading, 4)
                        Spacer(minLength: 0)
                    }
                    Spacer(minLength: 0)
                }
                .padding(.top, 8)
            }
            TextEditor(text: self.$viewModel.textCyrillic)
                .multilineTextAlignment(.leading)
                .foregroundColor(.primary)
        }
        .font(.body)
    }
    
    var textLatinView: some View {
        ZStack {
            if self.viewModel.textLatin.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        Text(DKLocalizationApp.converterTextLatin)
                            .foregroundColor(.secondary)
                            .padding(.leading, 4)
                        Spacer(minLength: 0)
                    }
                    Spacer(minLength: 0)
                }
                .padding(.top, 8)
            }
            TextEditor(text: self.$viewModel.textLatin)
                .multilineTextAlignment(.leading)
                .foregroundColor(.primary)
        }
        .font(.body)
    }
    
    var conversionSettings: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading) {
                VStack(alignment: .center) {
                    Spacer(minLength: 0)
                    Text(DKLocalizationApp.converterBelarusianLatinTypeTitle)
                    Spacer(minLength: 0)
                }
                VStack(alignment: .center) {
                    Spacer(minLength: 0)
                    Text(DKLocalizationApp.converterBelarusianCyrillicTypeTitle)
                    Spacer(minLength: 0)
                }
            }
            .font(.caption)
            VStack {
                self.latinTypeView
                self.ophographyTypeView
            }
        }
    }
    
    var latinTypeView: some View {
        Picker("", selection: self.$viewModel.converterVersion) {
            Text(DKLocalizationApp.converterBelarusianLatinTypeTraditional).tag(BLVersion.traditional)
            Text(DKLocalizationApp.converterBelarusianLatinTypeGeographic).tag(BLVersion.geographic)
        }
        .pickerStyle(.segmented)
        
    }

    var ophographyTypeView: some View {
        Picker("", selection: self.$viewModel.converterOrthography) {
            Text(DKLocalizationApp.converterBelarusianCyrillicTypeTarashkevica).tag(BLOrthography.classic)
            Text(DKLocalizationApp.converterBelarusianCyrillicTypeNarkamauka).tag(BLOrthography.academic)
        }
        .pickerStyle(.segmented)
    }

}

#Preview {
    let viewModel = DKConverterViewModel()
    return DKConverterView(viewModel: viewModel)
}
