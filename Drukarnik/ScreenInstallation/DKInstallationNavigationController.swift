//
//  DKInstallationNavigationController.swift
//  Drukarnik
//
//  Created by Logout on 13.11.23.
//

import UIKit

class DKInstallationNavigationController: UINavigationController {

    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { timer in
            if DKKeyboardSettings.isKeyboardActivated() {
                timer.invalidate()
                self.dismiss(animated: false)
            }
        })
    }

    class func show(on viewController: UIViewController) {
        let storyboard = UIStoryboard(name: "Installation", bundle: nil)
        let initViewController = storyboard.instantiateViewController(identifier: "DKInstallationNavigationController")
        initViewController.modalPresentationStyle = .fullScreen
        viewController.present(initViewController, animated: false)
    }
}
