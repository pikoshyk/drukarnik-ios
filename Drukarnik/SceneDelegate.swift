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

    func askInterfaceTransliteration(windowScene: UIWindowScene, interval: TimeInterval = 1.0) {

        var window: UIWindow?
        if #available(iOS 15.0, *) {
            window = windowScene.keyWindow
        } else {
            window = windowScene.windows.filter {$0.isKeyWindow}.first
        }
        guard let viewController = window?.rootViewController else {
            return
        }

        if DKKeyboardSettings.shared.interfaceTransliteration != nil {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            BLBelarusianTransliterationChoiceViewController.choiceInterfaceTransliteration(viewController: viewController) { interfaceTransliteration in
                DKKeyboardSettings.shared.interfaceTransliteration = interfaceTransliteration
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.

        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.askInterfaceTransliteration(windowScene: windowScene)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

