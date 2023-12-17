//
//  DKAppstoreReviewController.swift
//  Drukarnik
//
//  Created by Logout on 17.12.23.
//

import StoreKit
import Foundation
import UIKit

class DKAppstoreReviewController: Any {
    
    static let opensCountKey = "DKAppstoreReviewController.opensCount"
    static let lastVersionPromptedKey = "DKAppstoreReviewController.lastVersionPrompted"
    static let maxCount = 4
    
    class func requestReview() {
        
        let lastVersionPromptedForReview = UserDefaults.standard.string(forKey: self.lastVersionPromptedKey) ?? ""
        let infoDictionaryKey = kCFBundleVersionKey as String
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String
            else { fatalError("Expected to find a bundle version in the info dictionary.") }

        if currentVersion == lastVersionPromptedForReview {
            return
        }
        
        let count = 1 + UserDefaults.standard.integer(forKey: self.opensCountKey)
        UserDefaults.standard.set(count, forKey: self.opensCountKey)
        UserDefaults.standard.synchronize()

         // Verify the user completes the process several times and doesn’t receive a prompt for this app version.
        if count >= self.maxCount {
            Task {
                // Delay for two seconds to avoid interrupting the person using the app.
                try? await Task.sleep(nanoseconds: 5 * 1000)

                if await UIApplication.shared.applicationState != .active {
                    return
                }

                if let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    await SKStoreReviewController.requestReview(in: windowScene)
                    UserDefaults.standard.set(0, forKey: self.opensCountKey)
                    UserDefaults.standard.set(currentVersion, forKey: self.lastVersionPromptedKey)
                    UserDefaults.standard.synchronize()
               }
            }
        }
    }
}
