//
//  DKTabBarController.swift
//  Drukarnik
//
//  Created by Logout on 3.02.23.
//

import UIKit

class DKTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLocalization()
    }
    
    func setupLocalization() {
        NotificationCenter.default.addObserver(forName: .interfaceChanged, object: nil, queue: .main) { notification in
            self.updateInterfaceLocalization()
        }
        self.updateInterfaceLocalization()
    }

    func updateInterfaceLocalization() {
        let titles = [DKLocalizationApp.settingsTitle,
                      DKLocalizationApp.converterTitle,
                      DKLocalizationApp.aboutTitle]
        let count = self.tabBar.items?.count ?? 0
        for i in 0..<count {
            let title = titles.count < i ? "" : titles[i]
            self.tabBar.items?[i].title = title
        }
    }
    
}
