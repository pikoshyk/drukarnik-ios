import Foundation

enum DKEmojiAutocompleteLexicon {
    private static let lock = NSLock()
    private static var cached: [String: [String]]?
    private static var loadBundle: Bundle = .main

    static var emojis: [String: [String]] {
        lock.lock()
        defer { lock.unlock() }
        if let cached {
            return cached
        }
        let loaded = parse(bundle: loadBundle)
        cached = loaded
        return loaded
    }

    static func parse(bundle: Bundle = .main) -> [String: [String]] {
        guard let fileUrl = bundle.url(forResource: "emoji", withExtension: "json"),
              let data = try? Data(contentsOf: fileUrl),
              let json = try? JSONDecoder().decode([String: String].self, from: data) else {
            return [:]
        }

        var dict: [String: [String]] = [:]
        dict.reserveCapacity(json.count)
        for (key, emojiStr) in json {
            dict[key] = emojiStr.components(separatedBy: " ")
        }
        return dict
    }

    static func resetForTesting(bundle: Bundle = .main) {
        lock.lock()
        cached = nil
        loadBundle = bundle
        lock.unlock()
    }
}
