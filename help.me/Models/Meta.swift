//
//  Meta.swift
//  help.me
//
//  Created by Karen Galoyan on 1/30/22.
//

import Foundation

public struct Meta: Codable {
    
    // MARK: Properies
    public let currentPage: Int?
    public let from: Int?
    public let lastPage: Int?
    public let links: [Link]?
    public let path: String?
    public let perPage: Int?
    public let to: Int?
    public let total: Int?
    
    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case from = "from"
        case lastPage = "last_page"
        case links = "links"
        case path = "path"
        case perPage = "per_page"
        case to = "to"
        case total = "total"
    }
    
    // MARK: Initialization
    public init(currentPage: Int?, from: Int?, lastPage: Int?, links: [Link]?, path: String?, perPage: Int?, to: Int?, total: Int?) {
        self.currentPage = currentPage
        self.from = from
        self.lastPage = lastPage
        self.links = links
        self.path = path
        self.perPage = perPage
        self.to = to
        self.total = total
    }
}
