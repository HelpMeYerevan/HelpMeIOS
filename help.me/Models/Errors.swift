//
//  Errors.swift
//  help.me
//
//  Created by Karen Galoyan on 1/25/22.
//

import Foundation

public struct Errors: Codable {
    
    // MARK: Properties
    public let name: [String]?
    public let email: [String]?
    public let phone: [String]?
    public let password: [String]?

    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case email = "email"
        case phone = "phone"
        case password = "password"
    }

    // MARK: Initialization
    public init(name: [String]?, email: [String]?, phone: [String]?, password: [String]?) {
        self.name = name
        self.email = email
        self.phone = phone
        self.password = password
    }
}
