//
//  PhoneNumberVerificationViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 11/16/21.
//

import UIKit

public final class PhoneNumberVerificationViewController: BaseViewController {

    // MARK: Outlets
    @IBOutlet private weak var phoneNumberVerificationLabel: UILabel!
    @IBOutlet private weak var firstDigitTextField: UITextField!
    @IBOutlet private weak var secondDigitTextField: UITextField!
    @IBOutlet private weak var thirdDigitTextField: UITextField!
    @IBOutlet private weak var fourthDigitTextField: UITextField!
    @IBOutlet private weak var fifthDigitTextField: UITextField!
    @IBOutlet private weak var getSmsVerificationCodeOnLabel: UILabel!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var getVerificationCodeButton: UIButton!
    @IBOutlet private weak var getVerificationCodeButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var backButton: UIButton!
    
    // MARK: Properties
    private var counter = 30
    private var timer: Timer?
    private var codeCount = 0 {
        didSet {
            if codeCount >= 5 {
                getVerificationCodeButton.setLocalizedString(.phoneNumberVerification_done)
                setGetVerificationCodeButtonEnabled(true)
            } else {
                getVerificationCodeButton.setLocalizedString(.phoneNumberVerification_getVerificationCode)
                setGetVerificationCodeButtonEnabled(counter == 0)
            }
        }
    }
    private var accessToken: String?
    private var updatedPhoneNumber: String?
    
    // MARK: View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTimer()
        setupTextFields()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: Methods
    public override func setupView() {
        getVerificationCodeButton.setCornerRadius(Constants.cornerRadius_10)
    }
    
    private func setupTextFields() {
        firstDigitTextField.becomeFirstResponder()
        firstDigitTextField.delegate = self
        secondDigitTextField.delegate = self
        thirdDigitTextField.delegate = self
        fourthDigitTextField.delegate = self
        fifthDigitTextField.delegate = self
    }
    
