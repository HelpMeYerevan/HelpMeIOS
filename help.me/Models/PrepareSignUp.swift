//
//  PrepareSignUp.swift
//  help.me
//
//  Created by Karen Galoyan on 12/26/21.
//

import Foundation

public struct PrepareSignUp: Codable {
    
    // MARK: Properties
    public var categories: [Category]?
    public var activityTypes: [ActivityType]?
    
    enum CodingKeys: String, CodingKey {
        case categories = "categories"
        case activityTypes = "activityTypes"
    }
    
    public init(categories: [Category]?, activityTypes: [ActivityType]?) {
        self.categories = categories
        self.activityTypes = activityTypes
    }
}
