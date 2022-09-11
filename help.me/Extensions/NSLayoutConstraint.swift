//
//  NSLayoutConstraint.swift
//  help.me
//
//  Created by Karen Galoyan on 11/16/21.
//

import UIKit

extension NSLayoutConstraint {
    
    // MARK: Methods
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
