//
//  Category.swift
//  help.me
//
//  Created by Karen Galoyan on 12/26/21.
//

import Foundation
import CoreGraphics
import UIKit.UIScreen

public class Category: Codable {
    
    // MARK: Properties
    public let id: Int?
    public let parentID: Int?
    public let image: String?
    public let createdAt: String?
    public let updatedAt: String?
    public let translate: CategoryTranslate?
    public var subCategories: [Category]?
    
    public var isSelected = false
    public var isExpanded = false
    
    public var size: CGSize {
        let height = 24 / 667 * UIScreen.main.bounds.height
        let width = (translate?.name?.width(withConstrainedHeight: height, font: .systemFont(ofSize: 11)) ?? 0) + 12
        return CGSize(width: width, height: height)
    }
    
    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case parentID = "parent_id"
        case image = "image"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case translate = "translate"
        case subCategories = "sub_categories"
    }
}
