//
//  ActivityType.swift
//  help.me
//
//  Created by Karen Galoyan on 12/26/21.
//

import Foundation

// MARK: - ActivityType
public struct ActivityType: Codable {
    
    // MARK: Properies
    public let id: Int
    public let createdAt: String?
    public let updatedAt: String?
    public let deletedAt: String?
    public let translate: ActivityTypeTranslate
    
    public var isSelected = false

    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case translate = "translate"
    }
}
