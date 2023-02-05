//
//  DKSettingsBelarusianCyrillicTypeTableViewController.swift
//  Drukarnik
//
//  Created by Logout on 3.02.23.
//

import BelarusianLacinka
import UIKit

class DKSettingsBelarusianCyrillicTypeTableViewController: UITableViewController {

    struct Cell {
        var title: String
        var orthography: BelarusianLacinka.BLOrthography
        var selected: Bool
    }

    var cells: [Cell] = []

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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cellData = self.cells[indexPath.row]
        if #available(iOS 14.0, *) {
            var cellContent = cell.defaultContentConfiguration()
            cellContent.text = cellData.title
            cell.contentConfiguration = cellContent
        } else {
            cell.textLabel?.text = cellData.title
        }
        cell.accessoryType = cellData.selected ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selectedCell = self.cells[indexPath.row]
        for i in 0..<self.cells.count  {
            self.cells[i].selected = (self.cells[i].orthography == selectedCell.orthography) ? true : false
        }
        self.saveData()
    }

}

extension DKSettingsBelarusianCyrillicTypeTableViewController {
    
    func setupLocalization() {
        NotificationCenter.default.addObserver(forName: .interfaceChanged, object: nil, queue: .main) { notification in
            self.updateInterfaceLocalization()
        }
        self.updateInterfaceLocalization()
    }

    func updateInterfaceLocalization() {
        self.navigationItem.title = DKLocalizationApp.settingsBelarusianCyrillicTypeTitle
        self.tableView.reloadData()
    }
    
    func loadData() {
        
        let currentCyrillicType = DKKeyboardSettings.shared.belarusianCyrillicType
        
        var cells: [Cell] = [
            Cell(title: DKLocalizationApp.settingsBelarusianCyrillicTypeTarashkevica, orthography: BelarusianLacinka.BLOrthography.classic, selected: false),
            Cell(title: DKLocalizationApp.settingsBelarusianCyrillicTypeNarkamauka, orthography: BelarusianLacinka.BLOrthography.academic, selected: false),
        ]
        for i in 0..<cells.count {
            if cells[i].orthography == currentCyrillicType {
                cells[i].selected = true
            }
        }


        self.cells = cells
    }
    
    func saveData() {
        let cyrillicType = self.cells.filter { $0.selected == true }.first?.orthography ?? DKKeyboardSettings.shared.defaultBelarusianCyrillicType

        DKKeyboardSettings.shared.belarusianCyrillicType = cyrillicType
    }
}
