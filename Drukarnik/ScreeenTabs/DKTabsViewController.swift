//
//  DKTabsViewController.swift
//  Drukarnik
//
//  Created by Logout on 1.05.24.
//

import SwiftUI
import UIKit

class DKTabsViewController: UIHostingController<DKTabsView> {
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder, rootView: DKTabsView(viewModel: DKTabsViewModel()))
    }
}
