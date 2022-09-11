//
//  Story.swift
//  help.me
//
//  Created by Karen Galoyan on 1/30/22.
//

import Foundation
import CoreGraphics
import UIKit.UIScreen
import UIKit.UIImage

public class Story: Codable {
    
    // MARK: Properies
    public let id: Int?
    private let _title: String?
    private let _description: String?
    private let imageName: String?
    public let link: String?
    public let createdAt: String?
    
    public var size: CGSize {
        let height = 130 / 667 * UIScreen.main.bounds.height
        return CGSize(width: 84 / 130 * height, height: height)
    }
    public var title: String? {
        return _title?.capitalized
    }
    public var description: String? {
        return _description?.capitalized
    }
    public var imageURL: String {
        return "\(ConfigDataProvider.baseURL)/\(imageName ?? "")"
    }
    public var originaImage: UIImage? 
    public var thumbnailImage: UIImage?
    public var indexPath: IndexPath?
    public var isStoryVisible: Bool {
        return indexPath != nil
    }

    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case _title = "title"
        case _description = "description"
        case imageName = "image"
        case link = "link"
        case createdAt = "created_at"
    }
    
    // MARK: Initialization
    public init(id: Int?, title: String?, description: String?, imageName: String?, link: String?, createdAt: String?) {
        self.id = id
        self._title = title
        self._description = description
        self.imageName = imageName
        self.link = link
        self.createdAt = createdAt
    }
}
