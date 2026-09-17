import XCTest
@testable import Drukarnik

final class DKAdditionalLanguagesTests: XCTestCase {
    func testCatalogIncludesGermanAndSpanish() {
        let languages = DKAdditionalLanguages.load()
        let german = languages.first { $0.id == "german" }
        let spanish = languages.first { $0.id == "spanish" }

        XCTAssertNotNil(german)
        XCTAssertEqual(german?.code, "de")
        XCTAssertEqual(german?.layout, .latin)
        XCTAssertEqual(german?.name, "Нямецкая")

        XCTAssertNotNil(spanish)
        XCTAssertEqual(spanish?.code, "es")
        XCTAssertEqual(spanish?.layout, .latin)
        XCTAssertEqual(spanish?.name, "Гішпанская")
    }

    func testGermanExtendedChars() {
        let languages = DKAdditionalLanguages.load()
        guard let german = languages.first(where: { $0.id == "german" }) else {
            XCTFail("german missing from catalog")
            return
        }

        XCTAssertEqual(german.extendedChars(baseChar: "a"), "ä")
        XCTAssertEqual(german.extendedChars(baseChar: "o"), "ö")
        XCTAssertEqual(german.extendedChars(baseChar: "u"), "ü")
        XCTAssertEqual(german.extendedChars(baseChar: "s"), "ß")
        XCTAssertNil(german.extendedChars(baseChar: "z"))
    }

    func testSpanishExtendedChars() {
        let languages = DKAdditionalLanguages.load()
        guard let spanish = languages.first(where: { $0.id == "spanish" }) else {
            XCTFail("spanish missing from catalog")
            return
        }

        XCTAssertEqual(spanish.extendedChars(baseChar: "a"), "á")
        XCTAssertEqual(spanish.extendedChars(baseChar: "e"), "é")
        XCTAssertEqual(spanish.extendedChars(baseChar: "i"), "í")
        XCTAssertEqual(spanish.extendedChars(baseChar: "o"), "ó")
        XCTAssertEqual(spanish.extendedChars(baseChar: "u"), "úü")
        XCTAssertEqual(spanish.extendedChars(baseChar: "n"), "ñ")
    }

    func testItalianExtendedChars() {
        let languages = DKAdditionalLanguages.load()
        guard let italian = languages.first(where: { $0.id == "italian" }) else {
            XCTFail("italian missing from catalog")
            return
        }

        XCTAssertEqual(italian.extendedChars(baseChar: "a"), "à")
        XCTAssertEqual(italian.extendedChars(baseChar: "e"), "éè")
        XCTAssertEqual(italian.extendedChars(baseChar: "i"), "ì")
        XCTAssertEqual(italian.extendedChars(baseChar: "o"), "ò")
        XCTAssertEqual(italian.extendedChars(baseChar: "u"), "ù")
    }

    func testPortugueseExtendedChars() {
        let languages = DKAdditionalLanguages.load()
        guard let portuguese = languages.first(where: { $0.id == "portuguese" }) else {
            XCTFail("portuguese missing from catalog")
            return
        }

        XCTAssertEqual(portuguese.extendedChars(baseChar: "a"), "áàâã")
        XCTAssertEqual(portuguese.extendedChars(baseChar: "c"), "ç")
        XCTAssertEqual(portuguese.extendedChars(baseChar: "e"), "éê")
        XCTAssertEqual(portuguese.extendedChars(baseChar: "i"), "í")
        XCTAssertEqual(portuguese.extendedChars(baseChar: "o"), "óôõ")
        XCTAssertEqual(portuguese.extendedChars(baseChar: "u"), "ú")
    }
}
