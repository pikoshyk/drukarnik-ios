//
//  DKInstallationNavigationController.swift
//  Drukarnik
//
//  Created by Logout on 13.11.23.
//

import UIKit

class DKInstallationNavigationController: UINavigationController {

    var timer: Timer?
    var onKeyboardActivated: (() -> Void)?

    deinit {
        self.timer?.invalidate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [weak self] timer in
            if DKKeyboardSettings.isKeyboardActivated() {
                timer.invalidate()
                self?.onKeyboardActivated?()
            }
        })
    }

    class func make() -> DKInstallationNavigationController {
        let storyboard = UIStoryboard(name: "Installation", bundle: nil)
        return storyboard.instantiateViewController(identifier: "DKInstallationNavigationController") as! DKInstallationNavigationController
    }
}
