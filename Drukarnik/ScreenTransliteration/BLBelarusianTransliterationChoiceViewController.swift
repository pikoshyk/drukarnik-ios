//
//  BLBelarusianTransliterationChoiceViewController.swift
//  Drukarnik
//
//  Created by Logout on 25.12.22.
//

import BelarusianLacinka
import UIKit


class BLBelarusianTransliterationChoiceViewController: UIViewController {
    
    static var isCurrentlyDisplayed = false
    
    @IBOutlet fileprivate var labelTitle: UILabel!
    @IBOutlet fileprivate var labelHistory: UILabel!
    @IBOutlet fileprivate var labelAppeal: UILabel!
    @IBOutlet fileprivate var labelNote: UILabel!
    
    @IBOutlet fileprivate var segmentedTransliteration: UISegmentedControl!
    @IBOutlet fileprivate var buttonLatin: UIButton!
    @IBOutlet fileprivate var buttonCyrillic: UIButton!
    
    fileprivate var completeBlock: ((_ interfaceTransliteration: DKKeyboardLayout) -> Void)?
    
    class func choiceInterfaceTransliteration(viewController: UIViewController, completeBlock: @escaping (_ interfaceTransliteration: DKKeyboardLayout) -> Void) {

        if Self.isCurrentlyDisplayed {
            return
        }
        
        let choiceViewControllerNib = UINib(nibName: "BLBelarusianTransliterationChoiceViewController", bundle: nil)
        let choiceViewController = choiceViewControllerNib.instantiate(withOwner: self).first as? BLBelarusianTransliterationChoiceViewController
        choiceViewController?.completeBlock = completeBlock
        if let choiceViewController = choiceViewController {
            viewController.present(choiceViewController, animated: true)
        } else {
            completeBlock(DKKeyboardSettings.shared.defaultInterfaceTransliteration)
        }
        return
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.segmentedTransliteration.setTitle(DKLocalizationApp.transliterationSegmentedLatin, forSegmentAt: 0)
        self.segmentedTransliteration.setTitle(DKLocalizationApp.transliterationSegmentedCyrillic, forSegmentAt: 1)

        if #available(iOS 15.0, *) {
            self.buttonLatin.subtitleLabel?.text = DKLocalizationApp.transliterationButtonLatinSubtitle
            self.buttonCyrillic.subtitleLabel?.text = DKLocalizationApp.transliterationButtonCyrillicSubtitle
        } else {
            // Fallback on earlier versions
        }
        self.buttonLatin.setTitle(DKLocalizationApp.transliterationButtonLatinTitle, for: .normal)
        self.buttonCyrillic.setTitle(DKLocalizationApp.transliterationButtonCyrillicTitle, for: .normal)

        self.updateInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Self.isCurrentlyDisplayed = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.segmentedTransliteration.selectedSegmentIndex = 0
            self.updateInterface()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.segmentedTransliteration.selectedSegmentIndex = 1
                self.updateInterface()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        var transliteration: DKKeyboardLayout = .latin
        if self.segmentedTransliteration.selectedSegmentIndex == 0 {
            transliteration = .cyrillic
        }
        self.completeBlock?(transliteration)
        self.completeBlock = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Self.isCurrentlyDisplayed = false
    }
    
    fileprivate func updateInterface() {
        let direction: BLDirection = self.segmentedTransliteration.selectedSegmentIndex == 0 ? .toLacin : .toCyrillic
        self.labelTitle.text = DKLocalizationApp.transliterationTitle(direction: direction)
        self.labelHistory.text = DKLocalizationApp.transliterationHistory(direction: direction)
        self.labelAppeal.text = DKLocalizationApp.transliterationAppeal(direction: direction)
        self.labelNote.text = DKLocalizationApp.transliterationNote(direction: direction)
    }
    
    @IBAction fileprivate func onTransliterationCyrillic(_ button: UIButton?) {
        self.completeBlock?(.cyrillic)
        self.completeBlock = nil
        self.dismiss(animated: true)
    }

    @IBAction fileprivate func onTransliterationLatin(_ button: UIButton?) {
        self.completeBlock?(.latin)
        self.completeBlock = nil
        self.dismiss(animated: true)
    }

    @IBAction fileprivate func onTransliterationSegment(_ segmentedControl: UISegmentedControl?) {
        self.updateInterface()
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
