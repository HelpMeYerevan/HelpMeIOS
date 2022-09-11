//
//  Languages.swift
//  help.me
//
//  Created by Karen Galoyan on 2/2/22.
//

import Foundation

public struct Languages: Codable {
    
    // MARK: Properties
    public let languages: [Language]?
    
    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case languages = "data"
    }

    // MARK: Initialization
    public init(languages: [Language]?) {
        self.languages = languages
    }
}
