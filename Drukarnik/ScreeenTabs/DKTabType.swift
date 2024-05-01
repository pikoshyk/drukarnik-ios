//
//  DKTabType.swift
//  Drukarnik
//
//  Created by Logout on 1.05.24.
//

import Foundation

enum DKTabType {
    case dictionary
    case settings
    case converter
    case about

    var shortTitle: String {
        switch self {
        case .dictionary:
            DKLocalizationApp.dictionaryTitle
        case .settings:
            DKLocalizationApp.settingsTitle
        case .converter:
            DKLocalizationApp.converterTitle
        case .about:
            DKLocalizationApp.aboutTitle
        }
    }
    
    var fullTitle: String {
        switch self {
        case .dictionary:
            DKLocalizationApp.dictionaryTitleFull
        case .settings:
            DKLocalizationApp.settingsTitleFull
        case .converter:
            DKLocalizationApp.converterTitleFull
        case .about:
            DKLocalizationApp.aboutTitle
        }
    }
    
    var systemImage: String {
        switch self {
        case .dictionary:
            SystemImage.characterIcon
        case .settings:
            SystemImage.keyboardIcon
        case .converter:
            SystemImage.educationIcon
        case .about:
            SystemImage.informationIcon
        }
    }
}

extension DKTabType {
    struct SystemImage {
        static let characterIcon = "character.bubble.fill"
        static let keyboardIcon = "keyboard.fill"
        static let educationIcon = "graduationcap.fill"
        static let informationIcon = "info.circle.fill"
    }
}
