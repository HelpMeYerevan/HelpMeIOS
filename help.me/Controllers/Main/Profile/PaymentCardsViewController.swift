//
//  PaymentCardsViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 12/3/21.
//

import UIKit

public final class PaymentCardsViewController: BaseViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var paymentCardsScrollView: UIScrollView!
    @IBOutlet private weak var paymentCardsStackView: UIStackView!
    @IBOutlet private weak var addNewLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var cardNumberTitleLabel: UILabel!
    @IBOutlet private weak var cardNumberTextField: UITextField!
    @IBOutlet private weak var monthYearTitleLabel: UILabel!
    @IBOutlet private weak var monthYearTextField: UITextField!
    @IBOutlet private weak var cvvTitleLabel: UILabel!
    @IBOutlet private weak var cvvTextField: UITextField!
    @IBOutlet private weak var cardHolderNameTitleLabel: UILabel!
    @IBOutlet private weak var cardHolderNameTextField: UITextField!
    @IBOutlet private weak var applyButton: UIButton!
    @IBOutlet private weak var applyButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: Properties
    private var paymentCards: PaymentCards? {
        didSet {
            paymentCardsStackView.arrangedSubviews.forEach { subview in
                subview.removeFromSuperview()
            }
            paymentCards?.data?.forEach({ paymentCard in
                if paymentCard.isActive {
                    ConfigDataProvider.defaultPaymentCardLastFourDigits = paymentCard.paymentCardLastFourDigits
                }
                let paymentCardView = PaymentCardView()
                paymentCardView.setData(from: paymentCard)
                paymentCardView.selectButtonDidTapped = { [weak self] isSelected in
                    guard let self = self else { return }
                    if let id = paymentCard.id {
                        self.updatePaymentCardRequest(with: id, isActive: isSelected)
                    }
                    self.paymentCards?.data?.forEach({ paymentCard in
                        if let id = paymentCard.id, paymentCard.isActive {
                            self.updatePaymentCardRequest(with: id, isActive: false)
                        }
                    })
                }
                paymentCardsStackView.addArrangedSubview(paymentCardView)
            })
        }
    }

    // MARK: View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        getPaymentCardsRequest()
    }
    
    // MARK: Methods
    public override func setupView() {
        topView.setShadow(shadowInsets: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), cornerRadius: Constants.cornerRadius_15)
        applyButton.setCornerRadius(Constants.cornerRadius_10)
    }
    
    private func setupTextFields() {
        let titleColor = UIColor.hex_292E39.withAlphaComponent(0.4)
        let textColor = UIColor.hex_292E39.withAlphaComponent(0.8)
        cardNumberTitleLabel.textColor = titleColor
        cardNumberTitleLabel.isHidden = true
        cardNumberTextField.textColor = textColor
        cardNumberTextField.delegate = self
        cardNumberTextField.setHorizontalInsets(left: 8.5, right: 48)
        monthYearTitleLabel.textColor = titleColor
        monthYearTitleLabel.isHidden = true
        monthYearTextField.textColor = textColor
        monthYearTextField.delegate = self
        monthYearTextField.setHorizontalInsets(left: 8.5, right: 8.5)
        cvvTitleLabel.textColor = titleColor
        cvvTitleLabel.isHidden = true
        cvvTextField.textColor = textColor
        cvvTextField.delegate = self
        cvvTextField.setHorizontalInsets(left: 8.5, right: 8.5)
        cardHolderNameTitleLabel.textColor = titleColor
        cardHolderNameTitleLabel.isHidden = true
        cardHolderNameTextField.textColor = textColor
        cardHolderNameTextField.delegate = self
        cardHolderNameTextField.setHorizontalInsets(left: 8.5, right: 38)
    }
    
    private func isValidPaymentCardInputData() -> Bool {
        if (cardHolderNameTextField.text ?? "").isEmpty {
            return false
        }
        if (cardNumberTextField.text ?? "").isEmpty || (cardNumberTextField.text ?? "").cardNumber.count < 16 {
            return false
        }
        if (monthYearTextField.text ?? "").isEmpty || (monthYearTextField.text ?? "").count < 5 {
            return false
        }
        if (cvvTextField.text ?? "").isEmpty || (cvvTextField.text ?? "").count < 3 {
            return false
        }
        return true
    }
    
    // MARK: Localization
    public override func setupLocalization() {
        addNewLabel.setLocalizedString(.creditCard_addNew)
        descriptionLabel.setLocalizedString(.creditCard_description)
        backButton.setLocalizedString(.creditCard_creditDebitCard)
        cardNumberTitleLabel.setLocalizedString(.creditCard_cardNumber)
        cardNumberTextField.setLocalizedString(.creditCard_cardNumber)
        monthYearTitleLabel.setLocalizedString(.creditCard_expirationDate)
        monthYearTextField.setLocalizedString(.creditCard_expirationDate)
        cvvTitleLabel.setLocalizedString(.creditCard_cvv)
        cvvTextField.setLocalizedString(.creditCard_cvv)
        cardHolderNameTitleLabel.setLocalizedString(.creditCard_cardholder)
        cardHolderNameTextField.setLocalizedString(.creditCard_cardholder)
        applyButton.setLocalizedString(.creditCard_apply)
    }
    
    // MARK: Actions
    @IBAction private func backButtonAction(_ sender: UIButton) {
        popViewController()
    }
    
    @IBAction private func scanPaymentCardButtonAction(_ sender: UIButton) {
        pushToScanPaymentCardViewController()
    }
    
    @IBAction private func applyButtonAction(_ sender: UIButton) {
        guard let cardHolderName = cardHolderNameTextField.text, let cardNumber = cardNumberTextField.text, let expirationDate = monthYearTextField.text, let cvv = cvvTextField.text else { return }
        createPaymentCardRequest(with: cardHolderName, cardNumber: cardNumber, expirationDate: expirationDate, cvv: cvv)
    }
}