    private func setupTimer() {
        counter = 30
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    private func resetTimer() {
        timer?.invalidate()
        timer = nil
        timerLabel.isHidden = false
        setGetVerificationCodeButtonEnabled(false)
        setupTimer()
    }
    
    @objc func updateCounter() {
        if counter > 0 {
            timerLabel.text = "00:\(counter < 10 ? "0" : "")\(counter)"
            counter -= 1
        } else if counter == 0 {
            timerLabel.isHidden = true
            setGetVerificationCodeButtonEnabled(true)
            timer?.invalidate()
        }
    }
    
    private func setGetVerificationCodeButtonEnabled(_ isEnabled: Bool) {
        getVerificationCodeButton.setEnabled(isEnabled)
    }
    
    public func setAccessToken(_ accessToken: String?) {
        self.accessToken = accessToken
    }
    
    public func setUpdatedPhoneNumber(_ phoneNumber: String?) {
        self.updatedPhoneNumber = phoneNumber
    }
    
    // MARK: Localization
    public override func setupLocalization() {
        phoneNumberVerificationLabel.setLocalizedString(.phoneNumberVerification_phoneNumberVerification)
        getSmsVerificationCodeOnLabel.setLocalizedString(.phoneNumberVerification_getSmsVerificationCodeOn)
        let getSmsVerificationCodeOnPhoneNumber = "\(getSmsVerificationCodeOnLabel.text ?? "")\n\(profile?.phoneNumber ?? "")"
        getSmsVerificationCodeOnLabel.text = getSmsVerificationCodeOnPhoneNumber.replacingCharacters(in: getSmsVerificationCodeOnPhoneNumber.index(getSmsVerificationCodeOnPhoneNumber.endIndex, offsetBy: -8)..<getSmsVerificationCodeOnPhoneNumber.index(getSmsVerificationCodeOnPhoneNumber.endIndex, offsetBy: -2), with: " *** *")
        getVerificationCodeButton.setLocalizedString(.phoneNumberVerification_getVerificationCode)
        backButton.setLocalizedString(.phoneNumberVerification_back)
    }
    
    // MARK: Actions
    @IBAction func getVerificationCodeButtonAction(_ sender: UIButton) {
        if codeCount >= 5 {
            verifyCodeRequest()
        } else {
            resendVerificationCodeRequest()
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        popViewController()
    }
}

// MARK: Navigations
extension PhoneNumberVerificationViewController {
    private func pushToBiometricAuthorizationViewController() {
        guard let viewController = viewController(from: .authorization, withIdentifier: .biometricAuthorizationViewController) as? BiometricAuthorizationViewController else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: Requests
extension PhoneNumberVerificationViewController {
    private func verifyCodeRequest() {
        guard let profileID = ConfigDataProvider.currentProfile?.id, let firstDigit = firstDigitTextField.text, !firstDigit.isEmpty, let secondDigit = secondDigitTextField.text, !secondDigit.isEmpty, let thirdDigit = thirdDigitTextField.text, !thirdDigit.isEmpty, let fourthDigit = fourthDigitTextField.text, !fourthDigit.isEmpty, let fifthDigit = fifthDigitTextField.text, !fifthDigit.isEmpty, let code = Int("\(firstDigit)\(secondDigit)\(thirdDigit)\(fourthDigit)\(fifthDigit)") else { return }
        showActivityIndicator()
        NetworkManager.shared.verifyCode(with: profileID, code: code, success: { [weak self] response in
            guard let self = self else { return }
            self.hideActivityIndicator()
            ConfigDataProvider.accessToken = self.accessToken
            self.pushToBiometricAuthorizationViewController()
        }, failure: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(with: error)
            self.hideActivityIndicator()
        })
    }
    
    private func resendVerificationCodeRequest() {
        showActivityIndicator()
        NetworkManager.shared.resendVerificationCode() { [weak self] response in
            guard let self = self else { return }
            self.resetTimer()
            self.hideActivityIndicator()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(with: error)
            self.hideActivityIndicator()
        }
    }
}

// MARK: UITextFieldDelegate
extension PhoneNumberVerificationViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let inputText = text.replacingCharacters(in: textRange, with: string)
            if firstDigitTextField.isFirstResponder {
                if textField.text?.count == 1 {
                    if string.isEmpty {
                        firstDigitTextField.text = ""
                        codeCount -= 1
                    } else {
                        secondDigitTextField.text = string
                        codeCount += 1
                        secondDigitTextField.becomeFirstResponder()
                    }
                } else {
                    textField.text = inputText
                    codeCount += 1
                }
            } else if secondDigitTextField.isFirstResponder {
                if textField.text?.count == 1 && !string.isEmpty {
                    thirdDigitTextField.text = string
                    codeCount += 1
                    thirdDigitTextField.becomeFirstResponder()
                } else {
                    secondDigitTextField.text = ""
                    codeCount -= 1
                    firstDigitTextField.becomeFirstResponder()
                }
            } else if thirdDigitTextField.isFirstResponder {
                if textField.text?.count == 1 && !string.isEmpty {
                    fourthDigitTextField.text = string
                    codeCount += 1
                    fourthDigitTextField.becomeFirstResponder()
                } else {
                    thirdDigitTextField.text = ""
                    codeCount -= 1
                    secondDigitTextField.becomeFirstResponder()
                }
            } else if fourthDigitTextField.isFirstResponder {
                if textField.text?.count == 1 && !string.isEmpty {
                    fifthDigitTextField.text = string
                    codeCount += 1
                    fourthDigitTextField.resignFirstResponder()
                } else {
                    fourthDigitTextField.text = ""
                    codeCount -= 1
                    thirdDigitTextField.becomeFirstResponder()
                }
            } else if fifthDigitTextField.isFirstResponder {
                if textField.text?.count == 1 && string.isEmpty {
                    fifthDigitTextField.text = ""
                    codeCount -= 1
                    fourthDigitTextField.becomeFirstResponder()
                }
            }
        }
        return false
    }
}

// MARK: KeyboardEventsDelegate
extension PhoneNumberVerificationViewController {
    public override func keyboardDidChangeFrame(willShow: Bool, keyboardHeight: CGFloat, animationDuration: TimeInterval) {
        UIView.animate(withDuration: animationDuration) { [weak self] in
            guard let self = self else { return }
            self.getVerificationCodeButtonBottomConstraint.constant = willShow ? keyboardHeight + 20 : 85
            self.view.layoutIfNeeded()
        }
    }
}
