//
//  PaymentCard.swift
//  help.me
//
//  Created by Karen Galoyan on 2/6/22.
//

import Foundation

public struct PaymentCard: Codable {
    
    // MARK: Propeties
    public let id: Int?
    public let name: String?
    public let data: PaymentCardInfo?
    public let userID: Int?
    public let createdAt: String?
    private let active: Int?

    
    public var isActive: Bool {
        return (active ?? 0) != 0
    }
    public var paymentCardLastFourDigits: String {
        return String(data?.number?.suffix(4) ?? "0000")
    }

    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case data = "data"
        case userID = "user_id"
        case createdAt = "created_at"
        case active = "active"
    }

    // MARK: Initialization
    public init(id: Int?, name: String?, data: PaymentCardInfo?, userID: Int?, createdAt: String?, isActive: Int?) {
        self.id = id
        self.name = name
        self.data = data
        self.userID = userID
        self.createdAt = createdAt
        self.active = isActive
    }
}
