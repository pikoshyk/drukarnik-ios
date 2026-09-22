import Foundation

class DKKeyboardEmojiRecentsItem: Codable, Identifiable {
    var id: String { self.emoji }
    let emoji: String
    var usage: [Date]

    init(emoji: String, usage: [Date] = [Date()]) {
        self.emoji = emoji
        self.usage = usage
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.emoji = try container.decode(String.self, forKey: .emoji)
        self.usage = try container.decode([Date].self, forKey: .usage)
    }

    enum CodingKeys: CodingKey {
        case emoji
        case usage
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.emoji, forKey: .emoji)
        try container.encode(self.usage, forKey: .usage)
    }
}
