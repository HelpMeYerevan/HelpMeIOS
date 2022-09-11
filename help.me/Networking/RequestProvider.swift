//
//  RequestProvider.swift
//  help.me
//
//  Created by Karen Galoyan on 11/11/21.
//

import UIKit
import Alamofire



public enum RequestProvider: URLRequestBuilder {
    case signUp(name: String, email: String, password: String, phoneNumber: String, isAlsoWorker: Bool, accountType: AccountType?, activityType: Int?, categories: [Int]?, documents: String?)
    case prepareSignUp
    case signIn(email: String, password: String)
    case passwordRecovery(email: String)
    case verifyCode(profileID: Int, code: Int)
    case resendVerificationCode
    case signOut
    
    case getTopStories(page: Int)
    case getTopWorks(categoryID: Int? = nil, page: Int)
    case getTopUsers(categoryID: Int? = nil)
    case getTopCategories(page: Int)
    
    case getCoordinates(categoryID: Int? = nil)
    case getCurrentCoordinate(workID: Int)
    
//    case createWork(address: String, description: String, image: String, price: Double, lat: Double, long: Double, payment_type_id, categoryID)
    
    case getProfile
    case updateProfile(avatar: String? = nil, email: String? = nil, phoneNumber: String? = nil, isAlsoWorker: Bool? = nil, accountType: AccountType? = nil, activityType: Int? = nil, categories: [Int]? = nil, documents: String?)
    case createPaymentCard(cardHolder: String, cardNumber: String, expirationDate: String, cvv: String)
    case updatePaymentCard(cardID: Int, cardHolder: String?, isActive: Bool?)
    case getPaymentCards
    case getLanguages
    case uploadFiles(file: UIImage, type: FileType)
    case getContactUsInformation
    
    // MARK: Properties
    public var path: String {
        switch self {
            case .signUp: return baseURL + "/api/register"
            case .prepareSignUp: return baseURL + "/api/registration/prepare?language_id=\(ConfigDataProvider.currentLanguage.id ?? 3)"
            case .signIn: return baseURL + "/api/login"
            case .passwordRecovery: return baseURL + "/api/password/forgot"
            case .verifyCode: return baseURL + "/api/register/verify"
            case .resendVerificationCode: return baseURL + "/api/register/verify/resend"
            case .signOut: return baseURL + "/api/logout"
            case let .getTopStories(page): return baseURL + "/api/stories/latest?page=\(page)"
            case let .getTopWorks(categoryID, page):
                let path = baseURL + "/api/works/latest?language_id=\(ConfigDataProvider.currentLanguage.id ?? 3)"
                if let categoryID = categoryID {
                    return path + "&category_id=\(categoryID)"
                }
                return path + "&page=\(page)"
            case let .getTopUsers(categoryID):
                let path = baseURL + "/api/categories/top/users?language_id=\(ConfigDataProvider.currentLanguage.id ?? 3)"
                if let categoryID = categoryID {
                    return path + "&category_id=\(categoryID)"
                }
                return path
            case let .getTopCategories(page): return baseURL + "/api/categories/top?language_id=\(ConfigDataProvider.currentLanguage.id ?? 3)&page=\(page)"
            case let .getCoordinates(categoryID):
                let path = baseURL + "/api/works/latest/coordinates"
                if let categoryID = categoryID {
                    return path + "?category_id=\(categoryID)"
                }
                return path
            case let .getCurrentCoordinate(workID): return baseURL + "/api/works/\(workID)?language_id=\(ConfigDataProvider.currentLanguage.id ?? 3)"
//            case .createWork: return baseURL + "/api/works"
            case .getProfile, .updateProfile: return baseURL + "/api/user"
            case .createPaymentCard, .getPaymentCards: return baseURL + "/api/payment/types"
            case let .updatePaymentCard(cardID, _, _): return baseURL + "/api/payment/types/\(cardID)"
            case .getLanguages: return baseURL + "/api/languages"
            case .uploadFiles(_, let type): return baseURL + "/api/upload/\(type.rawValue)"
            case .getContactUsInformation: return baseURL + "/social/config"
        }
    }
    