// MARK: Navigations
extension PaymentCardsViewController {
    private func pushToScanPaymentCardViewController() {
        guard let viewController = viewController(from: .main, withIdentifier: .scanPaymentCardViewController) as? ScanPaymentCardViewController else { return }
        viewController.paymentCardDidScanned = { [unowned self] paymentCard in
            self.cardNumberTextField.text = String(paymentCard.recognizedNumber?.separate(by: " ").dropLast() ?? "0000 0000 0000 0000")
            if let month = paymentCard.recognizedExpireDateMonth, let year = paymentCard.recognizedExpireDateYear {
                self.monthYearTextField.text = String(format: "%@/%@", month, year)
            }
            self.cardHolderNameTextField.text = paymentCard.recognizedHolderName
            self.cardNumberTitleLabel.isHidden = false
            self.monthYearTitleLabel.isHidden = false
            self.cardHolderNameTitleLabel.isHidden = false
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: Requests
extension PaymentCardsViewController {
    private func createPaymentCardRequest(with cardHolder: String, cardNumber: String, expirationDate: String, cvv: String) {
        showActivityIndicator()
        NetworkManager.shared.createPaymentCard(with: cardHolder, cardNumber: cardNumber, expirationDate: expirationDate, cvv: cvv) { [weak self] response in
            guard let self = self else { return }
            self.getPaymentCardsRequest()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(with: error)
            self.hideActivityIndicator()
        }
    }
    
    private func updatePaymentCardRequest(with cardID: Int, isActive: Bool) {
        showActivityIndicator()
        NetworkManager.shared.updatePaymentCard(with: cardID, cardHolder: nil, isActive: isActive) { [weak self] response in
            guard let self = self else { return }
            self.getPaymentCardsRequest()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(with: error)
            self.hideActivityIndicator()
        }
    }
    
    private func getPaymentCardsRequest() {
        showActivityIndicator()
        NetworkManager.shared.getPaymentCards() { [weak self] response in
            guard let self = self else { return }
            self.paymentCards = response
            self.hideActivityIndicator()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(with: error)
            self.hideActivityIndicator()
        }
    }
}

// MARK: UITextFieldDelegate
extension PaymentCardsViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let inputText = text.replacingCharacters(in: textRange, with: string)
            switch textField {
                case cardNumberTextField:
                    textField.text = "\(inputText.formattedCardNumber)"
                    cardNumberTitleLabel.isHidden = inputText.count < 1
                    return false
                case monthYearTextField:
                    textField.text = "\(inputText.formattedCardExpirationDate)"
                    monthYearTitleLabel.isHidden = inputText.count < 1
                    return false
                case cvvTextField:
                    textField.text = "\(inputText.formattedCardCVV)"
                    cvvTitleLabel.isHidden = inputText.count < 1
                    return false
                case cardHolderNameTextField: cardHolderNameTitleLabel.isHidden = inputText.count < 1
            default: break
            }
        }
        applyButton.setEnabled(isValidPaymentCardInputData())
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        applyButton.setEnabled(isValidPaymentCardInputData())
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        applyButton.setEnabled(isValidPaymentCardInputData())
        return true
    }
}

// MARK: KeyboardEventsDelegate
extension PaymentCardsViewController {
    public override func keyboardDidChangeFrame(willShow: Bool, keyboardHeight: CGFloat, animationDuration: TimeInterval) {
        let applyButtonBottomDefaultConstraintConstant: CGFloat = 30
        let scrollViewBottomDefaultConstraintConstant: CGFloat = 80

        UIView.animate(withDuration: animationDuration) {
            self.applyButtonBottomConstraint.constant = willShow ? keyboardHeight + applyButtonBottomDefaultConstraintConstant : applyButtonBottomDefaultConstraintConstant
            self.scrollViewBottomConstraint.constant = willShow ? keyboardHeight + scrollViewBottomDefaultConstraintConstant : scrollViewBottomDefaultConstraintConstant
            self.view.layoutIfNeeded()
        }
    }
}
