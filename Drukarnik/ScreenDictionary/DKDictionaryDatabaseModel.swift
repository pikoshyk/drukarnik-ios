//
//  DKDictionaryDatabaseModel.swift
//  Drukarnik
//
//  Created by Logout on 1.05.24.
//

import Foundation
import GRDB

protocol DKWordModel: Identifiable, Equatable {
    var id: Int {get set}
    var word: String {get set}
}

struct DKWordRus: Codable, FetchableRecord, PersistableRecord, DKWordModel, Identifiable {
    var id: Int
    var word: String
}

struct DKWordBel: Codable, FetchableRecord, PersistableRecord, TableRecord, DKWordModel, Identifiable {
    var databaseTableName = "rus"
    var id: Int
    var word: String
}

class DKDictionaryDatabaseModel: Any {
    private let db: DatabaseQueue
    init() {
        let filename = Bundle.main.path(forResource: "rusbel.db", ofType: nil)!
        self.db = try! DatabaseQueue(path:filename)
    }
    
    func find(text: String) async -> [any DKWordModel] {
        guard text.count >= 3 else {
            return []
        }
        let searchText = "\(text.lowercased())%"
        return await withCheckedContinuation { continuation in
            do {
                try self.db.read { database in
                    let words = try? DKWordRus.fetchAll(database, sql: "SELECT * FROM rus WHERE word LIKE ? ORDER BY word LIMIT 30", arguments: [searchText])
//                    let words = try? DKWordRus.fetchAll(database, sql: "SELECT * FROM rus LIMIT 30")
                    continuation.resume(returning: words ?? [])
                }
            } catch {
                continuation.resume(returning: [])
            }
        }
    }
}
