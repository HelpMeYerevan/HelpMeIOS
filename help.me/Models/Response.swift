//
//  Response.swift
//  help.me
//
//  Created by Karen Galoyan on 1/25/22.
//

import Foundation

public struct Response: Codable {
    
    // MARK: Properties
    private let success: Bool?
    public let message: String?
    public let token: String?
    public let profile: Profile?
    public let errors: Errors?
    public let code: Int?
    
    public var isSuccess: Bool {
        return success ?? false
    }
    
    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case token = "token"
        case profile = "user"
        case errors = "errors"
        case code = "code"
    }

    // MARK: Initialization
    public init(success: Bool?, message: String?, token: String?, profile: Profile?, errors: Errors?, code: Int?) {
        self.success = success
        self.message = message
        self.token = token
        self.profile = profile
        self.errors = errors
        self.code = code
    }
}

