//
//  SignUpViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 11/16/21.
//

import UIKit

public final class SignUpViewController: BaseViewController {

    // MARK: Outlets
    @IBOutlet private weak var signUpScrollView: UIScrollView!
    @IBOutlet private weak var phoneNumberView: UIView!
    @IBOutlet private weak var phoneNumberTitleLabel: UILabel!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var nameView: UIView!
    @IBOutlet private weak var nameTitleLabel: UILabel!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailView: UIView!
    @IBOutlet private weak var emailTitleLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordView: UIView!
    @IBOutlet private weak var passwordTitleLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var showHidePasswordButton: UIButton!
    @IBOutlet private weak var confirmPasswordView: UIView!
    @IBOutlet private weak var confirmPasswordTitleLabel: UILabel!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var showHideConfirmPasswordButton: UIButton!
    @IBOutlet private weak var socialMediaInformationLabel: UILabel!
    @IBOutlet private weak var socialMediaInformationView: UIView!
    @IBOutlet private weak var socialMediaInformationViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imUserWhoWantToHireWorkerLabel: UILabel!
    @IBOutlet private weak var typeOfMyActivityLabel: UILabel!
    @IBOutlet private weak var youCanSelectThreeItemsLabel: UILabel!
    @IBOutlet private weak var ifYouWantToBeMarkedUserLabel: UILabel!
    @IBOutlet private weak var provideServiceButton: UIButton!
    @IBOutlet private weak var provideServiceStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var provideServiceView: UIView!
    @IBOutlet private weak var providedServiceFromSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var typeOfActivityLabel: UILabel!
    @IBOutlet private weak var activitiesStackView: UIStackView!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var categoriesView: UIView!
    @IBOutlet private weak var categoriesTableView: UITableView!
    @IBOutlet private weak var selectedDocumentImageView: UIImageView!
    @IBOutlet private weak var documentTitleLabel: UILabel!
    @IBOutlet private weak var addDocumentButton: UIButton!
    @IBOutlet private weak var deleteDocumentButton: UIButton!
    @IBOutlet private weak var continueButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var acceptLicenseAgreementsButton: UIButton!
    @IBOutlet private weak var licenseAgreementsButton: UIButton!
    
    // MARK: Properties
    private var provideServiceStackViewDefaultHeight: CGFloat {
        if isSmallDevice {
            socialMediaInformationViewHeightConstraint.constant = 25
            return 20
        }
        return UIScreen.main.bounds.height - 485 - 128 - (UIApplication.sceneDelegateWindow?.safeAreaInsets.top ?? 0)
    }
    private var provideServiceStackViewExpandedHeight: CGFloat {
        return 581
    }
    private var prepareCategories: PrepareSignUp? {
        didSet {
            if activityType == nil {
                prepareCategories?.activityTypes?[0].isSelected = true
                activityType = prepareCategories?.activityTypes?.first
            }
        }
    }
    private var isAlsoWorker = false
    private var isLicenseAgreementsAccepted = false {
        didSet {
            DispatchQueue.main.async {
                self.acceptLicenseAgreementsButton.isSelected = self.isLicenseAgreementsAccepted
                self.continueButton.setEnabled(self.isLicenseAgreementsAccepted)
            }
        }
    }
    private var categories: [Category] {
        set {
            prepareCategories?.categories = newValue
        }
        get {
            return searchingCategoryName.isEmpty ? prepareCategories?.categories ?? [] : prepareCategories?.categories?.filter({ ($0.translate?.name?.lowercased() ?? "").contains(searchingCategoryName.lowercased()) }) ?? []
        }
    }
    private var searchingCategoryName = ""
    private var accountType: AccountType = .individual
    private var activityType: ActivityType?
    private var selectedCategories: [Category] = [] {
        didSet {
            continueButton.setEnabled(!selectedCategories.isEmpty)
        }
    }
    private var document: UIImage?
    private var documentName: String?
    private var isUpdatingProvideServiceInformation = false
    public var profileDidSuccessfullyUpdated: (() -> Void)?

