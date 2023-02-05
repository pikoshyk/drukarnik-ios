//
//  DKSettingsTransliterationTableViewCell.swift
//  Drukarnik
//
//  Created by Logout on 20.01.23.
//
import BelarusianLacinka
import UIKit

class DKSettingsBelarusianLatinTypeTableViewCell: UITableViewCell {
    
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var labelLatinType: UILabel!
    
    static let cellIdentifier = "cellLatinType"

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.update()
    }
    
    func update() {
        self.updateInterfaceLocalization()
    }
    
    func updateInterfaceLocalization() {
        self.labelTitle.text = DKLocalizationApp.settingsBelarusianLatinTypeTitle
        let latinType = DKKeyboardSettings.shared.belarusianLatinType
        self.labelLatinType.text = latinType == .traditional ? DKLocalizationApp.settingsBelarusianLatinTypeTraditional : DKLocalizationApp.settingsBelarusianLatinTypeGeographic
    }
}
