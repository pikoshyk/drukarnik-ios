//
//  DKSettingsTableViewController.swift
//  Drukarnik
//
//  Created by Logout on 19.01.23.
//

import UIKit

class DKSettingsTableViewController: UITableViewController {
    
    struct SettingsCell {
        var cellIdentifier: String
    }
    
    struct SettingsSection {
        var title: String?
        var cells: [SettingsCell] = []
    }
    
    var cellSections: [SettingsSection] =
    [
        SettingsSection(cells: [
            SettingsCell(cellIdentifier: DKSettingsBelarusianCyrillicTypeTableViewCell.cellIdentifier),
            SettingsCell(cellIdentifier: DKSettingsBelarusianLatinTypeTableViewCell.cellIdentifier),
            SettingsCell(cellIdentifier: DKSettingsLanguagesTableViewCell.cellIdentifier),
            SettingsCell(cellIdentifier: DKSettingsTransliterationTableViewCell.cellIdentifier),
        ])
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLocalization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.cellSections[section].title
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.cellSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellSections[section].cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsCell = self.cellSections[indexPath.section].cells[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: settingsCell.cellIdentifier, for: indexPath)
        return cell
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

extension DKSettingsTableViewController {
    
    func setupLocalization() {
        NotificationCenter.default.addObserver(forName: .interfaceChanged, object: nil, queue: .main) { notification in
            self.updateInterfaceLocalization()
        }
        self.updateInterfaceLocalization()
    }

    func updateInterfaceLocalization() {
        self.navigationItem.title = DKLocalizationApp.settingsTitle
        self.tableView.reloadData()
    }
}
