//
//  ProfileStatusType.swift
//  help.me
//
//  Created by Karen Galoyan on 1/30/22.
//

import Foundation
import UIKit

public enum ProfileStatusType: String {
    case bronze, silver, gold
    
    // MARK: Properties
    public var title: String {
        switch self {
            case .bronze: return Localization.profile_bronze.text
            case .silver: return Localization.profile_silver.text
            case .gold: return Localization.profile_gold.text
        }
    }
    
    public var color: UIColor {
        switch self {
            case .bronze: return .hex_B98538
            case .silver: return .hex_A6A6A6
            case .gold: return .hex_E1D491
        }
    }
}
