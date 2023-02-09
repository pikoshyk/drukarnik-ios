//
//  DKConverterTableViewController.swift
//  Drukarnik
//
//  Created by Logout on 3.02.23.
//

import BelarusianLacinka
import UIKit

class DKConverterTableViewController: UITableViewController {
    
    @IBOutlet var cellOptions: DKConverterOptionsTableViewCell!
    @IBOutlet var cellCyrillicText: DKConverterGrowingTableViewCell!
    @IBOutlet var cellLatinText: DKConverterGrowingTableViewCell!

    var converterVersion: BelarusianLacinka.BLVersion = .traditional
    var converterOrthography: BelarusianLacinka.BLOrthography = .academic
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLocalization()
        self.cellCyrillicText.delegate = self
        self.cellLatinText.delegate = self
        self.cellOptions.delegate = self
    }
    
    func updateConversion() {
        var direction = BelarusianLacinka.BLDirection.toLacin
        if self.cellLatinText.textView.isFirstResponder {
            direction = .toCyrillic
        }
        if direction == .toLacin {
            let text = " " + (self.cellCyrillicText.textView.text ?? "")
            var convertedText = DKKeyboardSettings.shared.lacinkaConverter.convert(text: text, direction: .toLacin, version: self.converterVersion, orthograpy: self.converterOrthography)
            convertedText.removeFirst()
            self.cellLatinText.textView.text = convertedText
        } else {
            let text = " " + (self.cellLatinText.textView.text ?? "")
            var convertedText = DKKeyboardSettings.shared.lacinkaConverter.convert(text: text, direction: .toCyrillic, version: self.converterVersion, orthograpy: self.converterOrthography)
            convertedText.removeFirst()
            self.cellCyrillicText.textView.text = convertedText
        }
    }

}

extension DKConverterTableViewController {
    func setupLocalization() {
        NotificationCenter.default.addObserver(forName: .interfaceChanged, object: nil, queue: .main) { notification in
            self.updateInterfaceLocalization()
        }
        self.updateInterfaceLocalization()
    }

    func updateInterfaceLocalization() {
        self.navigationItem.title = DKLocalizationApp.converterTitleFull
        self.cellOptions.updateInterfaceLocalization()
        self.cellLatinText.updateInterfaceLocalization()
        self.cellCyrillicText.updateInterfaceLocalization()
    }

}

extension DKConverterTableViewController: DKConverterGrowingTableViewCellProtocol {
    // Update height of UITextView based on string height
    func updateHeightOfRow(_ cell: DKConverterGrowingTableViewCell, _ textView: UITextView) {
        self.updateConversion()
        let size = textView.bounds.size
        let newSize = self.tableView.sizeThatFits(CGSize(width: size.width,
                                                        height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            self.tableView?.beginUpdates()
            self.tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            // Scoll up your textview if required
            if let thisIndexPath = self.tableView.indexPath(for: cell) {
                self.tableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
        
    }
}


extension DKConverterTableViewController: DKConverterOptionsDelegate {

    func onConverterOptionsUpdate(version: BelarusianLacinka.BLVersion, orthography: BelarusianLacinka.BLOrthography) {
        self.converterVersion = version
        self.converterOrthography = orthography
        self.updateConversion()
    }
    
}
