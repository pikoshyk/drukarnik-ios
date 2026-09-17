//
//  DKInstallationView.swift
//  Drukarnik
//

import SwiftUI

struct DKInstallationView: UIViewControllerRepresentable {
    var onKeyboardActivated: () -> Void

    func makeUIViewController(context: Context) -> DKInstallationNavigationController {
        let controller = DKInstallationNavigationController.make()
        controller.onKeyboardActivated = self.onKeyboardActivated
        return controller
    }

    func updateUIViewController(_ uiViewController: DKInstallationNavigationController, context: Context) {
        uiViewController.onKeyboardActivated = self.onKeyboardActivated
    }
}
