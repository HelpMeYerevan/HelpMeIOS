//
//  WorkerModel.swift
//  help.me
//
//  Created by Karen Galoyan on 11/25/21.
//

import UIKit

public struct WorkerModel {
    
    // MARK: Properties
    public var image: UIImage?
    public var workerName: String
    public var categoryTitle: String
    public var isVerified: Bool
    public var rating: Double
    
    public var size: CGSize {
        let height = 126 / 667 * UIScreen.main.bounds.height
        return CGSize(width: 77 / 126 * height, height: height)
    }
}
