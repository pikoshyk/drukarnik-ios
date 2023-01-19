//
//  ViewController.swift
//  Drukarnik
//
//  Created by Logout on 29.11.22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            BLBelarusianTransliterationChoiceViewController.choiceInterfaceTransliteration(viewController: self) { inetrfaceTransliteration in
                
            }
        }
    }


}

