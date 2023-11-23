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
    
    let navigationTitle = "Мовы"
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
        let languages = DKKeyboardSettings.shared.supportedAdditionalLanguages.compactMap { $0.localizedName }.sorted()
        
        for language in languages {
            if languagesStr.count > 0 {
                languagesStr += ", "
            }
            languagesStr += language
        }

        return languagesStr
    }

}

extension DKSettingsLanguagesViewModel {
    
    func initLocalization() {
        self.interfaceChangedObserver = NotificationCenter.default.addObserver(forName: .interfaceChanged, object: nil, queue: .main) { notification in
            self.objectWillChange.send()
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

        if true {
            var cells: [LanguageCell] = []
            for language in cyrillic {
                let selected = supportedLanguageIds.contains(language.id)
                let cell = LanguageCell(language: language, selected: selected)
                cells.append(cell)
            }
            cells.sort { cell1, cell2 in
                cell1.language.localizedName < cell2.language.localizedName
            }
            let section = LanguageSection(title: DKLocalizationApp.settingsLanguagesControllerSectionCyrillic.uppercased(), cells: cells)
            cellSections.append(section)
        }

        if true {
            var cells: [LanguageCell] = []
            for language in latin {
                let selected = supportedLanguageIds.contains(language.id)
                let cell = LanguageCell(language: language, selected: selected)
                cells.append(cell)
            }
            cells.sort { cell1, cell2 in
                cell1.language.localizedName < cell2.language.localizedName
            }
            let section = LanguageSection(title: DKLocalizationApp.settingsLanguagesControllerSectionLatin.uppercased(), cells: cells)
            cellSections.append(section)
        }
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
