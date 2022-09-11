//
//  NetworkError.swift
//  help.me
//
//  Created by Karen Galoyan on 11/11/21.
//

import Foundation

public enum NetworkError: Error {
    case noInternetConnection, somethingWentWrong, invalidEmail, invalidCredentials, passwordsNotEqual, unauthorized, emptyCategories
    
    // MARK: Properties
    var message: String {
        switch self {
            case .noInternetConnection: return "No Internet Connection. Please check internet connection and try again."
            case .somethingWentWrong: return "Something went wrong, try again please."
            case .invalidEmail: return "Please, enter valid email."
            case .invalidCredentials: return "Please, enter valid credentials."
            case .passwordsNotEqual: return "Confirm Password should be the same as Password."
            case .unauthorized: return "Authorization Required"
            case .emptyCategories: return "At least one category should be selected."
        }
    }
}
