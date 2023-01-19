//
//  DKAboutViewController.swift
//  Keyboard
//
//  Created by Logout on 23.12.22.
//

import UIKit

class DKAboutViewController: UIViewController {

    @IBOutlet var labelSubscriptionDeveloper: UILabel!
    @IBOutlet var labelDescription: UILabel!
    @IBOutlet var textViewSupport: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = DKLocalization.aboutTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: DKLocalization.aboutDone, style: .done, target: self, action: #selector(self.onDismiss))

        self.labelSubscriptionDeveloper.text = DKLocalization.aboutSubscriptionDeveloper
        self.labelDescription.text = DKLocalization.aboutDescription
        self.updateSupportText()
    }
    
    func updateSupportText() {
        let fontSize = 15.0
        let color = UIColor.secondaryLabel.webHexString()
        let opacity = UIColor.secondaryLabel.alpha
        let text = DKLocalization.aboutSupportHtml
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
    
    @objc func onDismiss() {
        self.dismiss(animated: true)
    }
    
    func openTwitterAccount(account: String) {
        let urlStr = "https://twitter.com/\(account)"
        if let url = URL(string: urlStr) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func onDeveloper() {
        self.openTwitterAccount(account: "pikoshyk")
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
