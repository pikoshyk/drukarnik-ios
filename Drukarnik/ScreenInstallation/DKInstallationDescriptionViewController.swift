//
//  DKInstallationDescriptionViewController.swift
//  Drukarnik
//
//  Created by Logout on 19.01.23.
//

import UIKit

class DKInstallationDescriptionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func next() {
        
        var identifier = "shareTypingData"
        if DKKeyboardSettings.shared.shareTypingData {
            identifier = "install"
        }
        
        self.performSegue(withIdentifier: identifier, sender: nil)
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
