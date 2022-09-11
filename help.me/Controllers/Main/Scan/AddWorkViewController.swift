//
//  AddWorkViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 11/17/21.
//

import UIKit
import CoreLocation

public final class AddWorkViewController: BaseViewController {

    // MARK: Outlets
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var workImageView: UIImageView!
    @IBOutlet private weak var servicesButton: UIButton!
    @IBOutlet private weak var productButton: UIButton!
    @IBOutlet private weak var bothButton: UIButton!
    @IBOutlet private weak var productsStateSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var addCategoriesTitleLabel: UILabel!
    @IBOutlet private weak var addCategoriesTextField: UITextField!
    @IBOutlet private weak var addCategoriesPlaceholderLabel: UILabel!
    @IBOutlet private weak var addLocationTitleLabel: UILabel!
    @IBOutlet private weak var addLocationTextField: UITextField!
    @IBOutlet private weak var priceTitleLabel: UILabel!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var currencyLabel: UILabel!
    @IBOutlet private weak var timeTitleLabel: UILabel!
    @IBOutlet private weak var timeTextField: UITextField!
    @IBOutlet private weak var cashIconImageView: UIImageView!
    @IBOutlet private weak var cashTitleLabel: UILabel!
    @IBOutlet private weak var creditCardIconImageView: UIImageView!
    @IBOutlet private weak var creditCardTitleLabel: UILabel!
    @IBOutlet private weak var creditCardArrowImageView: UIImageView!
    @IBOutlet private weak var otherTitleLabel: UILabel!
    @IBOutlet private weak var otherArrowImageView: UIImageView!
    @IBOutlet private weak var paymentSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var addDescriptionView: UIView!
    @IBOutlet private weak var addDescriptionTitleLabel: UILabel!
    @IBOutlet private weak var addDescriptionTextView: UITextView!
    @IBOutlet private weak var retryButton: UIButton!
    @IBOutlet private weak var addWorkButton: UIButton!
    @IBOutlet private weak var buttonsBottomConstraint: NSLayoutConstraint!
    
    // MARK: Properties
    private var workImage: UIImage?
    private var paymentSegmentedControlElements: [UIView] {
        return [cashIconImageView, cashTitleLabel, creditCardIconImageView, creditCardTitleLabel, creditCardArrowImageView, otherTitleLabel, otherArrowImageView]
    }
    private var datePicker: UIDatePicker?
    private var datePickerConstraints = [NSLayoutConstraint]()
    private var descriptionTextViewPlaceholder: String {
        return Localization.addWork_addDescriptionRequired.text
    }
    
