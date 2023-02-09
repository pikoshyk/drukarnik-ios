//
//  DKConverterOptionsTableViewCell.swift
//  Drukarnik
//
//  Created by Logout on 6.02.23.
//

import UIKit
import BelarusianLacinka

protocol DKConverterOptionsDelegate: AnyObject {
    func onConverterOptionsUpdate(version: BelarusianLacinka.BLVersion, orthography: BelarusianLacinka.BLOrthography)
}

class DKConverterOptionsTableViewCell: UITableViewCell {
    
    @IBOutlet var labelCyrillic: UILabel!
    @IBOutlet var labelLatin: UILabel!
    @IBOutlet var segmentedCyrillic: UISegmentedControl!
    @IBOutlet var segmentedLatin: UISegmentedControl!
    
    var delegate: DKConverterOptionsDelegate?

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
        self.onUpdate()
    }
    
    func updateInterfaceLocalization() {
        self.labelCyrillic.text = DKLocalizationApp.converterBelarusianCyrillicTypeTitle
        self.labelLatin.text = DKLocalizationApp.converterBelarusianLatinTypeTitle
        
        self.segmentedLatin.setTitle(DKLocalizationApp.converterBelarusianLatinTypeTraditional, forSegmentAt: 0)
        self.segmentedLatin.setTitle(DKLocalizationApp.converterBelarusianLatinTypeGeographic, forSegmentAt: 1)

        self.segmentedCyrillic.setTitle(DKLocalizationApp.converterBelarusianCyrillicTypeTarashkevica, forSegmentAt: 0)
        self.segmentedCyrillic.setTitle(DKLocalizationApp.converterBelarusianCyrillicTypeNarkamauka, forSegmentAt: 1)
    }
    
    func loadSettings() {
        let versionSelectedSegmentIndex = DKKeyboardSettings.shared.converterVersion == .traditional ? 0 : 1
        let orthographySelectedSegmentIndex = DKKeyboardSettings.shared.converterOrthography == .classic ? 0 : 1
        self.segmentedLatin.selectedSegmentIndex = versionSelectedSegmentIndex
        self.segmentedCyrillic.selectedSegmentIndex = orthographySelectedSegmentIndex
    }

    @IBAction func onUpdate() {
        var version: BelarusianLacinka.BLVersion = .traditional
        if self.segmentedLatin.selectedSegmentIndex == 1 {
            version = .geographic
        }

        var orthography: BelarusianLacinka.BLOrthography = .classic
        if self.segmentedCyrillic.selectedSegmentIndex == 1 {
            orthography = .academic
        }
        
        DKKeyboardSettings.shared.converterVersion = version
        DKKeyboardSettings.shared.converterOrthography = orthography

        self.delegate?.onConverterOptionsUpdate(version: version, orthography: orthography)
    }

}
