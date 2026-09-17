import Foundation

enum DKCalloutStringCasing {
    static func uppercased(_ callout: String) -> String {
        callout
            .replacingOccurrences(of: "ß", with: "ẞ")
            .uppercased()
    }
}
