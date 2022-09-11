//
//  EmailViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 12/3/21.
//

import UIKit

public final class EmailViewController: BaseViewController {

    // MARK: Outlets
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var currentEmailLabel: UILabel!
    @IBOutlet private weak var addNewLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var emailTitleLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var applyButton: UIButton!
    @IBOutlet private weak var applyButtonBottomConstraint: NSLayoutConstraint!
    
    // MARK: Properties
    private var updatedEmail: String?
    
    // MARK: View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
    }
    
    // MARK: Methods
    public override func setupView() {
        topView.setShadow(shadowInsets: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), cornerRadius: Constants.cornerRadius_15)
        applyButton.setCornerRadius(Constants.cornerRadius_10)
        currentEmailLabel.text = ConfigDataProvider.currentProfile?.email
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
        backButton.setLocalizedString(.email_email)
        addNewLabel.setLocalizedString(.email_addNew)
        descriptionLabel.setLocalizedString(.email_description)
        emailTitleLabel.setLocalizedString(.email_addNewEmail)
        emailTextField.setLocalizedString(.email_addNewEmail)
        applyButton.setLocalizedString(.email_apply)
    }
    
    // MARK: Actions
    @IBAction private func backButtonAction(_ sender: UIButton) {
        popViewController()
    }
    
    @IBAction private func applyButtonAction(_ sender: UIButton) {
        updateProfileRequest()
    }
}

// MARK: Requests
extension EmailViewController {
    private func updateProfileRequest() {
        showActivityIndicator()
        NetworkManager.shared.updateProfile(email: updatedEmail) { [weak self] profile in
            guard let self = self else { return }
            ConfigDataProvider.currentProfile = profile
            self.currentEmailLabel.text = ConfigDataProvider.currentProfile?.email
            self.popViewController()
            self.hideActivityIndicator()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(with: error)
            self.hideActivityIndicator()
        }
    }
}

// MARK: UITextFieldDelegate
extension EmailViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let inputText = text.replacingCharacters(in: textRange, with: string)
            emailTitleLabel.isHidden = inputText.count < 1
            updatedEmail = inputText
            applyButton.setEnabled(inputText.isValidEmail)
        }
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

// MARK: KeyboardEventsDelegate
extension EmailViewController {
    public override func keyboardDidChangeFrame(willShow: Bool, keyboardHeight: CGFloat, animationDuration: TimeInterval) {
        UIView.animate(withDuration: animationDuration) { [weak self] in
            guard let self = self else { return }
            self.applyButtonBottomConstraint.constant = willShow ? keyboardHeight + 30 : 30
            self.view.layoutIfNeeded()
        }
    }
}
