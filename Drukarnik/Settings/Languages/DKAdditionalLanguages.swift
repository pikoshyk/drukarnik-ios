//
//  DKAdditionalLanguages.swift
//  Drukarnik
//
//  Created by Logout on 24.01.23.
//

import UIKit

class DKAdditionalLanguages: Any {
    class func load() -> [DKAdditionalLanguage] {
        var languages: [DKAdditionalLanguage] = []
        guard let filePath = Bundle.main.path(forResource: "additional_languages", ofType: "json") else {
            return languages
        }
        guard let jsonData = FileManager.default.contents(atPath: filePath) else {
            return languages
        }
        
        languages = (try? JSONDecoder().decode([DKAdditionalLanguage].self, from: jsonData)) ?? []

        return languages
    }
}
