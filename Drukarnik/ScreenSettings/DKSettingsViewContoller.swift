//
//  DKSettingsViewContoller.swift
//  Drukarnik
//
//  Created by Logout on 27.04.24.
//

import UIKit
import SwiftUI

class DKSettingsViewController: UIHostingController<DKSettingsView> {

    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder, rootView: DKSettingsView(viewModel: DKSettingsViewModel()))
    }
}
