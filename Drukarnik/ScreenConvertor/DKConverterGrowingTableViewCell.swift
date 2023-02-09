//
//  DKConverterGrowingTableViewCell.swift
//  Drukarnik
//
//  Created by Logout on 6.02.23.
//

import UIKit

protocol DKConverterGrowingTableViewCellProtocol: AnyObject {
    func updateHeightOfRow(_ cell: DKConverterGrowingTableViewCell, _ textView: UITextView)
}

class DKConverterGrowingTableViewCell: UITableViewCell {

    static let textViewToolbarHeight: CGFloat = 44.0
    weak var delegate: DKConverterGrowingTableViewCellProtocol?
    @IBOutlet weak var textView: UITextView!
    var barDoneButton: UIBarButtonItem?

    override func awakeFromNib() {
        super.awakeFromNib()
//        self.textView.layer.cornerRadius = 5
//        self.textView.layer.borderColor = UIColor.quaternaryLabel.cgColor
//        self.textView.layer.borderWidth = 0.5
//        self.textView.clipsToBounds = true
        
        let barDoneButton = UIBarButtonItem(title: DKLocalizationApp.converterTextViewKeyboardDone, style: .plain, target: self, action: #selector(tapDone))
        self.barDoneButton = barDoneButton

        self.textView.delegate = self
        self.textView.addDoneButton(barDoneButton)

        self.updateInterfaceLocalization()
    }
    
    func updateInterfaceLocalization() {
        self.barDoneButton?.title = DKLocalizationApp.converterTextViewKeyboardDone
    }

    @objc func tapDone() {
        self.textView.endEditing(true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension DKConverterGrowingTableViewCell: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        if let deletate = self.delegate {
            deletate.updateHeightOfRow(self, textView)
        }
    }
}

extension UITextView {
    
    func addDoneButton(_ barButton: UIBarButtonItem) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: DKConverterGrowingTableViewCell.textViewToolbarHeight))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
}
