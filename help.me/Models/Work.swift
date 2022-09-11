//
//  Work.swift
//  help.me
//
//  Created by Karen Galoyan on 1/30/22.
//

import Foundation
import CoreGraphics
import UIKit.UIScreen

public class Work: Codable {
    
    // MARK: Properties
    public let address: String?
    private let _workDescription: String?
    private let imageName: String?
    private let _price: Double?
    public let lat: Double?
    public let long: Double?
    public let category: Category?
    public let perPage: Int?
    public let currentPage: Int?
    public let createdAt: String?
    public let translate: CategoryTranslate?
    
    public var size: CGSize {
        let height = 114 / 667 * UIScreen.main.bounds.height
        return CGSize(width: 84 / 114 * height, height: height)
    }
    public var imageURL: String {
        return "\(ConfigDataProvider.baseURL)/\(imageName ?? "")"
    }
    public var workDescription: String? {
        return _workDescription?.capitalized
    }
    public var price: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return (formatter.string(from: NSNumber(value: _price ?? 0)) ?? "0.00") + " AMD"
    }
    public var originalImage: UIImage?
    public var thumbnailImage: UIImage?

    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case address = "address"
        case _workDescription = "description"
        case imageName = "image"
        case _price = "price"
        case lat = "lat"
        case long = "long"
        case category = "category"
        case perPage = "perPage"
        case currentPage = "currentPage"
        case createdAt = "created_at"
        case translate = "categoryTranslates"
    }

    // MARK: Initialization
    public init(address: String?, workDescription: String?, imageName: String?, price: Double?, lat: Double?, long: Double?, category: Category?, perPage: Int?, currentPage: Int?, createdAt: String?, translate: CategoryTranslate?) {
        self.address = address
        self._workDescription = workDescription
        self.imageName = imageName
        self._price = price
        self.lat = lat
        self.long = long
        self.category = category
        self.perPage = perPage
        self.currentPage = currentPage
        self.createdAt = createdAt
        self.translate = translate
    }
}
