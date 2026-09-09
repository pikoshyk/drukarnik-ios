import Foundation

struct DKKeyboardLayoutApplicator {
    private(set) var appliedLayout: DKKeyboardLayout?
    private(set) var layoutChangeCount = 0

    mutating func applyLayout(_ layout: DKKeyboardLayout, force: Bool = false) -> Bool {
        if !force, appliedLayout == layout {
            return false
        }
        appliedLayout = layout
        layoutChangeCount += 1
        return true
    }
}
