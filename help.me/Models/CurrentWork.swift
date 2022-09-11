//
//  CurrentWork.swift
//  help.me
//
//  Created by Karen Galoyan on 3/14/22.
//

import Foundation

public struct CurrentWork: Codable {
    
    // MARK: Properties
    public let data: Work?

    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }

    // MARK: Initialization
    public init(data: Work?) {
        self.data = data
    }
}
