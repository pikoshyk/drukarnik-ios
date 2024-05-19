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

struct DKContentModel: Codable, FetchableRecord, PersistableRecord, Identifiable {
    var id: Int
    var html: String
}

protocol DKWordModel: Identifiable, Equatable {
    var id: Int {get set}
    var word: String {get set}
    
    var dictionaryType: DKWordDictionaryType {get}
    func translationContent(_ db: DatabaseQueue) async -> [DKWordTranslation]
    func translation(_ db: DatabaseQueue) async -> [any DKWordModel]
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
    static func == (lhs: DKWordRus, rhs: DKWordRus) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: Int
    var word: String
    var content_id: Int
}

extension DKWordRus {
    func content(_ db: DatabaseQueue) async -> DKContentModel? {
        await withCheckedContinuation { continuation in
            do {
                try db.read { database in
                    let content = try? DKContentModel.fetchOne(database, sql: "SELECT * FROM content WHERE id = ?;", arguments: [self.content_id])
                    continuation.resume(returning: content)
                }
            } catch {
                continuation.resume(returning: nil)
            }
        }
    }
}

extension DKWordRus {
    
    func translationContent(_ db: DatabaseQueue) async -> [DKWordTranslation] {
        let content = await self.content(db)
        let translations = [ DKWordTranslation(word: self, content: content) ]
        return translations
    }

    func translation(_ db: DatabaseQueue) async -> [any DKWordModel] {
        await withCheckedContinuation { continuation in
            do {
                try db.read { database in
                    let rus_words = try? DKWordRus.fetchAll(database, sql: "SELECT bel.* FROM bel INNER JOIN translation ON ? == translation.rus_id AND bel.id == translation.bel_id GROUP BY bel.id ORDER BY bel.word COLLATE NOCASE;", arguments: [self.id])
                    continuation.resume(returning: rus_words ?? [])
                }
            } catch {
                continuation.resume(returning: [])
            }
        }
    }
}

struct DKWordBel: Codable, FetchableRecord, PersistableRecord, DKWordModel, Identifiable {
    var id: Int
    var word: String
}

struct DKWordTranslation {
    var word: DKWordRus
    var content: DKContentModel?
}

extension DKWordBel {
    func translationContent(_ db: DatabaseQueue) async -> [DKWordTranslation] {
        let words = await withCheckedContinuation { continuation in
            do {
                try db.read { database in
                    let rus_words = try? DKWordRus.fetchAll(database, sql: "SELECT rus.* FROM rus INNER JOIN translation ON ? == translation.bel_id AND rus.id == translation.rus_id GROUP BY rus.id ORDER BY rus.word COLLATE NOCASE;", arguments: [self.id])
                    continuation.resume(returning: rus_words ?? [])
                }
            } catch {
                continuation.resume(returning: [])
            }
        }
        
        var translationContent: [DKWordTranslation] = []
        for word in words {
            let content = await word.content(db)
            let translation = DKWordTranslation(word: word, content: content)
            translationContent.append(translation)
        }
        return translationContent
    }

    func translation(_ db: DatabaseQueue) async -> [any DKWordModel] {
        await withCheckedContinuation { continuation in
            do {
                try db.read { database in
                    let rus_words = try? DKWordRus.fetchAll(database, sql: "SELECT rus.* FROM rus INNER JOIN translation ON ? == translation.bel_id AND rus.id == translation.rus_id GROUP BY rus.id ORDER BY rus.word COLLATE NOCASE;", arguments: [self.id])
                    continuation.resume(returning: rus_words ?? [])
                }
            } catch {
                continuation.resume(returning: [])
            }
        }
    }
}

class DKDictionaryDatabaseModel: Any {
    let db: DatabaseQueue
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
