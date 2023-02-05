//
//  DKSettingsTransliterationTableViewCell.swift
//  Drukarnik
//
//  Created by Logout on 20.01.23.
//

import UIKit

class DKSettingsTransliterationTableViewCell: UITableViewCell {
    
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var segmentedTransliteration: UISegmentedControl!
    
    static let cellIdentifier = "cellTransliteration"

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.update()
    }
    
    func update() {
        self.updateInterfaceLocalization()
        self.loadSettings()
    }
    
    func updateInterfaceLocalization() {
        self.labelTitle.text = DKLocalizationApp.settingsTransliterationTitle
        self.segmentedTransliteration.setTitle(DKLocalizationApp.settingsTransliterationSegmentedLatin, forSegmentAt: 0)
        self.segmentedTransliteration.setTitle(DKLocalizationApp.settingsTransliterationSegmentedCyrillic, forSegmentAt: 1)
    }
    
    func loadSettings() {
        var selectedSegmentIndex: Int = 0
        if let transliteration = DKKeyboardSettings.shared.interfaceTransliteration {
            if transliteration == .cyrillic {
                selectedSegmentIndex = 1
            }
        }
        self.segmentedTransliteration.selectedSegmentIndex = selectedSegmentIndex
    }

    @IBAction func onTransliteration() {
        var transliteration: DKKeyboardLayout = .cyrillic
        if self.segmentedTransliteration.selectedSegmentIndex == 0 {
            transliteration = .latin
        }
        
        DKKeyboardSettings.shared.interfaceTransliteration = transliteration
    }
}