    // MARK: View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupTextFields()
        setupTextView()
        setupDatePicker()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBar()
    }
    
    // MARK: Methods
    public override func setupView() {
        topView.setShadow(shadowInsets: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
        workImageView.setCornerRadius(20)
        let buttonBorderColor = UIColor.hex_292E39.withAlphaComponent(0.6)
        servicesButton.setBorder(withColor: buttonBorderColor, andWidth: 1)
        productButton.setBorder(withColor: buttonBorderColor, andWidth: 1)
        bothButton.setBorder(withColor: buttonBorderColor, andWidth: 1)
        servicesButton.setTitleColor(buttonBorderColor, for: .normal)
        productButton.setTitleColor(buttonBorderColor, for: .normal)
        bothButton.setTitleColor(buttonBorderColor, for: .normal)
        let buttonsCornerRadius: CGFloat = 8
        servicesButton.setCornerRadius(buttonsCornerRadius)
        productButton.setCornerRadius(buttonsCornerRadius)
        bothButton.setCornerRadius(buttonsCornerRadius)
        let font = UIFont.robotoMediumFont(ofSize: 12)
        productsStateSegmentedControl.setTitleTextAttributes([.font: font, .foregroundColor: UIColor.hex_292E39.withAlphaComponent(0.6)], for: .normal)
        productsStateSegmentedControl.setTitleTextAttributes([.font: font, .foregroundColor: UIColor.hex_292E39], for: .selected)
    }
    
    private func setupTextFields() {
        let titleColor = UIColor.hex_292E39.withAlphaComponent(0.4)
        let textColor = UIColor.hex_292E39.withAlphaComponent(0.8)
        addCategoriesTitleLabel.textColor = titleColor
        addCategoriesTitleLabel.isHidden = true
        addCategoriesTextField.textColor = textColor
        addCategoriesTextField.delegate = self
        addCategoriesTextField.setHorizontalInsets(left: 8.5, right: 8.5)
        addLocationTitleLabel.textColor = titleColor
        addLocationTitleLabel.isHidden = true
        addLocationTextField.textColor = textColor
        addLocationTextField.delegate = self
        addLocationTextField.setHorizontalInsets(left: 8.5, right: 38)
        priceTitleLabel.textColor = titleColor
        priceTitleLabel.isHidden = true
        priceTextField.textColor = textColor
        priceTextField.delegate = self
        priceTextField.setHorizontalInsets(left: 8.5, right: 62)
        timeTitleLabel.textColor = titleColor
        timeTitleLabel.isHidden = true
        timeTextField.textColor = textColor
        timeTextField.delegate = self
        timeTextField.setHorizontalInsets(left: 8.5, right: 8.5)
    }
    
    private func setupTextView() {
        addDescriptionView.setBorder(withColor: .hex_CCCCCC, andWidth: 0.5)
        addDescriptionView.setCornerRadius(5)
        addDescriptionTextView.delegate = self
        addDescriptionTextView.textContainerInset = .zero
        addDescriptionTextView.text = descriptionTextViewPlaceholder
        addDescriptionTitleLabel.isHidden = true
    }
    
    private func setupTabBar() {
        tabBarController?.setTabBarHidden(true)
    }
    
    private func setupDatePicker() {
        datePicker = UIDatePicker()
        datePicker?.date = Date()
        datePicker?.locale = Locale(identifier: ConfigDataProvider.currentLanguage.localeIdentifier)
        datePicker?.preferredDatePickerStyle = .wheels
        datePicker?.addTarget(self, action: #selector(handleDateSelection), for: .valueChanged)
        timeTextField.inputView = datePicker
    }
    
    private func setupData() {
        workImageView.image = workImage
    }
    
    public func setWorkImage(_ image: UIImage) {
        workImage = image
    }
    
    @objc private func handleDateSelection() {
        guard let datePicker = datePicker else { return }
        let dateFormater: DateFormatter = DateFormatter()
        dateFormater.dateFormat = "dd/MM"
        let dateString: String = dateFormater.string(from: datePicker.date)
        dateFormater.dateFormat = "HH:mm"
        let timeString: String = dateFormater.string(from: datePicker.date)
        timeTextField.text = dateString + " | " + timeString
        timeTitleLabel.isHidden = (timeTextField.text ?? "").count < 1
    }
    
    // MARK: Localization
    public override func setupLocalization() {
        backButton.setLocalizedString(.addWork_addNewWork)
        addCategoriesTitleLabel.setLocalizedString(.addWork_addCategoriesRequired)
        addCategoriesTextField.setLocalizedString(.addWork_addCategoriesRequired)
        addLocationTitleLabel.setLocalizedString(.addWork_addLocationRequired)
        addLocationTextField.setLocalizedString(.addWork_addLocationRequired)
        priceTitleLabel.setLocalizedString(.addWork_price)
        priceTextField.setLocalizedString(.addWork_price)
        timeTitleLabel.setLocalizedString(.addWork_date)
        timeTextField.setLocalizedString(.addWork_date)
        cashTitleLabel.setLocalizedString(.addWork_cash)
        addDescriptionTitleLabel.setLocalizedString(.addWork_addDescriptionRequired)
        retryButton.setLocalizedString(.addWork_retry)
        addWorkButton.setLocalizedString(.addWork_addWork)
    }
    
    // MARK: Actions
    @IBAction private func backButtonAction(_ sender: UIButton) {
        popViewController()
    }
    
    @IBAction private func servicesButtonAction(_ sender: UIButton) {
        let grayColor = UIColor.hex_292E39.withAlphaComponent(0.6)
        let whiteColor = UIColor.hex_FFFFFF
        servicesButton.backgroundColor = grayColor
        servicesButton.setTitleColor(whiteColor, for: .normal)
        productButton.backgroundColor = whiteColor
        productButton.setTitleColor(grayColor, for: .normal)
        bothButton.backgroundColor = whiteColor
        bothButton.setTitleColor(grayColor, for: .normal)
        productsStateSegmentedControl.isHidden = true
    }
    
    @IBAction private func productButtonAction(_ sender: UIButton) {
        let grayColor = UIColor.hex_292E39.withAlphaComponent(0.6)
        let whiteColor = UIColor.hex_FFFFFF
        productButton.backgroundColor = grayColor
        productButton.setTitleColor(whiteColor, for: .normal)
        servicesButton.backgroundColor = whiteColor
        servicesButton.setTitleColor(grayColor, for: .normal)
        bothButton.backgroundColor = whiteColor
        bothButton.setTitleColor(grayColor, for: .normal)
        productsStateSegmentedControl.isHidden = false
    }
    
    @IBAction private func bothButtonAction(_ sender: UIButton) {
        let grayColor = UIColor.hex_292E39.withAlphaComponent(0.6)
        let whiteColor = UIColor.hex_FFFFFF
        bothButton.backgroundColor = grayColor
        bothButton.setTitleColor(whiteColor, for: .normal)
        servicesButton.backgroundColor = whiteColor
        servicesButton.setTitleColor(grayColor, for: .normal)
        productButton.backgroundColor = whiteColor
        productButton.setTitleColor(grayColor, for: .normal)
        productsStateSegmentedControl.isHidden = false
    }
    
    @IBAction private func productsStateSegmentedControlAction(_ sender: UISegmentedControl) {
    }
    
    @IBAction private func searchButtonAction(_ sender: UIButton) {
    }
    
    @IBAction private func locationButtonAction(_ sender: UIButton) {
        guard let currentLocation = currentLocation else { return }
        print("locations = \(currentLocation.coordinate.latitude) \(currentLocation.coordinate.longitude)")
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            if (error != nil) {
                print("Error in reverseGeocode")
                self.addLocationTextField.text = nil
                self.addLocationTitleLabel.isHidden = (self.addLocationTextField.text ?? "").count < 1
            }
            guard let placemark = placemarks else { return }
            if placemark.count > 0 {
                let placemark = placemark[0]
                var location = ""
                if let thoroughfare = placemark.thoroughfare {
                    location.append("\(thoroughfare)")
                }
                if let locality = placemark.locality {
                    location.append(", \(locality)")
                }
                if let administrativeArea = placemark.administrativeArea {
                    location.append(", \(administrativeArea)")
                }
                if let country = placemark.country {
                    location.append(", \(country)")
                }
                self.addLocationTextField.text = location
                self.addLocationTitleLabel.isHidden = (self.addLocationTextField.text ?? "").count < 1
            }
        }
    }
    
    @IBAction private func paymentSegmentedControlAction(_ sender: UISegmentedControl) {
        self.paymentSegmentedControlElements.forEach { element in
            element.alpha = element.tag == sender.selectedSegmentIndex ? 1 : 0.6
        }
    }
    
    @IBAction private func retryButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        popViewController()
    }
    
    @IBAction private func addWorkButtonAction(_ sender: UIButton) {
        view.endEditing(true)
    }
}

