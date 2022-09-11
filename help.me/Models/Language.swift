//
//  Language.swift
//  help.me
//
//  Created by Karen Galoyan on 12/26/21.
//

import Foundation

public struct Language: Codable {
    
    // MARK: Properties
    public let id: Int?
    private let _name: String?
    private let _code: String?
    private let image: String?
    private let main: Int?
    private let status: Int?
    private let createdAt: String?
    private let updatedAt: String?
    
    public var isSelected: Bool {
        return ConfigDataProvider.currentLanguage.id == id
    }
    public var isLastRow = false
    public var localeCode: String {
        return _code ?? "en"
    }
    public var localeIdentifier: String {
        switch _code {
            case "hy": return "hy_AM"
            case "ru": return "ru_RU"
            default: return "en_US"
        }
    }
    public var name: String? {
        return _name?.capitalized
    }
    public var localeName: String? {
        let locale = Locale(identifier: localeIdentifier)
        return locale.localizedString(forLanguageCode: localeIdentifier)?.capitalized
    }

    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case _name = "name"
        case _code = "code"
        case image = "image"
        case main = "main"
        case status = "status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    // MARK: Initialization
    public init(id: Int) {
        self.id = id
        _name = nil
        _code = "en"
        image = nil
        main = nil
        status = nil
        createdAt = nil
        updatedAt = nil
    }
}
