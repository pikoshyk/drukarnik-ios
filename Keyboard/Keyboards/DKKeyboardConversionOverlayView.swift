import BelarusianLacinka
import SwiftUI

struct DKKeyboardConversionOverlayView: View {
    @ObservedObject var viewModel: DKKeyboardViewModel

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.keyboardBackground)
                .zIndex(1.0)
            ScrollView {
                VStack {
                    if viewModel.overlayHasLetters {
                        HStack(spacing: 0) {
                            DKKeyboardConversionButton(
                                viewModel: viewModel,
                                direction: .toCyrillic,
                                label: Text(DKKeyboardConversionOverlayLocalization.convertToCyrillicTitle)
                            )
                            .font(.body)
                            Spacer(minLength: 2)
                            Text(DKKeyboardConversionOverlayLocalization.convertLabelTitle)
                                .foregroundColor(Color(.quaternaryLabel))
                                .font(.callout)
                            Spacer(minLength: 2)
                            DKKeyboardConversionButton(
                                viewModel: viewModel,
                                direction: .toLacin,
                                label: Text(DKKeyboardConversionOverlayLocalization.convertToLatinTitle)
                            )
                            .font(.body)
                        }
                    } else {
                        Text(DKKeyboardConversionOverlayLocalization.convertUnavailableTitle)
                            .foregroundColor(Color(.quaternaryLabel))
                            .font(.callout)
                    }
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 8)
            .frame(width: .infinity, height: .infinity)
            .zIndex(2.0)
        }
    }
}

private struct DKKeyboardConversionButton: View {
    @ObservedObject var viewModel: DKKeyboardViewModel
    let direction: BLDirection?
    let label: Text

    var body: some View {
        Group {
            if #available(iOS 15.0, *) {
                button
                    .buttonStyle(.bordered)
            } else {
                button
                    .buttonStyle(.automatic)
            }
        }
    }

    private var button: some View {
        Button {
            viewModel.convertText(direction: direction)
        } label: {
            label
        }
        .foregroundColor(.accent)
    }
}

private enum DKKeyboardConversionOverlayLocalization {
    static var convertToLatinTitle: String { DKLocalizationKeyboard.convert(text: "Лацінка") }
    static var convertToCyrillicTitle: String { DKLocalizationKeyboard.convert(text: "Кірыліца") }
    static var convertLabelTitle: String { DKLocalizationKeyboard.convert(text: "канвертаваць тэкст у") }
    static var convertUnavailableTitle: String {
        DKLocalizationKeyboard.convert(text: "Опцыі канвертацыі тэксту ў Лацінку і Кірыліцу адлюструюцца тут, калі будзе ўведзены тэкст.")
    }
}