    // MARK: View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        setupTableView()
        setupProvideServiceView(for: provideServiceButton.isSelected)
        prepareSignUpRequest()
    }
    
    // MARK: Methods
    public override func setupView() {
        socialMediaInformationView.isHidden = true
        provideServiceStackViewHeightConstraint.constant = provideServiceButton.isSelected ? provideServiceStackViewExpandedHeight : provideServiceStackViewDefaultHeight
        provideServiceView.isHidden = true
        activityTypesReloadData()
        categoriesView.setBorder(withColor: .hex_E5E5E5, andWidth: 1)
        let cornerRadius: CGFloat = Constants.cornerRadius_10
        categoriesView.setCornerRadius(cornerRadius)
        continueButton.setCornerRadius(cornerRadius)
        selectedDocumentImageView.setCornerRadius(Constants.cornerRadius_5)
        phoneNumberView.isHidden = isUpdatingProvideServiceInformation
        nameView.isHidden = isUpdatingProvideServiceInformation
        emailView.isHidden = isUpdatingProvideServiceInformation
        passwordView.isHidden = isUpdatingProvideServiceInformation
        confirmPasswordView.isHidden = isUpdatingProvideServiceInformation
        acceptLicenseAgreementsButton.isHidden = isUpdatingProvideServiceInformation
        licenseAgreementsButton.isHidden = isUpdatingProvideServiceInformation
        if isUpdatingProvideServiceInformation {
            socialMediaInformationViewHeightConstraint.constant = 0
            provideServiceButton.isSelected = isUpdatingProvideServiceInformation
            provideServiceButton.isUserInteractionEnabled = false
        }
    }
    
    private func setupTextFields() {
        let titleColor = UIColor.hex_292E39.withAlphaComponent(0.4)
        let textColor = UIColor.hex_292E39.withAlphaComponent(0.8)
        phoneNumberTitleLabel.textColor = titleColor
        phoneNumberTitleLabel.isHidden = true
        phoneNumberTextField.textColor = textColor
        phoneNumberTextField.delegate = self
        phoneNumberTextField.setHorizontalInsets(left: 8.5, right: 8.5)
        nameTitleLabel.textColor = titleColor
        nameTitleLabel.isHidden = true
        nameTextField.textColor = textColor
        nameTextField.delegate = self
        nameTextField.setHorizontalInsets(left: 8.5, right: 8.5)
        emailTitleLabel.textColor = titleColor
        emailTitleLabel.isHidden = true
        emailTextField.textColor = textColor
        emailTextField.delegate = self
        emailTextField.setHorizontalInsets(left: 8.5, right: 8.5)
        passwordTitleLabel.textColor = titleColor
        passwordTitleLabel.isHidden = true
        passwordTextField.textColor = textColor
        passwordTextField.delegate = self
        passwordTextField.setHorizontalInsets(left: 8.5, right: 38)
        showHidePasswordButton.tintColor = UIColor.hex_292E39.withAlphaComponent(0.4)
        confirmPasswordTitleLabel.textColor = titleColor
        confirmPasswordTitleLabel.isHidden = true
        confirmPasswordTextField.textColor = textColor
        confirmPasswordTextField.delegate = self
        confirmPasswordTextField.setHorizontalInsets(left: 8.5, right: 38)
        showHideConfirmPasswordButton.tintColor = UIColor.hex_292E39.withAlphaComponent(0.4)
        searchTextField.delegate = self
    }
    
    private func setupTableView() {
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.register(SelectableCategoryTableViewHeaderView.viewNib, forHeaderFooterViewReuseIdentifier: SelectableCategoryTableViewHeaderView.viewIdentifier)
        categoriesTableView.register(SelectableSubcategoryTableViewCell.cellNibName, forCellReuseIdentifier: SelectableSubcategoryTableViewCell.cellIdentifier)
        if #available(iOS 15.0, *) {
            categoriesTableView.sectionHeaderTopPadding = 0
        }
        categoriesTableView.contentInset = .zero
    }
    
    private func setupProvideServiceView(for isAlsoWorker: Bool) {
        provideServiceStackViewHeightConstraint.constant = isAlsoWorker ? provideServiceStackViewExpandedHeight : provideServiceStackViewDefaultHeight
        provideServiceView.isHidden = !isAlsoWorker
        self.isAlsoWorker = isAlsoWorker
        signUpScrollView.isScrollEnabled = isAlsoWorker
        categoriesTableView.reloadData()
    }
    
    private func activityTypesReloadData() {
        if prepareCategories?.activityTypes?.isEmpty ?? true {
            typeOfActivityLabel.isHidden = true
        } else {
            typeOfActivityLabel.isHidden = false
            activitiesStackView.subviews.forEach { subview in
                subview.removeFromSuperview()
            }
            var buttonWidth: CGFloat = 0
            let activitiesStackViewWidth = UIScreen.main.bounds.width - 38 * 2
            let buttonsInset: CGFloat = 6
            switch prepareCategories?.activityTypes?.count {
                case 1: buttonWidth = activitiesStackViewWidth
                case 2: buttonWidth = (activitiesStackViewWidth - buttonsInset) / 2
                default: buttonWidth = (activitiesStackViewWidth - buttonsInset * 2) / 3
            }
            prepareCategories?.activityTypes?.enumerated().forEach({ (index, activityType) in
                let button = UIButton(for: activityType)
                button.tag = index
                button.addTarget(self, action: #selector(activityTypeButtonAction(_:)), for: .touchUpInside)
                activitiesStackView.addArrangedSubview(button)
                
                button.translatesAutoresizingMaskIntoConstraints = false
                button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
            })
        }
    }
    
    private func updateSelectedCategries(_ selectedCategory: Category) {
        if selectedCategories.contains(where: { $0.id == selectedCategory.id }) {
            selectedCategories = selectedCategories.filter({ $0.id != selectedCategory.id })
        } else {
            selectedCategories.append(selectedCategory)
        }
    }
    
    public func setProvideServiceInformation(to isUpdatingProvideServiceInformation: Bool) {
        self.isUpdatingProvideServiceInformation = isUpdatingProvideServiceInformation
    }
    
    // MARK: Localization
    public override func setupLocalization() {
        phoneNumberTitleLabel.setLocalizedString(.signUp_phoneNumberRequired)
        phoneNumberTextField.setLocalizedString(.signUp_phoneNumberRequired)
        nameTitleLabel.setLocalizedString(.signUp_nameRequired)
        nameTextField.setLocalizedString(.signUp_nameRequired)
        emailTitleLabel.setLocalizedString(.signUp_emailRequired)
        emailTextField.setLocalizedString(.signUp_emailRequired)
        passwordTitleLabel.setLocalizedString(.signUp_passwordRequired)
        passwordTextField.setLocalizedString(.signUp_passwordRequired)
        confirmPasswordTitleLabel.setLocalizedString(.signUp_confirmPasswordRequired)
        confirmPasswordTextField.setLocalizedString(.signUp_confirmPasswordRequired)
        socialMediaInformationLabel.setLocalizedString(.signUp_orGetInformationFrom)
        imUserWhoWantToHireWorkerLabel.setLocalizedString(.signUp_imUserWhoWantToHireWorker)
        typeOfMyActivityLabel.setLocalizedString(.signUp_typeOfMyActivity)
        youCanSelectThreeItemsLabel.setLocalizedString(.signUp_youCanSelectThreeItems)
        ifYouWantToBeMarkedUserLabel.setLocalizedString(.signUp_ifYouWantToBeMarkedUser)
        provideServiceButton.setLocalizedString(.signUp_alsoIwantToProvideService, buttonState: .normal)
        provideServiceButton.setLocalizedString(.signUp_alsoIwantToProvideService, buttonState: .selected)
        providedServiceFromSegmentedControl.setLocalizedString(.signUp_individual, index: 0)
        providedServiceFromSegmentedControl.setLocalizedString(.signUp_company, index: 1)
        typeOfActivityLabel.setLocalizedString(.signUp_typeOfMyActivity)
        searchTextField.setLocalizedString(.signUp_whatCanYouDo)
        documentTitleLabel.setLocalizedString(.signUp_addDocument)
        backButton.setLocalizedString(.signUp_back)
        continueButton.setLocalizedString(isUpdatingProvideServiceInformation ? .signUp_save : .signUp_continue)
        acceptLicenseAgreementsButton.setLocalizedString(.signUp_iHaveAccept)
        licenseAgreementsButton.setLocalizedString(.signUp_licenseAgreements)
    }
    
    // MARK: Actions
    @IBAction private func showHidePasswordButtonAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        passwordTextField.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction private func showHideConfirmPasswordButtonAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        confirmPasswordTextField.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction private func facebookButtonAction(_ sender: UIButton) { }
    
    @IBAction private func linkedInButtonAction(_ sender: UIButton) { }
    
    @IBAction private func googleButtonAction(_ sender: UIButton) { }
    
    @IBAction private func provideServiceButtonAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        setupProvideServiceView(for: sender.isSelected)
    }
    
    @IBAction private func providedServiceFromSegmentedControlAction(_ sender: UISegmentedControl) {
        accountType = AccountType(rawValue: sender.selectedSegmentIndex + 1) ?? .individual
    }
    
    @objc private func activityTypeButtonAction(_ sender: UIButton) {
        activityType = prepareCategories?.activityTypes?[sender.tag]
        prepareCategories?.activityTypes?.enumerated().forEach({ (index, _) in
            prepareCategories?.activityTypes?[index].isSelected = false
        })
        prepareCategories?.activityTypes?[sender.tag].isSelected.toggle()
        activityTypesReloadData()
    }
    
    @IBAction private func searchButtonAction(_ sender: UIButton) {
        searchTextField.becomeFirstResponder()
    }
    
    @IBAction private func addDocumentButtonAction(_ sender: UIButton) {
        showActionSheetForPhotoLibraryOrCamera()
    }
    
    @IBAction private func deleteDocumentButtonAction(_ sender: UIButton) {
        document = nil
        documentName = nil
        documentTitleLabel.text = Localization.signUp_addDocument.text
        deleteDocumentButton.isHidden = true
        selectedDocumentImageView.image = .iconClip
        selectedDocumentImageView.contentMode = .center
        selectedDocumentImageView.setBorder(withColor: .clear, andWidth: 0)
    }
    
    @IBAction private func continueButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        if isUpdatingProvideServiceInformation {
            guard let activityType = activityType?.id, !selectedCategories.isEmpty else {
                if selectedCategories.isEmpty {
                    showAlert(with: NetworkError.emptyCategories)
                }
                showAlert(with: NetworkError.somethingWentWrong)
                return
            }
            updateProfileRequest(isAlsoWorker: isAlsoWorker, accountType: accountType, activityType: activityType, categories: selectedCategories.map({ $0.id ?? 0 }), documents: documentName)
        } else {
            guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty, let name = nameTextField.text, !name.isEmpty, let email = emailTextField.text, !email.isEmpty, let phoneNumber = phoneNumberTextField.text?.phoneNumber, !phoneNumber.isEmpty, let password = passwordTextField.text, !password.isEmpty, let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty && confirmPassword == password else {
                showAlert(with: confirmPasswordTextField.text != passwordTextField.text ? NetworkError.passwordsNotEqual : NetworkError.invalidCredentials)
                return
            }
            signUpRequest(name: name, email: email, password: password, phoneNumber: phoneNumber, isAlsoWorker: isAlsoWorker, accountType: accountType, activityType: activityType?.id ?? 0, categories: selectedCategories.map({ $0.id ?? 0 }), documents: documentName)
        }
    }
    
    @IBAction private func backButtonAction(_ sender: UIButton) {
        if isUpdatingProvideServiceInformation {
            dismissViewController()
        } else {
            popViewController()
        }
    }
    
    @IBAction private func licenseAgreementsButtonAction(_ sender: UIButton) {
        pushToLicenseAgreementViewController()
    }
}