// MARK: KeyboardEventsDelegate
extension AddWorkViewController {
    public override func keyboardDidChangeFrame(willShow: Bool, keyboardHeight: CGFloat, animationDuration: TimeInterval) {
        UIView.animate(withDuration: animationDuration) {
            self.buttonsBottomConstraint.constant = willShow ? keyboardHeight + 15 : 30
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: UITextFieldDelegate
extension AddWorkViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let inputText = text.replacingCharacters(in: textRange, with: string)
            switch textField {
                case addCategoriesTextField:
                    let inputText = text.replacingCharacters(in: textRange, with: string)
                    if inputText.isEmpty && range.length == 1 {
                        addCategoriesPlaceholderLabel.text = addCategoriesTitleLabel.text
                    } else {
                        addCategoriesPlaceholderLabel.text = ConfigDataProvider.categories?.data?.filter({ $0.translate?.name?.lowercased().hasPrefix(inputText.lowercased()) ?? false }).first?.translate?.name
                    }
                    addCategoriesTitleLabel.isHidden = inputText.count < 1
                case addLocationTextField: addLocationTitleLabel.isHidden = inputText.count < 1
                case priceTextField:
                    let inputText = text.replacingCharacters(in: textRange, with: string).formattedPrice
                    priceTextField.text = inputText
                    priceTitleLabel.isHidden = inputText.count < 1
                    currencyLabel.isHidden = inputText.count < 1
                    return false
                case timeTextField: timeTitleLabel.isHidden = inputText.count < 1
            default: break
            }
        }
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

// MARK: UITextViewDelegate
extension AddWorkViewController: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == descriptionTextViewPlaceholder {
            textView.text = ""
            textView.textColor = .hex_292E39
            addDescriptionTitleLabel.isHidden = false
        }
        return true
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = UIColor.officialApplePlaceholderColor
            textView.text = descriptionTextViewPlaceholder
            addDescriptionTitleLabel.isHidden = true
        }
    }
}
