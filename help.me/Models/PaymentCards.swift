//
//  PaymentCards.swift
//  help.me
//
//  Created by Karen Galoyan on 2/6/22.
//

import Foundation

public struct PaymentCards: Codable {
    
    // MARK: Properties
    public let data: [PaymentCard]?

    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }

    // MARK: Initialization
    public init(data: [PaymentCard]?) {
        self.data = data
    }
}
