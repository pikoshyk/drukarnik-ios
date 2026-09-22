import Foundation

enum DKKeyboardEmojiRecents {
    static let maxRecentsCount = 32
    static let maxUsageDatesPerEmoji = 10

    static func record(
        emoji: String,
        in recents: [DKKeyboardEmojiRecentsItem],
        now: Date = Date()
    ) -> [DKKeyboardEmojiRecentsItem] {
        var recents = recents
        if let emojiItem = recents.first(where: { $0.emoji == emoji }) {
            emojiItem.usage.insert(now, at: 0)
            if emojiItem.usage.count > maxUsageDatesPerEmoji {
                emojiItem.usage.removeLast()
            }
        } else {
            let item = DKKeyboardEmojiRecentsItem(emoji: emoji, usage: [now])
            recents.insert(item, at: 0)
        }

        recents.sort { item1, item2 in
            item1.usage.first! > item2.usage.first!
        }

        if recents.count > maxRecentsCount {
            recents.removeLast(recents.count - maxRecentsCount)
        }

        return recents
    }
}
