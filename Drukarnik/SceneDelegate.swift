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
    private var tabsViewModel: DKTabsViewModel?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        let viewModel = DKTabsViewModel()
        self.tabsViewModel = viewModel
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: DKTabsView(viewModel: viewModel))
        window.makeKeyAndVisible()
        self.window = window
    }

    private func rootViewController(_ screne: UIScene) -> UIViewController? {
        if let window = self.window, window.rootViewController != nil {
            return window.rootViewController
        }
        guard let windowScene = screne as? UIWindowScene else {
            return nil
        }

        let window = windowScene.keyWindow
        guard let viewController = window?.rootViewController else {
            return nil
        }
        return viewController
    }

    private func topViewController(_ scene: UIScene) -> UIViewController? {
        var viewController = self.rootViewController(scene)
        while let presentedViewController = viewController?.presentedViewController {
            viewController = presentedViewController
        }
        return viewController
    }

    func showKeyboardInstllationGuide(_ scene: UIScene) {
        guard let viewController = self.rootViewController(scene) else {
            return
        }
        DKInstallationNavigationController.show(on: viewController)
    }

    func askInterfaceTransliteration(_ scene: UIScene, interval: TimeInterval = 0.5) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            guard let tabsViewModel = self.tabsViewModel else {
                DKKeyboardSettings.shared.interfaceTransliteration = DKKeyboardSettings.shared.defaultInterfaceTransliteration
                return
            }
            tabsViewModel.requestTransliterationChoice { interfaceTransliteration in
                DKKeyboardSettings.shared.interfaceTransliteration = interfaceTransliteration
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        if DKKeyboardSettings.shared.interfaceTransliteration == nil {
            self.askInterfaceTransliteration(scene)
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        if DKKeyboardSettings.isKeyboardActivated() == false &&
            DKKeyboardSettings.shared.keyboardInstallationCompleted == false {
            self.showKeyboardInstllationGuide(scene)
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }

}
