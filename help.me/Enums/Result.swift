//
//  Result.swift
//  help.me
//
//  Created by Karen Galoyan on 11/11/21.
//

import Foundation

public enum Result<T: Codable> {
    case success(T)
    case failure(Error)
}