// MARK: Navigations
extension SignUpViewController {
    private func pushToLicenseAgreementViewController() {
        guard let viewController = viewController(from: .authorization, withIdentifier: .licenseAgreementViewController) as? LicenseAgreementViewController else { return }
        viewController.acceptButtonDidTapped = { [weak self] in
            guard let self = self else { return }
            self.isLicenseAgreementsAccepted = true
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func pushToPhoneNumberVerificationViewController(with accessToken: String?) {
        guard let viewController = viewController(from: .authorization, withIdentifier: .phoneNumberVerificationViewController) as? PhoneNumberVerificationViewController else { return }
        viewController.setAccessToken(accessToken)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: Requests
extension SignUpViewController {
    private func signUpRequest(name: String, email: String, password: String, phoneNumber: String, isAlsoWorker: Bool, accountType: AccountType?, activityType: Int?, categories: [Int]?, documents: String?) {
        showActivityIndicator()
        NetworkManager.shared.signUp(name: name, email: email, password: password, phoneNumber: phoneNumber, isAlsoWorker: isAlsoWorker, accountType: accountType, activityType: activityType, categories: categories, documents: documents) { [weak self] response in
            guard let self = self else { return }
            if response.isSuccess {
                ConfigDataProvider.currentProfile = response.profile
                self.pushToPhoneNumberVerificationViewController(with: response.token)
            } else {
                if let errorMessage = response.errors?.name?.first {
                    self.showAlert(with: errorMessage)
                } else if let errorMessage = response.errors?.email?.first {
                    self.showAlert(with: errorMessage)
                } else if let errorMessage = response.errors?.phone?.first {
                    self.showAlert(with: errorMessage)
                } else if let errorMessage = response.errors?.password?.first {
                    self.showAlert(with: errorMessage)
                } else if let errorMessage = response.message {
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
    
    private func prepareSignUpRequest() {
        NetworkManager.shared.prepareSignUp() { [weak self] response in
            guard let self = self else { return }
            self.prepareCategories = response
            self.activityTypesReloadData()
            self.categoriesTableView.reloadData()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(with: error)
        }
    }
    
    private func uploadFilesRequest() {
        if let document = document {
            showActivityIndicator()
            NetworkManager.shared.uploadFiles(with: document, type: .documents) { [weak self] documentTitle in
                guard let self = self else { return }
                self.documentName = documentTitle
                self.documentTitleLabel.text = documentTitle
                self.hideActivityIndicator()
            } failure: { [weak self] error in
                guard let self = self else { return }
                self.showAlert(with: error)
                self.hideActivityIndicator()
            }
        }
    }
    
    private func updateProfileRequest(isAlsoWorker: Bool, accountType: AccountType, activityType: Int, categories: [Int], documents: String?) {
        showActivityIndicator()
        NetworkManager.shared.updateProfile(isAlsoWorker: isAlsoWorker, accountType: accountType, activityType: activityType, categories: categories, documents: documents) { [weak self] profile in
            guard let self = self else { return }
            self.hideActivityIndicator()
            self.getProfileRequest()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(with: error)
            self.hideActivityIndicator()
        }
    }
    
    private func getProfileRequest() {
        showActivityIndicator()
        NetworkManager.shared.getProfile() { [weak self] response in
            guard let self = self else { return }
            ConfigDataProvider.currentProfile = response
            self.dismissViewController()
            self.profileDidSuccessfullyUpdated?()
            self.hideActivityIndicator()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(with: error)
            self.hideActivityIndicator()
        }
    }
}

// MARK: UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
            case phoneNumberTextField:
                if textField.text?.isEmpty ?? false {
                    textField.text = "+374 "
                }
                phoneNumberTitleLabel.isHidden = (textField.text?.count ?? 0) < 1
        default: break
        }
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let inputText = text.replacingCharacters(in: textRange, with: string)
            switch textField {
                case phoneNumberTextField:
                    textField.text = "+374 \(inputText.formattedPhoneNumber)"
                    phoneNumberTitleLabel.isHidden = inputText.count < 1
                    return false
                case nameTextField: nameTitleLabel.isHidden = inputText.count < 1
                case emailTextField: emailTitleLabel.isHidden = inputText.count < 1
                case passwordTextField: passwordTitleLabel.isHidden = inputText.count < 1
                case confirmPasswordTextField: confirmPasswordTitleLabel.isHidden = inputText.count < 1
                case searchTextField:
                    searchingCategoryName = inputText
                    categoriesTableView.reloadData()
            default: break
            }
        }
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(phoneNumberTextField.text?.phoneNumber ?? "")
        textField.resignFirstResponder()
        return true
    }
}

// MARK: UITableViewDelegate
extension SignUpViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

// MARK: UITableViewDataSource
extension SignUpViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categories[section].isExpanded {
            return categories[section].subCategories?.count ?? 0
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SelectableCategoryTableViewHeaderView.viewIdentifier) as? SelectableCategoryTableViewHeaderView
        view?.setData(from: categories[section] )
        view?.expandButtonDidTapped = { [weak self] in
            guard let self = self else { return }
            self.categories[section].isExpanded.toggle()
            DispatchQueue.main.async {
                self.categoriesTableView.reloadData()
            }
        }
        view?.selectButtonDidTapped = { [weak self] in
            guard let self = self else { return }
            if self.selectedCategories.count < 3 || self.categories[section].isSelected {
                self.categories[section].isSelected.toggle()
                self.updateSelectedCategries(self.categories[section])
                DispatchQueue.main.async {
                    self.categoriesTableView.reloadData()
                }
            }
        }
        return view
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
   
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectableSubcategoryTableViewCell.cellIdentifier, for: indexPath) as? SelectableSubcategoryTableViewCell, let subcategory = categories[indexPath.section].subCategories?[indexPath.row] else { return UITableViewCell() }
        cell.setData(from: subcategory)
        cell.selectButtonDidTapped = { [weak self] in
            guard let self = self else { return }
            if self.selectedCategories.count < 3 || subcategory.isSelected {
                subcategory.isSelected.toggle()
                self.updateSelectedCategries(subcategory)
                DispatchQueue.main.async {
                    self.categoriesTableView.reloadData()
                }
            }
        }
        return cell
    }
}

// MARK: KeyboardEventsDelegate
extension SignUpViewController {
    public override func keyboardDidChangeFrame(willShow: Bool, keyboardHeight: CGFloat, animationDuration: TimeInterval) {
        signUpScrollView.isScrollEnabled = willShow || provideServiceButton.isSelected
        signUpScrollView.contentInset.bottom = willShow ? keyboardHeight : 0
    }
}


// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension SignUpViewController {
    public override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                self.document = image.orientationFixed()
                self.deleteDocumentButton.isHidden = false
                self.selectedDocumentImageView.image = self.document
                self.selectedDocumentImageView.contentMode = .scaleAspectFill
                self.selectedDocumentImageView.setBorder(withColor: .hex_E5E5E5, andWidth: 1)
                self.uploadFilesRequest()
            }
        }
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
