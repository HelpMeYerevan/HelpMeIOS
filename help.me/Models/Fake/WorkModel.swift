//
//  WorkModel.swift
//  help.me
//
//  Created by Karen Galoyan on 11/25/21.
//

import UIKit

public struct WorkModel {
    
    // MARK: Properties
    public var image: UIImage?
    public var categoryTitle: String
    public var workerName: String
    public var time: String
    
    public var size: CGSize {
        let height = 114 / 667 * UIScreen.main.bounds.height
        return CGSize(width: 84 / 114 * height, height: height)
    }
}
