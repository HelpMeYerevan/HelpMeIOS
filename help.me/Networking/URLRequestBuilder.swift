//
//  URLRequestBuilder.swift
//  help.me
//
//  Created by Karen Galoyan on 11/11/21.
//

import Foundation
import Alamofire

public protocol URLRequestBuilder: URLRequestConvertible {
    
    // MARK: Properties
    var baseURL: String { get }
    var path: String { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var method: HTTPMethod { get }
}

extension URLRequestBuilder {
    
    // MARK: Properties
    public var baseURL: String {
        return ConfigDataProvider.isReleaseVersion ? "" : ConfigDataProvider.baseURL
    }

    // MARK: Methods
    public func asURLRequest() throws -> URLRequest {
        let url = try path.asURL()
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("text/plain", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let accessToken = ConfigDataProvider.accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        switch method {
        case .get, .post:
            request.allHTTPHeaderFields = headers?.dictionary
            request = try URLEncoding.default.encode(request, with: parameters)
        default: break
        }
        return request
    }
}
