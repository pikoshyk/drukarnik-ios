//
//  BLBelarusianTransliterationChoiceViewController.swift
//  Drukarnik
//
//  Created by Logout on 25.12.22.
//

import BelarusianLacinka
import UIKit

class BLBelarusianTransliterationChoiceViewController: UIViewController {
    
    @IBOutlet fileprivate var labelTitle: UILabel!
    @IBOutlet fileprivate var labelHistory: UILabel!
    @IBOutlet fileprivate var labelAppeal: UILabel!
    @IBOutlet fileprivate var labelNote: UILabel!
    
    @IBOutlet fileprivate var segmentedTransliteration: UISegmentedControl!
    @IBOutlet fileprivate var buttonLatin: UIButton!
    @IBOutlet fileprivate var buttonCyrillic: UIButton!
    
    fileprivate var completeBlock: ((_ inetrfaceTransliteration: DKByKeyboardLayout) -> Void)?
    
    class func choiceInterfaceTransliteration(viewController: UIViewController, completeBlock: @escaping (_ inetrfaceTransliteration: DKByKeyboardLayout) -> Void) {
        let choiceViewController = BLBelarusianTransliterationChoiceViewController(nibName: "BLBelarusianTransliterationChoiceViewController", bundle: nil)
        choiceViewController.completeBlock = completeBlock
        viewController.present(choiceViewController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.segmentedTransliteration.setTitle(DKLocalization.transliterationSegmentedLatin, forSegmentAt: 0)
        self.segmentedTransliteration.setTitle(DKLocalization.transliterationSegmentedCyrillic, forSegmentAt: 1)

        self.buttonLatin.subtitleLabel?.text = DKLocalization.transliterationButtonLatinSubtitle
        self.buttonLatin.setTitle(DKLocalization.transliterationButtonLatinTitle, for: .normal)
        self.buttonCyrillic.subtitleLabel?.text = DKLocalization.transliterationButtonCyrillicSubtitle
        self.buttonCyrillic.setTitle(DKLocalization.transliterationButtonCyrillicTitle, for: .normal)

        self.updateInterface()
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
    
    fileprivate func updateInterface() {
        let direction: BLDirection = self.segmentedTransliteration.selectedSegmentIndex == 0 ? .toLacin : .toCyrillic
        self.labelTitle.text = DKLocalization.transliterationTitle(direction: direction)
        self.labelHistory.text = DKLocalization.transliterationHistory(direction: direction)
        self.labelAppeal.text = DKLocalization.transliterationAppeal(direction: direction)
        self.labelNote.text = DKLocalization.transliterationNote(direction: direction)
    }
    
    @IBAction fileprivate func onTransliterationCyrillic(_ button: UIButton?) {
        self.completeBlock?(.cyrillic)
        self.dismiss(animated: true)
    }

    @IBAction fileprivate func onTransliterationLatin(_ button: UIButton?) {
        self.completeBlock?(.latin)
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
