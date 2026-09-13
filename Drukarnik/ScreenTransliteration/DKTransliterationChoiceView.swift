//
//  DKTransliterationChoiceView.swift
//  Drukarnik
//

import SwiftUI

private struct DKTransliterationChoiceFittedHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct DKTransliterationChoiceView: View {
    @ObservedObject var viewModel: DKTransliterationChoiceViewModel
    @State private var fittedSheetHeight: CGFloat = 420

    static let contentMaxWidth: CGFloat = 387

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color(uiColor: .separator))
                .frame(height: 0.5)
            self.bodyContent
        }
        .background(
            GeometryReader { geometry in
                Color.clear.preference(
                    key: DKTransliterationChoiceFittedHeightKey.self,
                    value: geometry.size.height
                )
            }
        )
        .onPreferenceChange(DKTransliterationChoiceFittedHeightKey.self) { height in
            guard height > 0 else { return }
            self.fittedSheetHeight = height
        }
        .onAppear {
            self.viewModel.runAppearDemo()
        }
        .modifier(DKTransliterationChoiceSheetChrome(fittedHeight: self.fittedSheetHeight))
    }

    @ViewBuilder
    private var bodyContent: some View {
        if #available(iOS 16.0, *) {
            ViewThatFits(in: .vertical) {
                self.paddedContent
                ScrollView(showsIndicators: true) {
                    self.paddedContent
                }
            }
        } else {
            ScrollView(showsIndicators: true) {
                self.paddedContent
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var paddedContent: some View {
        self.contentColumn
            .padding(.vertical, 16)
    }

    private var contentColumn: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text(self.viewModel.title)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                Picker("", selection: self.$viewModel.previewSegment) {
                    Text(DKLocalizationApp.transliterationSegmentedLatin)
                        .tag(DKTransliterationPreviewSegment.lacinka)
                    Text(DKLocalizationApp.transliterationSegmentedCyrillic)
                        .tag(DKTransliterationPreviewSegment.cyrillic)
                }
                .pickerStyle(.segmented)
                .frame(height: 24)
            }
            Text(self.viewModel.history)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(self.viewModel.appeal)
                .font(.headline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            HStack(spacing: 16) {
                self.commitButton(
                    title: DKLocalizationApp.transliterationButtonLatinTitle,
                    subtitle: DKLocalizationApp.transliterationButtonLatinSubtitle,
                    action: self.viewModel.chooseLatin
                )
                self.commitButton(
                    title: DKLocalizationApp.transliterationButtonCyrillicTitle,
                    subtitle: DKLocalizationApp.transliterationButtonCyrillicSubtitle,
                    action: self.viewModel.chooseCyrillic
                )
            }
            .frame(height: 60)
            Text(self.viewModel.note)
                .font(.footnote)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: Self.contentMaxWidth)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
    }

    private func commitButton(title: String, subtitle: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(.white)
        .background(Color.accentColor)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

private struct DKTransliterationChoiceSheetChrome: ViewModifier {
    let fittedHeight: CGFloat

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            let height = max(self.fittedHeight, 1)
            content
                .interactiveDismissDisabled(true)
                .presentationDetents([.height(height)])
        } else if #available(iOS 15.0, *) {
            content.interactiveDismissDisabled(true)
        } else {
            content
        }
    }
}

#Preview("Sheet") {
    Color(uiColor: .systemBackground)
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: .constant(true)) {
            DKTransliterationChoiceView(
                viewModel: DKTransliterationChoiceViewModel(onComplete: { _ in })
            )
        }
}
