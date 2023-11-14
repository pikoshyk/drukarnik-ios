//
//  DKInstallationKeyboardViewController.swift
//  Drukarnik
//
//  Created by Logout on 14.11.23.
//

import UIKit

class DKInstallationKeyboardViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var step1Label: UILabel!
    @IBOutlet var step2Label: UILabel!
    @IBOutlet var step2HelperLabel: UILabel!
    @IBOutlet var step3Label: UILabel!
    @IBOutlet var step4Label: UILabel!
    @IBOutlet var step5Label: UILabel!
    @IBOutlet var step6Label: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupLocalization()
    }
    
    @IBAction func onOpenSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
}

extension DKInstallationKeyboardViewController {
    
    func setupLocalization() {
        NotificationCenter.default.addObserver(forName: .interfaceChanged, object: nil, queue: .main) { notification in
            self.updateInterfaceLocalization()
        }
        self.updateInterfaceLocalization()
    }

    func updateInterfaceLocalization() {
        self.titleLabel.text = DKLocalizationApp.installationKeyboardTitle
        self.descriptionLabel.text = DKLocalizationApp.installationKeyboardDescription
        self.step1Label.text = DKLocalizationApp.installationKeyboardStep1
        self.step2Label.text = DKLocalizationApp.installationKeyboardStep2
        self.step2HelperLabel.text = DKLocalizationApp.installationKeyboardStep2Helper
        self.step3Label.text = DKLocalizationApp.installationKeyboardStep3
        self.step4Label.text = DKLocalizationApp.installationKeyboardStep4
        self.step5Label.text = DKLocalizationApp.installationKeyboardStep5
        self.step6Label.text = DKLocalizationApp.installationKeyboardStep6
    }
}

