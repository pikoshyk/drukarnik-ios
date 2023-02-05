//
//  DKSettingsBelarusianCyrillicTypeTableViewCell.swift
//  Drukarnik
//
//  Created by Logout on 20.01.23.
//
import BelarusianLacinka
import UIKit

class DKSettingsBelarusianCyrillicTypeTableViewCell: UITableViewCell {
    
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var labelCyrillicType: UILabel!
    
    static let cellIdentifier = "cellCyrillicType"

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
        self.labelTitle.text = DKLocalizationApp.settingsBelarusianCyrillicTypeTitle
        let cyrillicType = DKKeyboardSettings.shared.belarusianCyrillicType
        self.labelCyrillicType.text = cyrillicType == .classic ? DKLocalizationApp.settingsBelarusianCyrillicTypeTarashkevica : DKLocalizationApp.settingsBelarusianCyrillicTypeNarkamauka
    }
}
