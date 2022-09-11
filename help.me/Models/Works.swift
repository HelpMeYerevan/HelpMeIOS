//
//  Works.swift
//  help.me
//
//  Created by Karen Galoyan on 1/30/22.
//

import Foundation

public struct Works: Codable {
    
    // MARK: Properies
    public var data: [Work]?
    private var links: Links?
    private var meta: Meta?

    public var currentPage: Int {
        return meta?.currentPage ?? 1
    }
    
    public var nextPage: Int {
        return (meta?.currentPage ?? 1) + 1
    }
    
    public var lastPage: Int {
        return meta?.lastPage ?? 1
    }

    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case links = "links"
        case meta = "meta"
    }

    // MARK: Initialization
    public init(data: [Work]?, links: Links?, meta: Meta?) {
        self.data = data
        self.links = links
        self.meta = meta
    }
    
    // MARK: Methods
    public mutating func updateData(with works: Works) {
        data?.append(contentsOf: works.data ?? [])
        links = works.links
        meta = works.meta
    }
}
