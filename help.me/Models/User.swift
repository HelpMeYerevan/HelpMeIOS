//
//  User.swift
//  help.me
//
//  Created by Karen Galoyan on 2/6/22.
//

import Foundation
import CoreGraphics
import UIKit.UIScreen

public class User: Codable {
    
    // MARK: Propeties
    private let _rating: Double?
    public let categoryID: Int?
    public let name: String?
    public let email: String?
    private let _avatarName: String?
    public let phone: String?
    public let balance: Int?
    public let categoryName: String?

    public var size: CGSize {
        let height = 126 / 667 * UIScreen.main.bounds.height
        return CGSize(width: 77 / 126 * height, height: height)
    }
    public var avatarName: String {
        return "\(_avatarName ?? "")"
    }
    public var avatarURL: String {
        return "\(ConfigDataProvider.baseURL)/\(_avatarName ?? "")"
    }
    public var originaImage: UIImage?
    public var thumbnailImage: UIImage?
    public var rating: Double {
        return _rating ?? 0
    }
    
    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case _rating = "rating"
        case categoryID = "category_id"
        case name = "name"
        case email = "email"
        case _avatarName = "avatar"
        case phone = "phone"
        case balance = "balance"
        case categoryName = "category_name"
    }

    // MARK: Initialization
    public init(rating: Double?, categoryID: Int?, name: String?, email: String?, avatarName: String?, phone: String?, balance: Int?, categoryName: String?) {
        self._rating = rating
        self.categoryID = categoryID
        self.name = name
        self.email = email
        self._avatarName = avatarName
        self.phone = phone
        self.balance = balance
        self.categoryName = categoryName
    }
}
