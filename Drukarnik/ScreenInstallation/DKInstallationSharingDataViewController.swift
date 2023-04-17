//
//  DKInstallationSharingDataViewController.swift
//  Drukarnik
//
//  Created by Logout on 17.04.23.
//

import UIKit

class DKInstallationSharingDataViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
