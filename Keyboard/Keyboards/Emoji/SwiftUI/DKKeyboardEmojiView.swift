//
//  DKKeyboardEmojiView.swift
//  Keyboard
//
//  Created by Logout on 24.11.23.
//

import SwiftUI

struct DKKeyboardEmojiView: View {
    var viewModel: DKKeyboardEmojiViewModel
    
    var body: some View {
        Group {
            GeometryReader(content: { geometry in
                let headerHeight = 14.0
                let height = geometry.size.height - headerHeight
                
                let size = CGSize(width: height/5.6, height: height/5.6)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 20) {
                        ForEach(self.viewModel.sections) { section in
                            self.sectionView(section, size: size)
                        }
                    }
                    .padding(size.width/5.0)
                }
            })
        }
    }
    
    @ViewBuilder
    func sectionView(_ section: DKEmojiSection, size: CGSize) -> some View {
        let emojiFont = Font.system(size: size.width / 1.3)
        let chunks = section.chunkedItems(maxRows: 5)
        VStack(alignment: .leading, spacing: 0) {
            Group {
                Text(section.title.uppercased())
                    .font(Font.system(size: 12, weight: .bold))
                    .padding(.leading, 4)
            }
            .frame(height: 14)
            LazyHStack(spacing: 1) {
                ForEach(chunks, id: \.self) { itemsColumn in
                    VStack(spacing: 1) {
                        ForEach(itemsColumn, id: \.self) { item in
                            Button {
                                self.viewModel.onPress(String(item))
                            } label: {
                                Text(String(item))
                                    .font(emojiFont)
                            }
                            .frame(height: size.height)
                        }
                        if itemsColumn.count < 5 {
                            Spacer()
                        }
                    }
                    .frame(width: size.width)
                }
            }
        }
    }
}

#Preview {
    DKKeyboardEmojiView(viewModel: DKKeyboardEmojiViewModel())
        .background(Color.secondary)
        .frame(height: 260.0)
}
