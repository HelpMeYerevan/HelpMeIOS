//
//  RecoveryViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 11/11/21.
//

import UIKit

public final class RecoveryViewController: BaseViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var emailTitleLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var sendLinkButton: UIButton!
    @IBOutlet private weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var dontHaveAnAccountLabel: UILabel!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var orLabel: UILabel!
    @IBOutlet private weak var enterAsGuestButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    
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
        sendLinkButton.setCornerRadius(Constants.cornerRadius_10)
    }
    
    private func setupTextFields() {
        let titleColor = UIColor.hex_292E39.withAlphaComponent(0.4)
        let textColor = UIColor.hex_292E39.withAlphaComponent(0.8)
        emailTitleLabel.textColor = titleColor
        emailTitleLabel.isHidden = true
        emailTextField.textColor = textColor
        emailTextField.delegate = self
        emailTextField.setHorizontalInsets(left: 8.5, right: 8.5)
    }
    
    // MARK: Localization
    public override func setupLocalization() {
        emailTitleLabel.setLocalizedString(.recovery_email)
        emailTextField.setLocalizedString(.recovery_email)
        sendLinkButton.setLocalizedString(.recovery_sendLinkForNewPassword)
        dontHaveAnAccountLabel.setLocalizedString(.recovery_dontHaveAnAccount)
        signUpButton.setLocalizedString(.recovery_signUp)
        orLabel.setLocalizedString(.recovery_or)
        enterAsGuestButton.setLocalizedString(.recovery_enterAsGuest)
        backButton.setLocalizedString(.recovery_back)
    }
    
    // MARK: Actions
    @IBAction private func backButtonAction(_ sender: UIButton) {
        popViewController()
    }
    
    @IBAction private func sendLinkButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(with: NetworkError.invalidEmail)
            return
        }
        passwordRecoveryRequest(email: email)
    }
    
    @IBAction private func signUpButtonAction(_ sender: UIButton) {
        pushToSignUpViewController()
    }
    
    @IBAction private func enterAsGuestButtonAction(_ sender: UIButton) {
        pushToTabBarViewController()
    }
}

// MARK: Navigations
extension RecoveryViewController {
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
extension RecoveryViewController {
    private func passwordRecoveryRequest(email: String) {
        showActivityIndicator()
        NetworkManager.shared.passwordRecovery(with: email) { [weak self] response in
            guard let self = self else { return }
            if response.isSuccess {
                self.showAlert(with: "Email", and: "Check your email to recover the password.") { [weak self] in
                    guard let self = self else { return }
                    self.popViewController()
                }
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
extension RecoveryViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let inputText = text.replacingCharacters(in: textRange, with: string)
            emailTitleLabel.isHidden = inputText.count < 1
        }
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
