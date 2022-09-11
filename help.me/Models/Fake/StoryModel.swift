//
//  StoryModel.swift
//  help.me
//
//  Created by Karen Galoyan on 11/25/21.
//

import UIKit

public struct StoryModel {
    
    // MARK: Properties
    public var image: UIImage?
    public var title: String
    
    public var size: CGSize {
        let height = 130 / 667 * UIScreen.main.bounds.height
        return CGSize(width: 84 / 130 * height, height: height)
    }
}
