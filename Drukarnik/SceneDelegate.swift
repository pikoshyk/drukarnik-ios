//
//  SceneDelegate.swift
//  Drukarnik
//
//  Created by Logout on 29.11.22.
//

import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var appViewModel: DKAppViewModel?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        let viewModel = DKAppViewModel()
        self.appViewModel = viewModel
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: DKAppView(viewModel: viewModel))
        window.makeKeyAndVisible()
        self.window = window
    }

    func askInterfaceTransliteration(interval: TimeInterval = 0.5) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            guard let appViewModel = self.appViewModel else {
                DKKeyboardSettings.shared.interfaceTransliteration = DKKeyboardSettings.shared.defaultInterfaceTransliteration
                return
            }
            appViewModel.requestTransliterationChoice { interfaceTransliteration in
                DKKeyboardSettings.shared.interfaceTransliteration = interfaceTransliteration
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        if DKKeyboardSettings.shared.interfaceTransliteration == nil {
            self.askInterfaceTransliteration()
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        self.appViewModel?.refreshInstallationVisibility()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }

}
