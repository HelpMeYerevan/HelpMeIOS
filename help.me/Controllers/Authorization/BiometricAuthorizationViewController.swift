//
//  BiometricAuthorizationViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 11/16/21.
//

import UIKit

public final class BiometricAuthorizationViewController: BaseViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var biometricAuthorizationLabel: UILabel!
    @IBOutlet private weak var biometricAuthorizationImageView: UIImageView!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    // MARK: Properties
    
    // MARK: View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Methods
    public override func setupView() {
        yesButton.setCornerRadius(Constants.cornerRadius_10)
    }
    
    // MARK: Localization
    public override func setupLocalization() {
        biometricAuthorizationLabel.setLocalizedString(biometricType == .faceID ? .biometricAuthorization_enableSignInWithFaceID : .biometricAuthorization_enableSignInWithTouchID)
        biometricAuthorizationImageView.image = biometricType == .faceID ? .imageFaceID : .imageTouchID
        yesButton.setLocalizedString(.biometricAuthorization_Yes)
        noButton.setLocalizedString(.biometricAuthorization_No)
    }

    // MARK: Actions
    @IBAction private func yesButtonAction(_ sender: UIButton) {
        canEvaluatePolicyForDeviceOwnerAuthentication { [weak self] canEvaluate in
            guard let self = self else { return }
            if canEvaluate {
                self.evaluatePolicyForDeviceOwnerAuthentication { [weak self] isSuccess in
                    guard let self = self else { return }
                    if isSuccess {
                        DispatchQueue.main.async { [unowned self] in
                            ConfigDataProvider.isBiometricAuthorizationEnabled = true
                            self.pushToTabBarViewController()
                        }
                    }
                }
            }
        }
    }
    
    @IBAction private func noButtonAction(_ sender: UIButton) {
        pushToTabBarViewController()
    }
}

// MARK: Navigations
extension BiometricAuthorizationViewController {
    private func pushToTabBarViewController() {
        guard let viewController = viewController(from: .main, withIdentifier: .tabBarController) as? TabBarController else { return }
        UIApplication.sceneDelegateWindow?.rootViewController = viewController
        UIApplication.sceneDelegateWindow?.makeKeyAndVisible()
    }
}
