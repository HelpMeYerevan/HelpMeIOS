//
//  UIButton.swift
//  help.me
//
//  Created by Karen Galoyan on 1/28/22.
//

import UIKit

extension UIButton {
    
    // MARK: Initialization
    convenience public init(for activityType: ActivityType) {
        self.init(frame: .zero)
        isSelected = activityType.isSelected
        setTitle(activityType.translate.name.capitalized, for: .normal)
        setTitle(activityType.translate.name.capitalized, for: .selected)
        titleLabel?.font = .robotoMediumFont(ofSize: 12)
        let color = UIColor.hex_292929.withAlphaComponent(0.6)
        backgroundColor = isSelected ? color : .hex_FFFFFF
        setBorder(withColor: color, andWidth: isSelected ? 0 : 1)
        setTitleColor(color, for: .normal)
        setTitleColor(.white, for: .selected)
        setCornerRadius(8)
    }
    
    public func setEnabled(_ isEnabled: Bool) {
        self.isEnabled = isEnabled
        self.alpha = isEnabled ? 1 : 0.5
    }
}
