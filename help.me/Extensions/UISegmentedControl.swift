//
//  UISegmentedControl.swift
//  help.me
//
//  Created by Karen Galoyan on 11/15/21.
//

import Foundation
import UIKit

extension UISegmentedControl {
    
    // MARK: Methods
    public func fixBackgroundColor() {
        if #available(iOS 13.0, *) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                for i in 0...(self.numberOfSegments - 1)  {
                    let backgroundSegmentView = self.subviews[i]
                    backgroundSegmentView.alpha = 0.5
                }
            }
        }
    }
}
