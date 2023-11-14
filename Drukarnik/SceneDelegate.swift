//
//  SceneDelegate.swift
//  Drukarnik
//
//  Created by Logout on 29.11.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    private func rootViewController(_ screne: UIScene) -> UIViewController? {
        guard let windowScene = screne as? UIWindowScene else {
            return nil
        }

        var window: UIWindow?
        if #available(iOS 15.0, *) {
            window = windowScene.keyWindow
        } else {
            window = windowScene.windows.filter {$0.isKeyWindow}.first
        }
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
            guard let viewController = self.topViewController(scene) else {
                return
            }
            BLBelarusianTransliterationChoiceViewController.choiceInterfaceTransliteration(viewController: viewController) { interfaceTransliteration in
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
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

