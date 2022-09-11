//
//  CategoryTranslate.swift
//  help.me
//
//  Created by Karen Galoyan on 12/26/21.
//

import Foundation

public struct CategoryTranslate: Codable {
    
    // MARK: Properties
    public let categoryID: Int?
    public let languageID: Int?
    public let name: String?
    public let createdAt: String?
    public let updatedAt: String?

    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case categoryID = "category_id"
        case languageID = "language_id"
        case name = "name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
