//
//  ChatModel.swift
//  help.me
//
//  Created by Karen Galoyan on 12/1/21.
//

import Foundation
import UIKit

public struct ChatModel {
    
    // MARK: Properties
    public var workImage: UIImage?
    public var worker: WorkerModel
    public var categoryName: String
    public var messages: [MessageModel]
    public var isActive: Bool
    public var isUnread: Bool
}
