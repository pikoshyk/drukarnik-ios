//
//  DKTransliterationChoiceViewModel.swift
//  Drukarnik
//

import BelarusianLacinka
import Combine
import Foundation

enum DKTransliterationPreviewSegment: Int, CaseIterable, Hashable {
    case lacinka = 0
    case cyrillic = 1

    var direction: BLDirection {
        switch self {
        case .lacinka:
            return .toLacin
        case .cyrillic:
            return .toCyrillic
        }
    }
}

class DKTransliterationChoiceViewModel: ObservableObject {
    @Published var previewSegment: DKTransliterationPreviewSegment = .cyrillic

    private let onComplete: (DKKeyboardLayout) -> Void
    private var demoStepOne: DispatchWorkItem?
    private var demoStepTwo: DispatchWorkItem?

    init(onComplete: @escaping (DKKeyboardLayout) -> Void) {
        self.onComplete = onComplete
    }

    deinit {
        self.cancelAppearDemo()
    }

    var title: String {
        DKLocalizationApp.transliterationTitle(direction: self.previewSegment.direction)
    }

    var history: String {
        DKLocalizationApp.transliterationHistory(direction: self.previewSegment.direction)
    }

    var appeal: String {
        DKLocalizationApp.transliterationAppeal(direction: self.previewSegment.direction)
    }

    var note: String {
        DKLocalizationApp.transliterationNote(direction: self.previewSegment.direction)
    }

    func runAppearDemo() {
        self.cancelAppearDemo()
        let stepTwo = DispatchWorkItem { [weak self] in
            self?.previewSegment = .cyrillic
        }
        let stepOne = DispatchWorkItem { [weak self] in
            self?.previewSegment = .lacinka
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: stepTwo)
        }
        self.demoStepOne = stepOne
        self.demoStepTwo = stepTwo
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: stepOne)
    }

    private func cancelAppearDemo() {
        self.demoStepOne?.cancel()
        self.demoStepTwo?.cancel()
        self.demoStepOne = nil
        self.demoStepTwo = nil
    }

    func chooseLatin() {
        self.onComplete(.latin)
    }

    func chooseCyrillic() {
        self.onComplete(.cyrillic)
    }
}
