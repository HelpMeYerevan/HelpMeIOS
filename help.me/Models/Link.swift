//
//  Link.swift
//  help.me
//
//  Created by Karen Galoyan on 1/30/22.
//

import Foundation

public struct Link: Codable {
    
    // MARK: Properies
    public let url: String?
    public let label: String?
    public let active: Bool?
    
    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case url = "url"
        case label = "label"
        case active = "active"
    }
    
    // MARK: Initialization
    public init(url: String?, label: String?, active: Bool?) {
        self.url = url
        self.label = label
        self.active = active
    }
}
