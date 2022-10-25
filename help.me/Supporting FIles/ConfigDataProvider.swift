//
//  ConfigDataProvider.swift
//  help.me
//
//  Created by Karen Galoyan on 11/11/21.
//

import Foundation

public struct ConfigDataProvider {
    
    // MARK: Keys
    public struct Keys {
        static let kAccessTokenKey = "accessToken"
        static let kCurrentLanguageKey = "currentLanguage"
        static let kLastSignedInProfileKey = "lastSignedInProfile"
        static let kIsBiometricAuthorizationEnabledKey = "isBiometricAuthorizationEnabled"
        static let kDefaultPaymentCardLastFourDigitsKey = "defaultPaymentCardLastFourDigits"
//        static let kCodeKey = "code"
//        static let kPushNotificationsRegistrationIdKey = "pushNotificationsRegistrationId"
//        static let kAPNSTokenKey = "apnsToken"
    }
//
    // MARK: Properties
    public static var baseURL: String {
        return "http://35.78.101.151"
    }
    public static var baseIP: String {
        return "http://54.91.138.39"
    }
//    public static var instagramURL: URL? {
//        return URL(string: "https://www.instagram.com/duna_duo/")
//    }
//    public static var facebookURL: URL? {
//        return URL(string: "https://www.facebook.com/dunaduoapp")
//    }
//    public static var twitterURL: URL? {
//        return URL(string: "https://twitter.com/duna_duo")
//    }
//    public static var pinterestURL: URL? {
//        return URL(string: "https://in.pinterest.com/0bp695u8vcdm5afjiv24tipa7sbfyv/_created/")
//    }
    public static var accessToken: String? {
        get {
            return UserDefaults.standard.string(forKey: Keys.kAccessTokenKey)
        }
        set {
            print("***\nACCESS TOKEN\nBearer \(newValue ?? "")\n***\n")
            UserDefaults.standard.set(newValue, forKey: Keys.kAccessTokenKey)
            UserDefaults.standard.synchronize()
        }
    }
    public static var defaultPaymentCardLastFourDigits: String? {
        get {
            return UserDefaults.standard.string(forKey: Keys.kDefaultPaymentCardLastFourDigitsKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.kDefaultPaymentCardLastFourDigitsKey)
            UserDefaults.standard.synchronize()
        }
    }
    public static var isBiometricAuthorizationEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.kIsBiometricAuthorizationEnabledKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.kIsBiometricAuthorizationEnabledKey)
            UserDefaults.standard.synchronize()
        }
    }
    public static var languages: [Language]?
    public static var currentLanguage: Language {
        get {
            let defaultLanguage = Language(id: 1)
            if let savedData = UserDefaults.standard.object(forKey: Keys.kCurrentLanguageKey) as? Data {
                let decoder = JSONDecoder()
                if let currentLanguage = try? decoder.decode(Language.self, from: savedData) {
                    return currentLanguage
                }
                return defaultLanguage
            }
            return defaultLanguage
        }
        set {
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(newValue) {
                UserDefaults.standard.set(data, forKey: Keys.kCurrentLanguageKey)
                UserDefaults.standard.synchronize()
            }
        }
    }
    public static var lastSignedInProfile: Profile? {
        get {
            if let savedData = UserDefaults.standard.object(forKey: Keys.kLastSignedInProfileKey) as? Data {
                let decoder = JSONDecoder()
                return try? decoder.decode(Profile.self, from: savedData)
            }
            return nil
        }
        set {
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(newValue) {
                UserDefaults.standard.set(data, forKey: Keys.kLastSignedInProfileKey)
                UserDefaults.standard.synchronize()
            }
        }
    }
    public static var categories: Categories?
    public static var currentProfile: Profile? {
        didSet {
            lastSignedInProfile = currentProfile
        }
    }
//    public static var code: [String : Any]? {
//        get {
//            return UserDefaults.standard.dictionary(forKey: Keys.kCodeKey)
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: Keys.kCodeKey)
//            UserDefaults.standard.synchronize()
//        }
//    }
    public static var isReleaseVersion: Bool {
        return false
    }
    
//    public static var userProfile: UserProfile? {
//        get {
//            if let savedData = UserDefaults.standard.object(forKey: Keys.kUserProfileKey) as? Data {
//                let decoder = JSONDecoder()
//                return try? decoder.decode(UserProfile.self, from: savedData)
//            }
//            return nil
//        }
//        set {
//            let encoder = JSONEncoder()
//            if let data = try? encoder.encode(newValue) {
//                UserDefaults.standard.set(data, forKey: Keys.kUserProfileKey)
//                UserDefaults.standard.synchronize()
//            }
//        }
//    }
//    public static var categories = [Category]()
//    public static var apnsToken = "" {
//        didSet {
//            NotificationCenter.default.post(name: Notification.Name(Keys.kAPNSTokenKey), object: nil)
//        }
//    }
//    public static var pushNotificationsRegistrationId: String? {
//        get {
//            return UserDefaults.standard.string(forKey: Keys.kPushNotificationsRegistrationIdKey)
//        }
//        set {
//            if let pushNotificationsRegistrationId = newValue {
//                print("***\nPUSH NOTIFICATION REGISTRATION ID\n\(pushNotificationsRegistrationId)\n***\n")
//            }
//            UserDefaults.standard.set(newValue, forKey: Keys.kPushNotificationsRegistrationIdKey)
//            UserDefaults.standard.synchronize()
//        }
//    }
//    public static let defaultUserProfileBirthday = "0001-01-01T00:00:00"
//    public static var deepLinkCode: String?
    public static let GMSProvideApiKey = "AIzaSyBcBM3Z6A34uknXQpisZMD46vHxgNufH_E"
}
