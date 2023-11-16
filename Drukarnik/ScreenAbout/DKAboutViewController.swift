//
//  DKAboutViewController.swift
//  Keyboard
//
//  Created by Logout on 23.12.22.
//

import UIKit

class DKAboutViewController: UIViewController {

    @IBOutlet var labelDescription: UILabel!
    @IBOutlet var textViewSupport: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLocalization()
    }
    
    func updateSupportText() {
        let fontSize = 15.0
        let color = UIColor.secondaryLabel.webHexString()
        let opacity = UIColor.secondaryLabel.alpha
        let text = DKLocalizationApp.aboutSupportHtml
        let html = "<html><body style=\"font-size: \(fontSize); color: \(color); font-family: -apple-system;\">" + text + "</body></html>"
        self.textViewSupport.text = ""
        self.textViewSupport.alpha = opacity
        if let textData = html.data(using: .utf8) {
            DispatchQueue.main.async {
                let attributedString = try? NSAttributedString.string(htmlData: textData)
                self.textViewSupport.attributedText = attributedString
            }
        }
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

extension DKAboutViewController {
    
    func setupLocalization() {
        NotificationCenter.default.addObserver(forName: .interfaceChanged, object: nil, queue: .main) { notification in
            self.updateInterfaceLocalization()
        }
        self.updateInterfaceLocalization()
    }

    func updateInterfaceLocalization() {
        self.navigationItem.title = DKLocalizationApp.aboutTitle
        self.labelDescription.text = DKLocalizationApp.aboutDescription
        self.updateSupportText()
    }
}
