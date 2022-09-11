//
//  AddPhotoViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 2/8/22.
//

import UIKit

public final class AddPhotoViewController: BaseViewController {

    // MARK: Outlets
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var servicesButton: UIButton!
    @IBOutlet private weak var productButton: UIButton!
    @IBOutlet private weak var bothButton: UIButton!
    @IBOutlet private weak var productsStateSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var addCategoriesTitleLabel: UILabel!
    @IBOutlet private weak var addCategoriesTextField: UITextField!
    @IBOutlet private weak var addCategoriesPlaceholderLabel: UILabel!
    @IBOutlet private weak var addDescriptionTitleLabel: UILabel!
    @IBOutlet private weak var addDescriptionView: UIView!
    @IBOutlet private weak var addDescriptionTextView: UITextView!
    @IBOutlet private weak var retryButton: UIButton!
    @IBOutlet private weak var addPhotoButton: UIButton!
    @IBOutlet private weak var buttonsBottomConstraint: NSLayoutConstraint!
    
    // MARK: Properties
    private var photoImage: UIImage?
    private var descriptionTextViewPlaceholder: String {
        return Localization.addWork_addDescriptionRequired.text
    }
    
    // MARK: View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupTextFields()
        setupTextView()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBar()
    }
    
    // MARK: Methods
    public override func setupView() {
        topView.setShadow(shadowInsets: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
        photoImageView.setCornerRadius(20)
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
        addCategoriesTextField.setHorizontalInsets(left: 8.5, right: 38)
        addDescriptionTitleLabel.textColor = titleColor
        addDescriptionTitleLabel.isHidden = true
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
    
    private func setupData() {
        photoImageView.image = photoImage
    }
    
    public func setPhotoImage(_ image: UIImage) {
        photoImage = image
    }
    
    // MARK: Localization
    public override func setupLocalization() {
        backButton.setLocalizedString(.addWork_addNewWork)
        addCategoriesTitleLabel.setLocalizedString(.addPhoto_addCategoriesRequired)
        addCategoriesTextField.setLocalizedString(.addPhoto_addCategoriesRequired)
        addDescriptionTitleLabel.setLocalizedString(.addPhoto_addDescriptionRequired)
        retryButton.setLocalizedString(.addPhoto_retry)
        addPhotoButton.setLocalizedString(.addPhoto_addPhoto)
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
    
    @IBAction private func retryButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        popViewController()
    }
    
    @IBAction private func addPhotoButtonAction(_ sender: UIButton) {
        view.endEditing(true)
    }
}

// MARK: KeyboardEventsDelegate
extension AddPhotoViewController {
    public override func keyboardDidChangeFrame(willShow: Bool, keyboardHeight: CGFloat, animationDuration: TimeInterval) {
        UIView.animate(withDuration: animationDuration) {
            self.buttonsBottomConstraint.constant = willShow ? keyboardHeight + 15 : 30
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: UITextFieldDelegate
extension AddPhotoViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let inputText = text.replacingCharacters(in: textRange, with: string)
            if inputText.isEmpty && range.length == 1 {
                addCategoriesPlaceholderLabel.text = addCategoriesTitleLabel.text
            } else {
                addCategoriesPlaceholderLabel.text = ConfigDataProvider.categories?.data?.filter({ $0.translate?.name?.lowercased().hasPrefix(inputText.lowercased()) ?? false }).first?.translate?.name
            }
            addCategoriesTitleLabel.isHidden = inputText.count < 1
        }
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

// MARK: UITextViewDelegate
extension AddPhotoViewController: UITextViewDelegate {
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
