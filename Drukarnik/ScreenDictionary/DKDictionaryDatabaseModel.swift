//
//  DKDictionaryDatabaseModel.swift
//  Drukarnik
//
//  Created by Logout on 1.05.24.
//

import Foundation
import GRDB

protocol DKWord {
    var id: Int {get set}
    var word: String {get set}
}

struct DKWordRus: Codable, FetchableRecord, PersistableRecord, DKWord {
    var id: Int
    var word: String
}

struct DKWordBel: Codable, FetchableRecord, PersistableRecord, DKWord {
    var id: Int
    var word: String
}

class DKDictionaryDatabaseModel: Any {
    private let db: DatabaseQueue
    init() {
        let filename = Bundle.main.path(forResource: "rusbel.db", ofType: nil)!
        self.db = try! DatabaseQueue(path:filename)
    }
    
    func find(text: String) async -> [DKWord] {
        await withCheckedContinuation { continuation in
            do {
                try self.db.read { database in
                    let words = try? DKWordRus.fetchAll(database, sql: "SELECT * FROM rus WHERE word LIKE ?", arguments: [text])
                    continuation.resume(returning: words ?? [])
                }
            } catch {
                continuation.resume(returning: [])
            }
        }
    }
}
