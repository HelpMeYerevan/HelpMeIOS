//
//  ActivityTypeTranslate.swift
//  help.me
//
//  Created by Karen Galoyan on 12/26/21.
//

import Foundation

public struct ActivityTypeTranslate: Codable {
    
    // MARK: Properies
    public let id: Int
    public let name: String
    public let typeID: Int
    public let languageID: Int
    public let createdAt: String?
    public let updatedAt: String?

    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case typeID = "type_id"
        case languageID = "language_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
