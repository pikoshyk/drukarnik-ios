import XCTest
@testable import Drukarnik

final class DrukarnikHostTests: XCTestCase {
    private let cyrillicSample = "Налады"

    override func tearDown() {
        DKKeyboardSettings.shared.interfaceTransliteration = .cyrillic
        super.tearDown()
    }

    func testProcessedWordReflectsInterfaceTransliteration() {
        DKKeyboardSettings.shared.interfaceTransliteration = .cyrillic
        let cyrillic = DKLocalizationApp.processedWord(self.cyrillicSample)
        XCTAssertEqual(cyrillic, self.cyrillicSample)

        DKKeyboardSettings.shared.interfaceTransliteration = .latin
        let latin = DKLocalizationApp.processedWord(self.cyrillicSample)
        XCTAssertNotEqual(latin, self.cyrillicSample)
        XCTAssertFalse(latin.isEmpty)
    }

    func testSettingsViewModelUpdatesTitlesAfterInterfaceChanged() {
        DKKeyboardSettings.shared.interfaceTransliteration = .cyrillic
        let viewModel = DKSettingsViewModel()
        let cyrillicTitle = viewModel.presentNavigationTitle

        DKKeyboardSettings.shared.interfaceTransliteration = .latin

        let latinTitle = viewModel.presentNavigationTitle
        XCTAssertNotEqual(cyrillicTitle, latinTitle)
    }

    func testTransliterationChoiceIgnoresDuplicateRequestWhilePresented() {
        let viewModel = DKAppViewModel()
        var completionCount = 0

        viewModel.requestTransliterationChoice { _ in
            completionCount += 1
        }
        XCTAssertTrue(viewModel.isTransliterationChoicePresented)

        viewModel.requestTransliterationChoice { _ in
            completionCount += 1
        }
        XCTAssertEqual(completionCount, 0)

        viewModel.finishTransliterationChoice(.latin)
        XCTAssertFalse(viewModel.isTransliterationChoicePresented)
        XCTAssertEqual(completionCount, 1)
    }
}
