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
        NavigationView {
            self.contentView
                .background(Color.secondarySystemBackground)
                .navigationTitle(DKLocalizationApp.converterTitleFull)

        }
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

    }
    
    var textCyrillicView: some View {
        VStack {
            TextField("Увядзіце тэкст кірыліцай", text: self.$viewModel.textCyrillic)
                .multilineTextAlignment(.leading)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
    
    var textLatinView: some View {
        VStack {
            TextField("Abo ŭviadzicie tekst lacinkaj", text: self.$viewModel.textLatin)
                .multilineTextAlignment(.leading)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
    
    var conversionSettings: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading) {
                VStack(alignment: .center) {
                    Spacer(minLength: 0)
                    Text("Лацінка")
                    Spacer(minLength: 0)
                }
                VStack(alignment: .center) {
                    Spacer(minLength: 0)
                    Text("Арфаграфія")
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
            Text("Традыцыйная").tag(BLVersion.traditional)
            Text("Геаграфічная").tag(BLVersion.geographic)
        }
        .pickerStyle(.segmented)
        
    }

    var ophographyTypeView: some View {
        Picker("", selection: self.$viewModel.converterOrthography) {
            Text("Тарашкевіца").tag(BLOrthography.classic)
            Text("Наркамаўка").tag(BLOrthography.academic)
        }
        .pickerStyle(.segmented)
    }

}

#Preview {
    let viewModel = DKConverterViewModel()
    return DKConverterView(viewModel: viewModel)
}
