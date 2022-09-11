//
//  PaymentCardInfo.swift
//  help.me
//
//  Created by Karen Galoyan on 2/6/22.
//

import Foundation

public struct PaymentCardInfo: Codable {
    
    // MARK: Propeties
    public let cvc: String?
    public let name: String?
    public let number: String?
    public let expirationDate: String?

    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case cvc = "cvc"
        case name = "name"
        case number = "number"
        case expirationDate = "expirationDate"
    }

    // MARK: Initialization
    public init(cvc: String?, name: String?, number: String?, expirationDate: String?) {
        self.cvc = cvc
        self.name = name
        self.number = number
        self.expirationDate = expirationDate
    }
}
