//
//  DKSettingsLanguagesViewModel.swift
//  Drukarnik
//
//  Created by Logout on 23.11.23.
//

import Foundation
import Combine

class DKSettingsLanguagesViewModel: ObservableObject {

    class LanguageCell: Identifiable {
        var language: DKAdditionalLanguage
        var selected: Bool
        var id: String { self.language.id }
        
        init(language: DKAdditionalLanguage, selected: Bool) {
            self.language = language
            self.selected = selected
        }
    }
    
    class LanguageSection: Identifiable {
        let id = UUID()
        var title: String?
        var cells: [LanguageCell]
        
        init(title: String? = nil, cells: [LanguageCell]) {
            self.title = title
            self.cells = cells
        }
    }
    
    var navigationTitle: String {
        DKLocalizationApp.settingsLanguagesControllerTitle
    }
    
    @Published var supportedLanguages: String
    var cellSections: [LanguageSection] = []

    private var interfaceChangedObserver: NSObjectProtocol?
    
    init() {
        self.supportedLanguages = Self.getSupportedLanguages()
        self.initLocalization()
        self.loadData()
    }
    
    deinit {
        self.deinitLocalization()
    }
    
    func toogleLanguage(_ language: DKAdditionalLanguage) {
        for section in self.cellSections {
            for cell in section.cells {
                if cell.language.id == language.id {
                    cell.selected.toggle()
                }
            }
        }
        self.saveData()
        self.supportedLanguages = Self.getSupportedLanguages()
        self.objectWillChange.send()
    }
    
    private static func getSupportedLanguages() -> String {
        var languagesStr = ""
        let languages = Self.sortedLanguages(DKKeyboardSettings.shared.supportedAdditionalLanguages)
            .map { $0.localizedName }
        
        for language in languages {
            if languagesStr.count > 0 {
                languagesStr += ", "
            }
            languagesStr += language
        }

        return languagesStr
    }

    private static let languageListSortLocale = Locale(identifier: "be_BY")

    private static func sortedLanguages(_ languages: [DKAdditionalLanguage]) -> [DKAdditionalLanguage] {
        languages.sorted {
            $0.name.compare(
                $1.name,
                options: [.caseInsensitive, .diacriticInsensitive],
                locale: languageListSortLocale
            ) == .orderedAscending
        }
    }

}

extension DKSettingsLanguagesViewModel {
    
    func initLocalization() {
        self.interfaceChangedObserver = NotificationCenter.default.addObserver(forName: .interfaceChanged, object: nil, queue: .main) { [weak self] notification in
            self?.loadData()
            self?.objectWillChange.send()
        }
    }
    
    func deinitLocalization() {
        if let interfaceChangedObserver = self.interfaceChangedObserver {
            self.interfaceChangedObserver = nil
            NotificationCenter.default.removeObserver(interfaceChangedObserver)
        }
    }

    func loadData() {
        let languages = DKKeyboardSettings.shared.availableAdditionalLanguages
        let supportedLanguageIds = DKKeyboardSettings.shared.supportedAdditionalLanguages.compactMap { $0.id }
        let cyrillic = languages.filter({ $0.layout == .cyrillic })
        let latin = languages.filter({ $0.layout == .latin })
        var cellSections: [LanguageSection] = []

        let cyrillicCells = Self.sortedLanguages(cyrillic).map { language in
            LanguageCell(language: language, selected: supportedLanguageIds.contains(language.id))
        }
        cellSections.append(
            LanguageSection(
                title: DKLocalizationApp.settingsLanguagesControllerSectionCyrillic.uppercased(),
                cells: cyrillicCells
            )
        )

        let latinCells = Self.sortedLanguages(latin).map { language in
            LanguageCell(language: language, selected: supportedLanguageIds.contains(language.id))
        }
        cellSections.append(
            LanguageSection(
                title: DKLocalizationApp.settingsLanguagesControllerSectionLatin.uppercased(),
                cells: latinCells
            )
        )
        self.cellSections = cellSections
    }
    
    func saveData() {
        var supportedLanguages: [DKAdditionalLanguage] = []
        for section in self.cellSections {
            let languages = section.cells.compactMap { $0.selected ? $0.language : nil }
            supportedLanguages.append(contentsOf: languages)
        }
        DKKeyboardSettings.shared.supportedAdditionalLanguages = supportedLanguages
    }
}
