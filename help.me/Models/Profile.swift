//
//  Profile.swift
//  help.me
//
//  Created by Karen Galoyan on 1/25/22.
//

import UIKit

public struct Profile: Codable {
    
    // MARK: Properties
    private let success: Bool?
    public let id: Int?
    public let name: String?
    public let email: String?
    private var phone: String?
    private let _balance: Double?
    private let _avatar: String?
    public let active: Int?
    public let history: Int?
    private let _rating: Double?
    public let notifications: Int?
    private let alsoWorker: Int?
    private let statusColor: String?
    public let createdAt: String?
    
    public var isSuccess: Bool {
        return success ?? false
    }
    public var avatarName: String? {
        return _avatar
    }
    
    public var avatar: UIImage?
    
    public var balance: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return (formatter.string(from: NSNumber(value: _balance ?? 0)) ?? "0.00") + " AMD"
    }
    
    public var status: ProfileStatusType {
        return .bronze
    }
    
    public var rating: Double {
        return _rating ?? 0
    }
    
    public var phoneNumber: String? {
        guard let phoneNumber = phone?.formattedPhoneNumber else { return nil }
        return "+374 " + phoneNumber
    }
    
    public var meID: String {
        return "\(Localization.profile_id.text) \(id ?? 0)"
    }
    
    public var selectedPaymentCard: String {
        if let defaultPaymentCardLastFourDigits = ConfigDataProvider.defaultPaymentCardLastFourDigits {
            return "**** \(defaultPaymentCardLastFourDigits)"
        } else {
            return Localization.profile_addNew.text
        }
    }
    
    public var isAlsoWorker: Bool {
        return alsoWorker == 1
    }
    
    public var profileStatus: ProfileStatusType {
//        guard let statusColor = statusColor else { return .bronze }
        return ProfileStatusType(rawValue: statusColor ?? "") ?? .bronze
    }
    
    // MARK: Keys
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case id = "id"
        case name = "name"
        case email = "email"
        case phone = "phone"
        case _balance = "balance"
        case _avatar = "avatar"
        case active = "active"
        case history = "history"
        case _rating = "rating"
        case notifications = "notifications"
        case alsoWorker = "also_worker"
        case statusColor = "statusColor"
        case createdAt = "created_at"
    }

    // MARK: Initialization
    public init(isSuccess: Bool?, id: Int?, name: String?, email: String?, phone: String?, balance: Double?, avatar: String?, active: Int?, history: Int?, rating: Double?, notifications: Int?, isAlsoWorker: Int?, statusColor: String?, createdAt: String?) {
        self.success = isSuccess
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self._balance = balance
        self._avatar = avatar
        self.active = active
        self.history = history
        self._rating = rating
        self.notifications = notifications
        self.alsoWorker = isAlsoWorker
        self.statusColor = statusColor
        self.createdAt = createdAt
    }
    
    // MARK: Method
    public mutating func updatePhoneNumber(_ phoneNumber: String) {
        phone = phoneNumber
    }
}
