//
//  Links.swift
//  help.me
//
//  Created by Karen Galoyan on 1/30/22.
//

import Foundation

public struct Links: Codable {
    
    // MARK: Properies
    public let first: String?
    public let last: String?
    public let prev: String?
    public let next: String?
    
    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case first = "first"
        case last = "last"
        case prev = "prev"
        case next = "next"
    }
    
    // MARK: Initialization
    public init(first: String?, last: String?, prev: String?, next: String?) {
        self.first = first
        self.last = last
        self.prev = prev
        self.next = next
    }
}
