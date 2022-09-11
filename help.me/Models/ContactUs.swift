//
//  ContactUs.swift
//  help.me
//
//  Created by Karen Galoyan on 2/20/22.
//

import Foundation

public struct ContactUs: Codable {
    
    // MARK: Propeties
    public let email: String?
    public let phoneNumber: String?
    public let whatsApp: String?
    public let facebookMessenger: String?
    public let telegram: String?
    public let viber: String?

    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case phoneNumber = "phone"
        case whatsApp = "whatsUp"
        case facebookMessenger = "messenger"
        case telegram = "telegram"
        case viber = "viber"
    }

    // MARK: Initialization
    public init(email: String?, phoneNumber: String?, whatsApp: String?, facebookMessenger: String?, telegram: String?, viber: String?) {
        self.email = email
        self.phoneNumber = phoneNumber
        self.whatsApp = whatsApp
        self.facebookMessenger = facebookMessenger
        self.telegram = telegram
        self.viber = viber
    }
}
