//
//  Users.swift
//  help.me
//
//  Created by Karen Galoyan on 2/6/22.
//

import Foundation

public struct Users: Codable {
    
    // MARK: Properties
    public let data: [User]?
    public let links: Links?
    public let meta: Meta?

    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case links = "links"
        case meta = "meta"
    }

    // MARK: Initialization
    public init(data: [User]?, links: Links?, meta: Meta?) {
        self.data = data
        self.links = links
        self.meta = meta
    }
}
