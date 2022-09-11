//
//  KeyboardManager.swift
//  help.me
//
//  Created by Karen Galoyan on 11/11/21.
//

import UIKit

public final class KeyboardManager {
    
    // MARK: Properties
    private weak var delegate: KeyboardEventsDelegate?
    private var disableAnimation = false
    
    // MARK: Initialization
    init(delegate: KeyboardEventsDelegate, disableAnimation: Bool) {
        self.delegate = delegate
        self.disableAnimation = disableAnimation
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Keyboard events
    @objc private func keyboardWillShow(notification: NSNotification) {
        keyboardDidChangeFrame(willShow: true, notification: notification)
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        keyboardDidChangeFrame(willShow: false, notification: notification)
        if disableAnimation {
            UIView.setAnimationsEnabled(false)
        }
    }
    
    @objc private func keyboardDidHide(notification: NSNotification) {
        UIView.setAnimationsEnabled(true)
    }
    
    private func keyboardDidChangeFrame(willShow: Bool, notification: NSNotification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.3
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            delegate?.keyboardDidChangeFrame(willShow: willShow, keyboardHeight: keyboardSize.height, animationDuration: duration)
        }
    }
}
