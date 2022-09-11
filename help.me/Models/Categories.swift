//
//  Categories.swift
//  help.me
//
//  Created by Karen Galoyan on 2/2/22.
//

import Foundation

public struct Categories: Codable {
    
    // MARK: Properties
    public var data: [Category]?
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
    public init(data: [Category]?, links: Links?, meta: Meta?) {
        self.data = data
        self.links = links
        self.meta = meta
    }
    
    // MARK: Methods
    public mutating func updateData(with categories: Categories) {
        data?.append(contentsOf: categories.data ?? [])
        links = categories.links
        meta = categories.meta
    }
}