    public var headers: HTTPHeaders? {
        switch self {
            case .prepareSignUp, .signUp, .signIn, .passwordRecovery, .verifyCode, .getContactUsInformation:
                return [
                    "Accept" : "application/json",
                    "Content-Type" : "application/json"
                ]
            case .resendVerificationCode, .getTopStories, .getTopWorks, .getTopUsers, .signOut, .getCoordinates, .getCurrentCoordinate, .getTopCategories, .getProfile, .updateProfile, .updatePaymentCard, .getPaymentCards, .getLanguages, .uploadFiles:
                return [
                    "Accept" : "text/plain",
                    "Content-Type" : "application/json",
                    "Authorization" : "Bearer \(ConfigDataProvider.accessToken ?? "")"
                ]
            case .createPaymentCard:
                return [
                    "Accept" : "text/plain",
                    "Accept-Encoding" : "gzip, deflate, br",
                    "Connection" : "keep-alive",
                    "Content-Type" : "application/json",
                    "Authorization" : "Bearer \(ConfigDataProvider.accessToken ?? "")"
                ]
        }
    }
    
    public var parameters: Parameters? {
        switch self {
            case let .signUp(name, email, password, phoneNumber, isAlsoWorker, accountType, activityType, categories, documents):
                var parameters = [
                    "name" : name,
                    "email" : email,
                    "password" : password,
                    "password_confirmation" : password,
                    "phone" : phoneNumber,
                    "also_worker" : isAlsoWorker
                ] as Parameters
                if let accountType = accountType {
                    parameters["accountType"] = accountType.rawValue
                }
                if let activityType = activityType {
                    parameters["activityType"] = activityType
                }
                if let categories = categories {
                    parameters["categories"] = categories
                }
                if let documents = documents {
                    parameters["documents"] = documents
                }
                return parameters
            case let .signIn(email, password):
                return [
                    "email" : email,
                    "password" :password
                ]
            case let .passwordRecovery(email):
                return [
                    "language_id" : ConfigDataProvider.currentLanguage.id ?? 3,
                    "email" : email
                ]
            case let .verifyCode(profileID, code):
                return [
                    "user_id" : profileID,
                    "code" : code
                ]
            case let .uploadFiles(file, _):
                return [
                    "file" : file
                ]
            case let .updateProfile(avatar, email, phoneNumber, isAlsoWorker, accountType, activityType, categories, documents):
                var parameters: [String : Any] = [:]
                if let avatar = avatar {
                    parameters["avatar"] = avatar
                }
                if let email = email {
                    parameters["email"] = email
                }
                if let phoneNumber = phoneNumber {
                    parameters["phone"] = phoneNumber
                }
                if let isAlsoWorker = isAlsoWorker {
                    parameters["userType"] = isAlsoWorker ? 1 : 0
                }
                if let accountType = accountType {
                    parameters["accountType"] = accountType.rawValue
                }
                if let activityType = activityType {
                    parameters["activityType"] = activityType
                }
                if let categories = categories {
                    parameters["categories"] = categories
                }
                if let documents = documents {
                    parameters["documents"] = documents
                }
                return parameters
            case let .createPaymentCard(cardHolder, cardNumber, expirationDate, cvv):
                return [
                    "name" : cardNumber.cardNumber.creditCardType?.title ?? "",
                    "cvc" : cvv,
                    "expDate" : expirationDate,
                    "cardOwner" : cardHolder,
                    "cardNumber" : cardNumber.cardNumber
                ]
            case let .updatePaymentCard(_, cardHolder, isActive):
                var parameters: [String : Any] = [:]
                if let cardHolder = cardHolder {
                    parameters["name"] = cardHolder
                }
                if let isActive = isActive {
                    parameters["active"] = isActive ? 1 : 0
                }
                return parameters
//            case .createWork:
//                return [
//                    "address":"test address1 ",
//                        "description":"test description ",
//                        "image":"testimage.png ",
//                        "price":"500",
//                        "lat":4512854.156165,
//                        "long":1865468684.854,
//                        "payment_type_id":1,
//                        "category_id":1
//                ]
            case .resendVerificationCode, .prepareSignUp, .getTopStories, .getTopWorks, .getTopUsers, .getCoordinates, .getCurrentCoordinate, . getTopCategories, .getProfile, .signOut, .getPaymentCards, .getLanguages, .getContactUsInformation: return nil
        }
    }
    
    public var method: HTTPMethod {
        switch self {
            case .prepareSignUp, .getTopStories, .getTopWorks, .getTopUsers, .getCoordinates, .getCurrentCoordinate, .getTopCategories, .getProfile, .getPaymentCards, .getLanguages, .getContactUsInformation:
                return .get
            case .signUp, .signIn, .verifyCode, .resendVerificationCode, .passwordRecovery, .createPaymentCard, .signOut, .uploadFiles:
                return .post
            case .updateProfile, .updatePaymentCard:
                return .patch
        }
    }
}
