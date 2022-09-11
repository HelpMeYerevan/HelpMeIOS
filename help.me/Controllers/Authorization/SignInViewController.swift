//
//  SignInViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 11/11/21.
//

import UIKit

public final class SignInViewController: BaseViewController {

    // MARK: Outlets
    @IBOutlet private weak var launchScreenBackgroundView: UIView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var logoImageViewAnimatedVerticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet private weak var logoImageViewVerticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet private weak var usernameTitleLabel: UILabel!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTitleLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var showHidePasswordButton: UIButton!
    @IBOutlet private weak var signInButton: UIButton!
    @IBOutlet private weak var forgotYourPasswordLabel: UILabel!
    @IBOutlet private weak var recoverItButton: UIButton!
    @IBOutlet private weak var dontHaveAnAccountLabel: UILabel!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var orLabel: UILabel!
    @IBOutlet private weak var enterAsGuestButton: UIButton!
    @IBOutlet private weak var bottomViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: Properties

    // MARK: View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
    }
    
    // MARK: Methods
    public override func setupView() {
        if isSmallDevice {
            bottomViewHeightConstraint.constant = 50
        }
        animateLogoImageView()
        signInButton.setCornerRadius(Constants.cornerRadius_10)
    }
    
    private func setupTextFields() {
        let titleColor = UIColor.hex_292E39.withAlphaComponent(0.4)
        let textColor = UIColor.hex_292E39.withAlphaComponent(0.8)
        usernameTitleLabel.textColor = titleColor
        usernameTitleLabel.isHidden = true
        usernameTextField.textColor = textColor
        usernameTextField.delegate = self
        usernameTextField.setHorizontalInsets(left: 8.5, right: 8.5)
        passwordTitleLabel.textColor = titleColor
        passwordTitleLabel.isHidden = true
        passwordTextField.textColor = textColor
        passwordTextField.delegate = self
        passwordTextField.setHorizontalInsets(left: 8.5, right: 38)
        showHidePasswordButton.tintColor = UIColor.hex_292E39.withAlphaComponent(0.4)
    }
    
    private func animateLogoImageView() {
        if ConfigDataProvider.isBiometricAuthorizationEnabled && ConfigDataProvider.accessToken != nil {
            canEvaluatePolicyForDeviceOwnerAuthentication { [weak self] canEvaluate in
                guard let self = self else { return }
                if canEvaluate {
                    self.evaluatePolicyForDeviceOwnerAuthentication { [weak self] isSuccess in
                        guard let self = self else { return }
                        if isSuccess {
                            DispatchQueue.main.async { [unowned self] in
                                self.pushToTabBarViewController()
                            }
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                                UIView.animate(withDuration: 0.5) {
                                    self.logoImageViewVerticalCenterConstraint.isActive = false
                                    self.logoImageViewAnimatedVerticalCenterConstraint.isActive = true
                                    self.logoImageView.alpha = 0
                                    self.launchScreenBackgroundView.alpha = 0
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                        self.logoImageView.image = UIImage.imageLogoColored
                                        self.logoImageView.alpha = 1
                                    }
                                    self.view.layoutIfNeeded()
                                }
                            })
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                UIView.animate(withDuration: 0.5) {
                    self.logoImageViewVerticalCenterConstraint.isActive = false
                    self.logoImageViewAnimatedVerticalCenterConstraint.isActive = true
                    self.logoImageView.alpha = 0
                    self.launchScreenBackgroundView.alpha = 0
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        self.logoImageView.image = UIImage.imageLogoColored
                        self.logoImageView.alpha = 1
                    }
                    self.view.layoutIfNeeded()
                }
            })
        }
    }
    
    // MARK: Localization
    public override func setupLocalization() {
        usernameTitleLabel.setLocalizedString(.signIn_phoneNumberEmailUsername)
        usernameTextField.setLocalizedString(.signIn_phoneNumberEmailUsername)
        passwordTitleLabel.setLocalizedString(.signIn_password)
        passwordTextField.setLocalizedString(.signIn_password)
        signInButton.setLocalizedString(.signIn_signIn)
        forgotYourPasswordLabel.setLocalizedString(.signIn_forgotYourPassword)
        recoverItButton.setLocalizedString(.signIn_recoverIt)
        dontHaveAnAccountLabel.setLocalizedString(.signIn_dontHaveAnAccount)
        signUpButton.setLocalizedString(.signIn_signUp)
        orLabel.setLocalizedString(.signIn_or)
        enterAsGuestButton.setLocalizedString(.signIn_enterAsGuest)
    }
    
    // MARK: Actions
    @IBAction private func showHidePasswordButtonAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        passwordTextField.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction private func signInButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        guard let email = usernameTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            showAlert(with: NetworkError.invalidCredentials)
            return
        }
        signInRequest(email: email, password: password)
    }
    
    @IBAction private func recoverItButtonAction(_ sender: UIButton) {
        pushToRecoveryViewController()
    }
    
    @IBAction private func signUpButtonAction(_ sender: UIButton) {
        pushToSignUpViewController()
    }
    
    @IBAction private func enterAsGuestButtonAction(_ sender: UIButton) {
        pushToTabBarViewController()
    }
}

// MARK: Navigations
extension SignInViewController {
    private func pushToRecoveryViewController() {
        guard let viewController = viewController(from: .authorization, withIdentifier: .recoveryViewController) as? RecoveryViewController else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func pushToSignUpViewController() {
        guard let viewController = viewController(from: .authorization, withIdentifier: .signUpViewController) as? SignUpViewController else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func pushToTabBarViewController() {
        guard let viewController = viewController(from: .main, withIdentifier: .tabBarController) as? TabBarController else { return }
        UIApplication.sceneDelegateWindow?.rootViewController = viewController
        UIApplication.sceneDelegateWindow?.makeKeyAndVisible()
    }
}

// MARK: Requests
extension SignInViewController {
    private func signInRequest(email: String, password: String) {
        showActivityIndicator()
        NetworkManager.shared.signIn(with: email, password: password) { [weak self] response in
            guard let self = self else { return }
            if response.isSuccess {
                ConfigDataProvider.accessToken = response.token
                ConfigDataProvider.currentProfile = response.profile
                self.pushToTabBarViewController()
            } else {
                if let errorMessage = response.message {
                    self.showAlert(with: errorMessage)
                } else {
                    self.showAlert(with: NetworkError.somethingWentWrong)
                }
            }
            self.hideActivityIndicator()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(with: error)
            self.hideActivityIndicator()
        }
    }
}

// MARK: UITextFieldDelegate
extension SignInViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let inputText = text.replacingCharacters(in: textRange, with: string)
            switch textField {
            case usernameTextField: usernameTitleLabel.isHidden = inputText.count < 1
            case passwordTextField: passwordTitleLabel.isHidden = inputText.count < 1
            default: break
            }
        }
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
