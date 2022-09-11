//
//  LaunchViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 1/31/22.
//

import UIKit

final public class LaunchViewController: BaseViewController {

    // MARK: View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProfileRequest()
    }
}

// MARK: Navigations
extension LaunchViewController {
    private func pushToSignInViewController() {
        guard let viewController = viewController(from: .authorization, withIdentifier: .signInViewController) as? SignInViewController else { return }
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .custom
        navigationController.navigationBar.isHidden = true
        UIApplication.sceneDelegateWindow?.rootViewController = navigationController
        UIApplication.sceneDelegateWindow?.makeKeyAndVisible()
    }
    
    private func pushToTabBarViewController() {
        guard let viewController = viewController(from: .main, withIdentifier: .tabBarController) as? TabBarController else { return }
        UIApplication.sceneDelegateWindow?.rootViewController = viewController
        UIApplication.sceneDelegateWindow?.makeKeyAndVisible()
    }
}

// MARK: Requests
extension LaunchViewController {
    private func getProfileRequest() {
        NetworkManager.shared.getProfile() { [weak self] response in
            guard let self = self else { return }
            ConfigDataProvider.currentProfile = response
            self.getLanguages()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(with: error)
        }
    }
    
    private func getLanguages() {
        NetworkManager.shared.getLanguages() { [weak self] response in
            guard let self = self, let languages = response.languages else { return }
            if languages.isEmpty {
                ConfigDataProvider.languages = [ConfigDataProvider.currentLanguage]
            } else {
                ConfigDataProvider.languages = languages
                ConfigDataProvider.languages?[languages.count - 1].isLastRow = true
            }
            if let accessToken = ConfigDataProvider.accessToken, !ConfigDataProvider.isBiometricAuthorizationEnabled {
                print("***\nACCESS TOKEN\nBearer \(accessToken)\n***\n")
                self.pushToTabBarViewController()
            } else {
                self.pushToSignInViewController()
            }
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(with: error)
        }
    }
}
