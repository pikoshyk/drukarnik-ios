//
//  DKSettingsLanguagesTableViewController.swift
//  Drukarnik
//
//  Created by Logout on 20.01.23.
//

import UIKit

class DKSettingsLanguagesTableViewController: UITableViewController {
    
    struct LanguageCell {
        var language: DKAdditionalLanguage
        var selected: Bool
    }
    
    struct LanguageSection {
        var title: String?
        var cells: [LanguageCell]
    }
    
    var cellSections: [LanguageSection] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLocalization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.cellSections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.cellSections[section].title
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellSections[section].cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellLanguage", for: indexPath)
        if let cellX = cell as? DKSettingsLanguageTableViewCell {
            let cellData = self.cellSections[indexPath.section].cells[indexPath.row]
            cellX.language = cellData.language
            cellX.accessoryType = cellData.selected ? .checkmark : .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedLanguage = self.cellSections[indexPath.section].cells[indexPath.row].selected
        let cell = tableView.cellForRow(at: indexPath)
        if let cellX = cell as? DKSettingsLanguageTableViewCell {
            self.cellSections[indexPath.section].cells[indexPath.row].selected = !selectedLanguage
            cellX.accessoryType = selectedLanguage ? .none : .checkmark
            self.saveData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DKSettingsLanguagesTableViewController {
    
    func setupLocalization() {
        NotificationCenter.default.addObserver(forName: .interfaceChanged, object: nil, queue: .main) { notification in
            self.updateInterfaceLocalization()
        }
        self.updateInterfaceLocalization()
    }

    func updateInterfaceLocalization() {
        self.navigationItem.title = DKLocalizationApp.settingsLanguagesControllerTitle
        self.tableView.reloadData()
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
