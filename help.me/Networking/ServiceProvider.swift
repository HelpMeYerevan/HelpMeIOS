//
//  ServiceProvider.swift
//  help.me
//
//  Created by Karen Galoyan on 11/11/21.
//

import UIKit
import Alamofire

public final class ServiceProvider<T: URLRequestBuilder> {
    
    // MARK: Methods
    public func request<U: Codable>(service: T, decodeType: U.Type, completion: @escaping (Result<U>) -> Void) {
        guard Reachability.isConnectedToNetwork() else {
            completion(.failure(NetworkError.noInternetConnection))
            return
        }
        AF.request(service.path, method: service.method, parameters: service.parameters, encoding: JSONEncoding.default, headers: service.headers).responseDecodable(of: U.self) { (response) in
            switch response.response?.statusCode {
                case 401: completion(.failure(NetworkError.unauthorized))
                default:
                    switch response.result {
                        case .success(let result): completion(.success(result))
                        case .failure(let error):
                            if let result = Response(success: true, message: nil, token: nil, profile: nil, errors: nil, code: nil) as? U, response.response?.statusCode == 200 {
                                completion(.success(result))
                            } else {
                                completion(.failure(error))
                            }
                    }
            }
        }
    }

    public func uploadMultipartFormData<U: Codable>(service: T, decodeType: U.Type, completion: @escaping (Result<U>) -> Void) {
        guard Reachability.isConnectedToNetwork() else {
            completion(.failure(NetworkError.noInternetConnection))
            return
        }
        guard let urlRequest = service.urlRequest else { return }
        AF.upload(multipartFormData: { (multipartFormData) in
            service.parameters?.forEach({ (key, value) in
                if value is UIImage {
                    if let imageData = (value as? UIImage)?.jpegData(compressionQuality: 0.3) {
                        multipartFormData.append(imageData, withName: key, fileName: "report_image_\(Date()).jpg", mimeType: "image/jpeg")
                    }
                } else if value is URL {
                    if let url = (value as? URL) {
                        if url.path.lowercased().hasSuffix(".mov") {
                            multipartFormData.append(url, withName: key, fileName: "report_video_\(Date()).mov", mimeType: "video/quicktime")
                        } else if url.path.hasSuffix(".m4a") {
                            multipartFormData.append(url, withName: key, fileName: "report_audio_\(Date()).m4a", mimeType: "audio/x-m4a")
                        }
                    }
                } else if value is [String] {
                    if let stringsArray = value as? [String] {
                        for code in stringsArray {
                            if let codeData = code.data(using: .utf8) {
                                multipartFormData.append(codeData, withName: key as String )
                            }
                        }
                    }
                } else {
                    if let data = "\(value)".data(using: .unicode) {
                        multipartFormData.append(data, withName: key as String)
                    }
                }
            })
        }, with: urlRequest).responseDecodable(of: U.self) { (response) in
            switch response.response?.statusCode {
                case 401: completion(.failure(NetworkError.unauthorized))
                default:
                    switch response.result {
                        case .success(let result): completion(.success(result))
                        case .failure(let error):
                            if let data = response.data, let result = String(data: data, encoding: .utf8) as? U, response.response?.statusCode == 200 {
                                completion(.success(result))
                            } else {
                                completion(.failure(error))
                            }
                    }
            }
        }
    }
    
    public func getImage(with url: String, success: @escaping (UIImage?) -> (), failure: @escaping (Error) -> ()) {
        guard Reachability.isConnectedToNetwork() else {
            failure(NetworkError.noInternetConnection)
            return
        }
        AF.request(url ,method: .get).response{ response in
           switch response.result {
            case .success(let response):
                guard let response = response else { return }
                success(UIImage(data: response, scale: 1))
            case .failure(let error):
                failure(error)
            }
        }
    }
}
