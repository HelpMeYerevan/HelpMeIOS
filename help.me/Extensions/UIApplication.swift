//
//  UIApplication.swift
//  help.me
//
//  Created by Karen Galoyan on 11/13/21.
//

import UIKit

extension UIApplication {
    
    // MARK: Properties
    public static var sceneDelegateWindow: UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let sceneDelegate = windowScene.delegate as? SceneDelegate else { return nil }
        return sceneDelegate.window
    }
    
    public static var releaseVersionNumber: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    public static var buildVersionNumber: String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
}
