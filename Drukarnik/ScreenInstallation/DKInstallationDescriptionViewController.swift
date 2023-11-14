//
//  DKInstallationDescriptionViewController.swift
//  Drukarnik
//
//  Created by Logout on 19.01.23.
//

import UIKit

class DKInstallationDescriptionViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var actionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupLocalization()
    }
    
    @IBAction func next() {
        
        var identifier = "shareTypingData"
        if DKKeyboardSettings.shared.shareTypingData {
            identifier = "install"
        }
        
        self.performSegue(withIdentifier: identifier, sender: nil)
    }
}

extension DKInstallationDescriptionViewController {
    
    func setupLocalization() {
        NotificationCenter.default.addObserver(forName: .interfaceChanged, object: nil, queue: .main) { notification in
            self.updateInterfaceLocalization()
        }
        self.updateInterfaceLocalization()
    }

    func updateInterfaceLocalization() {
        self.titleLabel.text = DKLocalizationApp.installationDescriptionTitle
        self.descriptionLabel.text = DKLocalizationApp.installationDescriptionDescription
        self.actionButton.setTitle(DKLocalizationApp.installationDescriptionActionButton, for: .normal)
    }
}

