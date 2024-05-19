//
//  DKDictionaryWordRowView.swift
//  Drukarnik
//
//  Created by Logout on 3.05.24.
//

import SwiftUI

struct DKDictionaryWordRowView: View {
    
    let viewModel: any DKWordModel
    
    var body: some View {
        HStack {
            Text(viewModel.word)
                .font(.body)
            Spacer(minLength: 0)
            self.dictionaryNameView
        }
    }
    
    var dictionaryNameView: some View {
        Group {
            if let dictionaryName = self.viewModel.dictionaryName {
                Text(dictionaryName)
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                EmptyView()
            }
        }
    }
}
