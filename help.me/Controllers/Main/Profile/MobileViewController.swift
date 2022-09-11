//
//  MobileViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 12/3/21.
//

import UIKit

public final class MobileViewController: BaseViewController {

    // MARK: Outlets
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var currentPhoneNumberLabel: UILabel!
    @IBOutlet private weak var addNewLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var phoneNumberTitleLabel: UILabel!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var applyButton: UIButton!
    @IBOutlet private weak var applyButtonBottomConstraint: NSLayoutConstraint!
    
    // MARK: Properties
    private var updatedPhoneNumber: String?
    
    // MARK: View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
    }
    
    // MARK: Methods
    public override func setupView() {
        topView.setShadow(shadowInsets: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), cornerRadius: Constants.cornerRadius_15)
        applyButton.setCornerRadius(Constants.cornerRadius_10)
        currentPhoneNumberLabel.text = ConfigDataProvider.currentProfile?.phoneNumber
    }
    
    private func setupTextFields() {
        let titleColor = UIColor.hex_292E39.withAlphaComponent(0.4)
        let textColor = UIColor.hex_292E39.withAlphaComponent(0.8)
        phoneNumberTitleLabel.textColor = titleColor
        phoneNumberTitleLabel.isHidden = true
        phoneNumberTextField.textColor = textColor
        phoneNumberTextField.delegate = self
        phoneNumberTextField.setHorizontalInsets(left: 8.5, right: 8.5)
    }
    
    // MARK: Localization
    public override func setupLocalization() {
        backButton.setLocalizedString(.phoneNumber_phoneNumber)
        addNewLabel.setLocalizedString(.phoneNumber_addNew)
        descriptionLabel.setLocalizedString(.phoneNumber_description)
        phoneNumberTitleLabel.setLocalizedString(.phoneNumber_addNewPhoneNumber)
        phoneNumberTextField.setLocalizedString(.phoneNumber_addNewPhoneNumber)
        applyButton.setLocalizedString(.phoneNumber_apply)
    }
    
    // MARK: Actions
    @IBAction private func backButtonAction(_ sender: UIButton) {
        popViewController()
    }
    
    @IBAction private func applyButtonAction(_ sender: UIButton) {
        updateProfileRequest()
    }
}

// MARK: Navigations
extension MobileViewController {
    private func pushToPhoneNumberVerificationViewController(with accessToken: String?) {
        guard let viewController = viewController(from: .authorization, withIdentifier: .phoneNumberVerificationViewController) as? PhoneNumberVerificationViewController else { return }
        viewController.setUpdatedPhoneNumber(ConfigDataProvider.currentProfile?.phoneNumber)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: Requests
extension MobileViewController {
    private func updateProfileRequest() {
        showActivityIndicator()
        NetworkManager.shared.updateProfile(phoneNumber: updatedPhoneNumber?.phoneNumber) { [weak self] profile in
            guard let self = self else { return }
            if let phoneNumber = profile.phoneNumber {
                ConfigDataProvider.currentProfile?.updatePhoneNumber(phoneNumber)
            }
            self.currentPhoneNumberLabel.text = ConfigDataProvider.currentProfile?.phoneNumber
            self.pushToPhoneNumberVerificationViewController(with: ConfigDataProvider.currentProfile?.phoneNumber)
            self.hideActivityIndicator()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(with: error)
            self.hideActivityIndicator()
        }
    }
}

// MARK: UITextFieldDelegate
extension MobileViewController: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.text?.isEmpty ?? false {
            textField.text = "+374 "
        }
        phoneNumberTitleLabel.isHidden = (textField.text?.count ?? 0) < 1
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let inputText = text.replacingCharacters(in: textRange, with: string)
            textField.text = "+374 \(inputText.formattedPhoneNumber)"
            phoneNumberTitleLabel.isHidden = inputText.count < 1
            updatedPhoneNumber = textField.text
            applyButton.setEnabled(inputText.phoneNumber.count == 11)
            return false
        }
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

// MARK: KeyboardEventsDelegate
extension MobileViewController {
    public override func keyboardDidChangeFrame(willShow: Bool, keyboardHeight: CGFloat, animationDuration: TimeInterval) {
        UIView.animate(withDuration: animationDuration) { [weak self] in
            guard let self = self else { return }
            self.applyButtonBottomConstraint.constant = willShow ? keyboardHeight + 30 : 30
            self.view.layoutIfNeeded()
        }
    }
}
