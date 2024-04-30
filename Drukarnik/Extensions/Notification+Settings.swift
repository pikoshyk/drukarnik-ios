//
//  File.swift
//  Drukarnik
//
//  Created by Logout on 30.04.24.
//

import Foundation

extension Notification.Name {
    static let interfaceChanged = Notification.Name("interfaceChanged")
    static let interfaceTransliterationChanged = Notification.Name("interfaceTransliterationChanged")
    static let belarusianLatinTypeChanged = Notification.Name("belarusianLatinTypeChanged")
    static let belarusianCyrillicTypeChanged = Notification.Name("belarusianCyrillicTypeChanged")
    static let converterVersionChanged = Notification.Name("converterVersionChanged")
    static let converterOrthographyChanged = Notification.Name("converterOrthographyChanged")
    static let shareTypingDataChanged = Notification.Name("shareTypingDataChanged")
    static let keyboardInstallationCompletedChanged = Notification.Name("keyboardInstallationCompletedChanged")
}
