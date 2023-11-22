//
//  DKSettingsCellView.swift
//  Drukarnik
//
//  Created by Logout on 22.11.23.
//

import SwiftUI

struct DKSettingsCellView<T: Hashable>: View {
    
    let title: String
    let availableOptions: [DKSettingViewOption<T>]
    let selectedOption: T
    let onChange: (T) -> Void

    private var selectedOptionTitle: String {
        self.availableOptions.filter {
            $0.value == self.selectedOption
        }.first?.title ?? ""
    }
    
    var body: some View {
        Menu {
            ForEach(self.availableOptions, id: \.value) { option in
                Button {
                    self.onChange(option.value)
                } label: {
                    Label(option.title, systemImage: option.value == self.selectedOption ? "checkmark" : "")
                }
            }
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(self.title)
                        .font(.headline)
                    Text(self.selectedOptionTitle)
                        .font(.subheadline)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.body)
            }
            .foregroundColor(.primary)
        }
    }
}
