//
//  DKSettingsLanguagesTableViewCell.swift
//  Drukarnik
//
//  Created by Logout on 20.01.23.
//

import UIKit

class DKSettingsLanguagesTableViewCell: UITableViewCell {
    
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var labelLanguages: UILabel!

    static let cellIdentifier = "cellLanguages"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.updateInterfaceLocalization()
    }

    func updateInterfaceLocalization() {
        self.labelTitle.text = DKLocalizationApp.settingsLanguagesTitle
        self.labelLanguages.text = self.supportedLanguages()
    }

    func supportedLanguages() -> String {
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
