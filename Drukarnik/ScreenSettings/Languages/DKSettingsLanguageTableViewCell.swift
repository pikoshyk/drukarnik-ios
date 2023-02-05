//
//  DKSettingsLanguageTableViewCell.swift
//  Drukarnik
//
//  Created by Logout on 20.01.23.
//

import UIKit

class DKSettingsLanguageTableViewCell: UITableViewCell {
    
    var language: DKAdditionalLanguage?
    
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelChars: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.updateInterfaceLocalization()
    }

    func updateInterfaceLocalization() {
        self.labelName.text = self.language?.localizedName

        let chars = self.language?.charsListStr
        self.labelChars.text = (chars ?? "").isEmpty ? nil : chars
    }
}
