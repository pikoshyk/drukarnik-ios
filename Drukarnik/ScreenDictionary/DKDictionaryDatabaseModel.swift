//
//  DKDictionaryDatabaseModel.swift
//  Drukarnik
//
//  Created by Logout on 1.05.24.
//

import Foundation
import GRDB

enum DKWordDictionaryType {
    case rus
    case bel
    case unknown
}

protocol DKWordModel: Identifiable, Equatable {
    var id: Int {get set}
    var word: String {get set}
    
    var dictionaryType: DKWordDictionaryType {get}
}

extension DKWordModel {
    var dictionaryType: DKWordDictionaryType {
        if self is DKWordRus {
            return .rus
        } else if self is DKWordBel {
            return .bel
        } else {
            return .unknown
        }
    }
}

struct DKWordRus: Codable, FetchableRecord, PersistableRecord, DKWordModel, Identifiable {
    var id: Int
    var word: String
}

struct DKWordBel: Codable, FetchableRecord, PersistableRecord, DKWordModel, Identifiable {
    var id: Int
    var word: String
}

class DKDictionaryDatabaseModel: Any {
    private let db: DatabaseQueue
    init() {
        let filename = Bundle.main.path(forResource: "rusbel.db", ofType: nil)!
        self.db = try! DatabaseQueue(path:filename)
    }
    
    private static let MAX_WORDS_COUNT = 60
    private static let OPTIMIZED_CHARS = [
        "щ": "ў",
        "у": "ў",
        "и": "і",
        "ь": "‘",
        "ъ": "‘",
        "'": "‘",
        "❛": "‘",
        "❜": "‘",
        "`": "‘",
        "‛": "‘",
        "’": "‘",
        "е": "ё"
    ]

    private func optimizeWord(_ word: String) -> String {
        var newWord = word.lowercased()
        for key in Self.OPTIMIZED_CHARS.keys {
            let value = Self.OPTIMIZED_CHARS[key]!
            newWord = newWord.replacingOccurrences(of: key, with: value)
        }
        return newWord
    }
    
    func find(text: String) async -> [any DKWordModel] {
        guard text.count >= 3 else {
            return []
        }
        let optimizedText = self.optimizeWord(text)
        let searchText = "\(optimizedText)%"
        return await withCheckedContinuation { continuation in
            do {
                try self.db.read { database in
                    let rus_words = try? DKWordRus.fetchAll(database, sql: "SELECT * FROM rus WHERE optimized_word LIKE ? ORDER BY optimized_word LIMIT \(Self.MAX_WORDS_COUNT/2)", arguments: [searchText])
                    let bel_words = try? DKWordBel.fetchAll(database, sql: "SELECT * FROM bel WHERE optimized_word LIKE ? ORDER BY optimized_word LIMIT \(Self.MAX_WORDS_COUNT/2)", arguments: [searchText])
                    var words: [any DKWordModel] = rus_words ?? []
                    words.append(contentsOf: bel_words ?? [])
                    
                    words.sort { word1, word2 in
                        word1.word.lowercased() < word2.word.lowercased()
                    }
                    continuation.resume(returning: words)
                }
            } catch {
                continuation.resume(returning: [])
            }
        }
    }
}
