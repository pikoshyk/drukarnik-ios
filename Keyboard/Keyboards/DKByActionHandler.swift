//
//  DKByCyrillicActionHandler.swift
//  Keyboard
//
//  Created by Logout on 11.12.22.
//

import UIKit
import KeyboardKit

class DKByActionHandler: StandardKeyboardActionHandler {
    var swicthKeyboardBlock: ((DKByKeyboardLayout) -> Void)?

    init(inputViewController ivc: KeyboardInputViewController, spaceDragGestureHandler: DragGestureHandler? = nil, spaceDragSensitivity: SpaceDragSensitivity = .medium, swicthKeyboardBlock: @escaping(DKByKeyboardLayout) -> Void) {
        super.init(inputViewController: ivc, spaceDragGestureHandler: spaceDragGestureHandler, spaceDragSensitivity: spaceDragSensitivity)
        self.swicthKeyboardBlock = swicthKeyboardBlock
    }
    
    /**
     Try to handling a certain `gesture` n a certain `action`.
     */
    open override func handle(_ gesture: KeyboardGesture, on action: KeyboardAction) {
        if gesture == .release {
            autoreleasepool {
                if action == .custom(named: DKByKeyboardLayout.latin.rawValue) {
                    self.swicthKeyboardBlock?(.latin)
                } else if action == .custom(named: DKByKeyboardLayout.cyrillic.rawValue) {
                    self.swicthKeyboardBlock?(.cyrillic)
                }
            }
        }
        super.handle(gesture, on: action)
    }
}
