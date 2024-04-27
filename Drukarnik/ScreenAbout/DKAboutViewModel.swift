//
//  DKAboutViewModel.swift
//  Drukarnik
//
//  Created by Logout on 27.04.24.
//

import Foundation
import Combine

class DKAboutViewModel: ObservableObject {
#warning("TODO: Fix auto-transliteration for navigation title")
    var presentNavigationTitle: String {
        DKLocalizationApp.aboutTitle
    }
    
#warning("TODO: Fix auto-transliteration for about description")
    var presentAppDescription: String {
        DKLocalizationApp.aboutDescription
    }
}
