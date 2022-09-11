//
//  KeyboardEventsDelegate.swift
//  help.me
//
//  Created by Karen Galoyan on 11/11/21.
//

import UIKit

public protocol KeyboardEventsDelegate: AnyObject {
    func keyboardDidChangeFrame(willShow: Bool, keyboardHeight: CGFloat, animationDuration: TimeInterval)
}
