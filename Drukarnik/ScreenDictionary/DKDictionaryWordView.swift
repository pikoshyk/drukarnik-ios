//
//  DKDictionaryWordView.swift
//  Drukarnik
//
//  Created by Logout on 3.05.24.
//

import SwiftUI

struct DKDictionaryWordView: View {
    
    let viewModel: any DKWordModel
    
    var body: some View {
        Text(viewModel.word)
            .font(.body)
    }
}
