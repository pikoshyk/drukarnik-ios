import XCTest

final class DKEmojiModelCatalogInvariantTests: XCTestCase {
    func testEachIOSCatalogPreservesAllEmojiFromTheNextOlderCatalog() throws {
        let sourceURL = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Keyboard/Keyboards/Emoji/DKEmojiModel.swift")
        let source = try String(contentsOf: sourceURL, encoding: .utf8)
        let snapshots = DKEmojiModelCatalogTestParser.snapshots(from: source)
        XCTAssertGreaterThanOrEqual(snapshots.count, 2)

        for index in 0 ..< snapshots.count - 1 {
            let newer = snapshots[index]
            let older = snapshots[index + 1]
            guard DKEmojiModelCatalogTestParser.isVersionAtLeast(
                older.version,
                minimum: DKEmojiModelCatalogTestParser.minimumOlderBranchForMonotonicInvariant
            ) else {
                continue
            }
            for category in DKEmojiModelCatalogTestParser.categoryNames {
                let olderEmoji = older.categories[category] ?? []
                let newerSet = Set(newer.categories[category] ?? [])
                let dropped = olderEmoji.filter { !newerSet.contains($0) }
                XCTAssertTrue(
                    dropped.isEmpty,
                    "iOS \(newer.version) lost \(dropped.count) emoji from iOS \(older.version) in \(category): \(dropped.prefix(5).joined(separator: ", "))"
                )
                XCTAssertGreaterThanOrEqual(
                    (newer.categories[category] ?? []).count,
                    olderEmoji.count,
                    "iOS \(newer.version) \(category) must not shrink vs iOS \(older.version)"
                )
            }
        }
    }
}

enum DKEmojiModelCatalogTestParser {
    static let minimumOlderBranchForMonotonicInvariant = "12.0"

    static let categoryNames = [
        "smileys",
        "nature",
        "fooddrink",
        "activity",
        "travelplaces",
        "objects",
        "symbols",
        "flags",
    ]

    struct Snapshot {
        let version: String
        let categories: [String: [String]]
    }

    static func snapshots(from source: String) -> [Snapshot] {
        let nsSource = source as NSString
        let markerPattern = try! NSRegularExpression(pattern: #"(?:if|else if) #available\(iOS ([0-9.]+), \*\)"#)
        let matches = markerPattern.matches(in: source, range: NSRange(location: 0, length: nsSource.length))
        return matches.enumerated().map { index, match in
            let version = nsSource.substring(with: match.range(at: 1))
            let blockStart = match.range.location
            let blockEnd = index + 1 < matches.count ? matches[index + 1].range.location : nsSource.length
            let block = nsSource.substring(with: NSRange(location: blockStart, length: blockEnd - blockStart))
            var categories: [String: [String]] = [:]
            for category in categoryNames {
                categories[category] = emoji(in: block, category: category)
            }
            return Snapshot(version: version, categories: categories)
        }
    }

    private static func emoji(in block: String, category: String) -> [String] {
        let prefix = "self.\(category) = ["
        guard let start = block.range(of: prefix) else { return [] }
        var index = start.upperBound
        var depth = 1
        var closingBracket = start.upperBound
        while index < block.endIndex {
            let character = block[index]
            if character == "[" {
                depth += 1
            } else if character == "]" {
                depth -= 1
                if depth == 0 {
                    closingBracket = index
                    break
                }
            }
            index = block.index(after: index)
        }
        guard depth == 0 else { return [] }
        let arrayBody = block[start.upperBound ..< closingBracket]
        let literalPattern = try! NSRegularExpression(pattern: #""((?:\\.|[^"\\])*)""#)
        let nsBody = String(arrayBody) as NSString
        return literalPattern.matches(in: String(arrayBody), range: NSRange(location: 0, length: nsBody.length)).map {
            nsBody.substring(with: $0.range(at: 1))
        }
    }

    static func isVersionAtLeast(_ version: String, minimum: String) -> Bool {
        let versionParts = parseVersionComponents(version)
        let minimumParts = parseVersionComponents(minimum)
        let count = max(versionParts.count, minimumParts.count)
        for index in 0 ..< count {
            let versionPart = index < versionParts.count ? versionParts[index] : 0
            let minimumPart = index < minimumParts.count ? minimumParts[index] : 0
            if versionPart != minimumPart {
                return versionPart > minimumPart
            }
        }
        return true
    }

    private static func parseVersionComponents(_ version: String) -> [Int] {
        version.split(separator: ".").map { Int($0) ?? 0 }
    }
}
