//
//  WorkCoordinate.swift
//  help.me
//
//  Created by Karen Galoyan on 1/31/22.
//

import Foundation

public struct WorkCoordinate: Codable {
    
    // MARK: Properties
    public let id: Int?
    public let lat: Double?
    public let long: Double?
    public let address: String?
    public let categoryID: Int?

    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case lat = "lat"
        case long = "long"
        case address = "address"
        case categoryID = "category_id"
    }
    
    // MARK: Initialization
    public init(id: Int?, lat: Double?, long: Double?, address: String?, categoryID: Int?) {
        self.id = id
        self.lat = lat
        self.long = long
        self.address = address
        self.categoryID = categoryID
    }
}
