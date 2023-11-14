//
//  DKInstallationSharingDataViewController.swift
//  Drukarnik
//
//  Created by Logout on 17.04.23.
//

import UIKit

class DKInstallationSharingDataViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var actionButtonYes: UIButton!
    @IBOutlet var actionButtonNo: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupLocalization()
    }
    
    @IBAction func onAgree() {
        DKKeyboardSettings.shared.shareTypingData = true
        self.next()
    }
    
    @IBAction func onDisagree() {
        DKKeyboardSettings.shared.shareTypingData = false
        self.next()
    }
    
    func next() {
        self.performSegue(withIdentifier: "install", sender: nil)
    }
    
}

extension DKInstallationSharingDataViewController {
    
    func setupLocalization() {
        NotificationCenter.default.addObserver(forName: .interfaceChanged, object: nil, queue: .main) { notification in
            self.updateInterfaceLocalization()
        }
        self.updateInterfaceLocalization()
    }

    func updateInterfaceLocalization() {
        self.titleLabel.text = DKLocalizationApp.installationSharingDataTitle
        self.descriptionLabel.text = DKLocalizationApp.installationSharingDataDescription
        self.questionLabel.text = DKLocalizationApp.installationSharingDataQuestion
        self.actionButtonYes.setTitle(DKLocalizationApp.installationSharingDataActionButtonYes, for: .normal)
        self.actionButtonNo.setTitle(DKLocalizationApp.installationSharingDataActionButtonNo, for: .normal)
    }
}

