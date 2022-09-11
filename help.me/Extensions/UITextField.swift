//
//  UITextField.swift
//  help.me
//
//  Created by Karen Galoyan on 11/11/21.
//

import Foundation
import UIKit

extension UITextField {
    
    // MARK: Methods
    public func setHorizontalInsets(left: CGFloat, right: CGFloat) {
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.height))
        self.leftViewMode = .always
        self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.height))
        self.rightViewMode = .always
    }
}
