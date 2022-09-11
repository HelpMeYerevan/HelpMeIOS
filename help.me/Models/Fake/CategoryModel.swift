//
//  CategoryModel.swift
//  help.me
//
//  Created by Karen Galoyan on 11/25/21.
//

import UIKit

public struct CategoryModel {
    
    // MARK: Properties
    public var title: String
    
    public var size: CGSize {
        let height = 24 / 667 * UIScreen.main.bounds.height
        let width = title.width(withConstrainedHeight: height, font: .robotoRegularFont(ofSize: 11)) + 12
        return CGSize(width: width, height: height)
    }
}
