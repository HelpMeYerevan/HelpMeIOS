//
//  ProfileViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 11/24/21.
//

import UIKit

public final class ProfileViewController: BaseViewController {

    // MARK: Outlets
    @IBOutlet private weak var settingsButton: UIButton!
    @IBOutlet private weak var balanceStackView: UIStackView!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var profileAvatarImageView: UIImageView!
    @IBOutlet private weak var editProfileAvatarButton: UIButton!
    @IBOutlet private weak var profileNameLabel: UILabel!
    @IBOutlet private weak var profileIdLabel: UILabel!
    @IBOutlet private weak var profileRateLabel: UILabel!
    @IBOutlet private weak var profileStatusLabel: UILabel!
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var addWorkButton: UIButton!
    @IBOutlet private weak var permissionView: UIView!
    @IBOutlet private weak var addWorkView: UIView!
    @IBOutlet private weak var worksView: UIView!
    @IBOutlet private weak var emptyWorksTextLabel: UILabel!
    @IBOutlet private weak var settingsView: UIView!
    @IBOutlet private weak var settingsViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var settingsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var permissionViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet private weak var activeButton: UIButton!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet private weak var historyButton: UIButton!
    @IBOutlet weak var creditCardLabel: UILabel!
    @IBOutlet private weak var creditCardButton: UIButton!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet private weak var phoneNumberButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet private weak var emailButton: UIButton!
    @IBOutlet weak var provideServicesLabel: UILabel!
    @IBOutlet private weak var providedServicesButton: UIButton!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet private weak var categoriesButton: UIButton!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet private weak var languageButton: UIButton!
    @IBOutlet private weak var extraSettingsArrowImageView: UIImageView!
    @IBOutlet private weak var languageStackView: UIStackView!
    @IBOutlet weak var biometricAuthorizationLabel: UILabel!
    @IBOutlet private weak var biometricAuthorizationStackView: UIStackView!
    @IBOutlet private weak var biometricAuthorizationImageView: UIImageView!
    @IBOutlet private weak var biometricAuthorizationTitleLabel: UILabel!
    @IBOutlet private weak var biometricAuthorizationButton: UIButton!
    @IBOutlet private weak var contactUsButton: UIButton!
    @IBOutlet private weak var termsAndConditionsButton: UIButton!
    @IBOutlet private weak var signOutButton: UIButton!
    @IBOutlet private weak var appVersionLabel: UILabel!
    
    // MARK: Properties
    private var settingsViewHeight: CGFloat {
        return UIScreen.main.bounds.height - 125 - (UIApplication.sceneDelegateWindow?.safeAreaInsets.top ?? 0)
    }
    private var isExtraSettingsHidden = true
    private var updatedAvatar: UIImage?
    private var updatedAvatarName: String?
    private var selectedUser: User?
    
    // MARK: View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedUser = selectedUser {
            setupUser(selectedUser)
        } else {
            setupProfile()
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileAvatarImageView.setCornerRadius(profileAvatarImageView.frame.height / 2)
        editProfileAvatarButton.setCornerRadius(editProfileAvatarButton.frame.height / 2)
        editProfileAvatarButton.setShadow(with: .hex_B98538, cornerRadius: editProfileAvatarButton.frame.height / 2)
    }
    
    // MARK: Methods
    public override func setupView() {
        let profileStatusColor = profile?.profileStatus.color ?? UIColor.hex_B98538
        topView.setShadow(shadowInsets: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), cornerRadius: Constants.cornerRadius_15)
        addWorkButton.setCornerRadius(Constants.cornerRadius_10)
        profileAvatarImageView.tintColor = profileStatusColor
        profileAvatarImageView.setBorder(withColor: profileStatusColor, andWidth: 3)
        profileStatusLabel.textColor = profileStatusColor
        settingsViewTopConstraint.constant = settingsViewHeight
        settingsViewHeightConstraint.constant = settingsViewHeight
        permissionViewBottomConstraint.constant = tabBarController?.tabBar.frame.height ?? 0
        appVersionLabel.text = "help.me | \(UIApplication.releaseVersionNumber ?? "1.0") (\(UIApplication.buildVersionNumber ?? "1"))"
    }
    
    private func setupProfile() {
        profileNameLabel.text = profile?.name
        profileIdLabel.text = profile?.meID
        amountLabel.text = profile?.balance
        if let avatar = profile?.avatar {
            profileAvatarImageView.image = avatar
        } else {
            profileAvatarImageView.image = .iconProfileDefaultAvatar
            setProfileAvatar()
        }
        creditCardButton.setTitle(profile?.selectedPaymentCard, for: .normal)
        phoneNumberButton.setTitle(profile?.phoneNumber, for: .normal)
        emailButton.setTitle(profile?.email, for: .normal)
        profileRateLabel.text = "\(profile?.rating ?? 0)"
        profileStatusLabel.text = profile?.profileStatus.title
        activeButton.setTitle("\(profile?.active ?? 0)", for: .normal)
        historyButton.setTitle("\(profile?.active ?? 0)", for: .normal)
        languageButton.setTitle(ConfigDataProvider.currentLanguage.name, for: .normal)
        providedServicesButton.isSelected = profile?.isAlsoWorker ?? false
        biometricAuthorizationButton.isSelected = ConfigDataProvider.isBiometricAuthorizationEnabled
    }
    
    private func setupUser(_ user: User) {
        settingsButton.setImage(.iconArrowLeft, for: .normal)
        settingsButton.setLocalizedString(.profile_profilePage)
        profileNameLabel.text = user.name
        editProfileAvatarButton.isHidden = true
        balanceStackView.isHidden = true
        profileIdLabel.isHidden = true
        if let avatar = user.thumbnailImage {
            profileAvatarImageView.image = avatar
        } else {
            setProfileAvatar()
        }
        addWorkButton.setLocalizedString(.profile_addWork)
        profileRateLabel.text = "\(user.rating)"
        emptyWorksTextLabel.setLocalizedString(.profile_emptyWorks)
    }
    
    public func setSelectedUser(_ user: User) {
        selectedUser = user
    }
    
    // MARK: Localization
    public override func setupLocalization() {
        settingsButton.setLocalizedString(.profile_settings)
        profileIdLabel.setLocalizedString(.profile_id)
        profileStatusLabel.setLocalizedString(.profile_bronze)
        if selectedUser == nil {
            emptyWorksTextLabel.setLocalizedString(.profile_emptyPhotos)
            addWorkButton.setLocalizedString(.profile_addPhoto)
        } else {
            emptyWorksTextLabel.setLocalizedString(.profile_emptyWorks)
            addWorkButton.setLocalizedString(.profile_addWork)
        }
        activeLabel.setLocalizedString(.profile_active)
        historyLabel.setLocalizedString(.profile_history)
        creditCardLabel.setLocalizedString(.profile_creditCard)
        if let selectedPaymentCard = profile?.selectedPaymentCard {
            creditCardButton.setTitle(selectedPaymentCard, for: .normal)
        } else {
            creditCardButton.setLocalizedString(.profile_addNew)
        }
        phoneNumberLabel.setLocalizedString(.profile_mobile)
        emailLabel.setLocalizedString(.profile_eMail)
        provideServicesLabel.setLocalizedString(.profile_alsoProvideServices)
        categoriesLabel.setLocalizedString(.profile_categories)
        languageLabel.setLocalizedString(.profile_language)
        settingsLabel.setLocalizedString(.profile_settings)
        if biometricType == .faceID {
            biometricAuthorizationLabel.setLocalizedString(.profile_signInWithFaceID)
        } else {
            biometricAuthorizationLabel.setLocalizedString(.profile_signInWithTouchID)
        }
        contactUsButton.setLocalizedString(.profile_contactUs)
        termsAndConditionsButton.setLocalizedString(.profile_termsConditions)
        signOutButton.setLocalizedString(.profile_signOut)
    }
    
    // MARK: Actions
    @IBAction private func editProfileAvatarButtonAction(_ sender: UIButton) {
        showActionSheetForPhotoLibraryOrCamera()
    }
    
    @IBAction private func settingsButtonAction(_ sender: UIButton) {
        if selectedUser != nil {
            popViewController()
        } else {
            UIView.animate(withDuration: Constants.animationDuration) {
                self.settingsViewTopConstraint.constant = self.settingsViewTopConstraint.constant == 0 ? self.settingsViewHeight : 0
                self.view.layoutIfNeeded()
            } completion: { _ in
                
            }
            settingsButton.setImage(settingsViewTopConstraint.constant == 0 ? .iconArrowLeft : .iconSettings, for: .normal)
            settingsButton.setTitle(settingsViewTopConstraint.constant != 0 ? Localization.profile_settings.text : Localization.profile_profilePage.text, for: .normal)
            tabBarController?.setTabBarHidden(settingsViewTopConstraint.constant == 0)
        }
    }
    
    @IBAction private func addWorkButtonAction(_ sender: UIButton) {
        pushToScanViewController()
    }
    
    @IBAction private func activeButtonAction(_ sender: UIButton) {
        pushToActiveHistoryViewController(with: .active)
    }
    
    @IBAction private func historyButtonAction(_ sender: UIButton) {
        pushToActiveHistoryViewController(with: .history)
    }
    
    @IBAction private func creditCardButtonAction(_ sender: UIButton) {
        pushToPaymentCardsViewController()
    }
    
    @IBAction private func phoneNumberButtonAction(_ sender: UIButton) {
        pushToMobileViewController()
    }
    
    @IBAction private func emailButtonAction(_ sender: UIButton) {
        pushToEmailViewController()
    }
    
    @IBAction private func providedServicesButton(_ sender: UIButton) {
        guard let isAlsoWorker = profile?.isAlsoWorker, !isAlsoWorker else { return }
        presentSignUpViewController()
    }
    
    @IBAction private func categoriesButtonAction(_ sender: UIButton) {
        showDevelopmentAlert()
    }
    
    @IBAction private func extraSettingsButtonAction(_ sender: UIButton) {
        isExtraSettingsHidden.toggle()
        extraSettingsArrowImageView.image = isExtraSettingsHidden ? .iconArrowDown : .iconArrowUp
        languageStackView.isHidden.toggle()
        biometricAuthorizationStackView.isHidden.toggle()
        contactUsButton.isHidden.toggle()
        termsAndConditionsButton.isHidden.toggle()
        signOutButton.isHidden.toggle()
    }
    
    @IBAction private func languageButtonAction(_ sender: UIButton) {
        pushToLanguageViewController()
    }
    
    @IBAction private func biometricAuthorizationButtonAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        canEvaluatePolicyForDeviceOwnerAuthentication { [weak self] canEvaluate in
            guard let self = self else { return }
            if canEvaluate {
                self.evaluatePolicyForDeviceOwnerAuthentication { [weak sender] isSuccess in
                    guard let sender = sender else { return }
                    if isSuccess {
                        DispatchQueue.main.async {
                            ConfigDataProvider.isBiometricAuthorizationEnabled = sender.isSelected
                        }
                    }
                }
            }
        }
    }
    
    @IBAction private func contactUsButtonAction(_ sender: UIButton) {
        pushToContactUsViewController()
    }
    
    @IBAction private func termsAndConditionsButtonAction(_ sender: UIButton) {
        showDevelopmentAlert()
    }
    
    @IBAction private func signOutButtonAction(_ sender: UIButton) {
        signOutRequest()
    }
}

// MARK: Navigations
extension ProfileViewController {
    private func pushToActiveHistoryViewController(with type: HistoryType) {
        guard let viewController = viewController(from: .main, withIdentifier: .activeHistoryViewController) as? ActiveHistoryViewController else { return }
        viewController.setType(type)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func pushToPaymentCardsViewController() {
        guard let viewController = viewController(from: .main, withIdentifier: .paymentCardsViewController) as? PaymentCardsViewController else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func pushToMobileViewController() {
        guard let viewController = viewController(from: .main, withIdentifier: .mobileViewController) as? MobileViewController else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func pushToEmailViewController() {
        guard let viewController = viewController(from: .main, withIdentifier: .emailViewController) as? EmailViewController else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func pushToLanguageViewController() {
        guard let viewController = viewController(from: .main, withIdentifier: .languageViewController) as? LanguageViewController else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func pushToContactUsViewController() {
        guard let viewController = viewController(from: .main, withIdentifier: .contactUsViewController) as? ContactUsViewController else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func pushToScanViewController() {
        guard let viewController = viewController(from: .main, withIdentifier: .scanViewController) as? ScanViewController else { return }
        viewController.setType(selectedUser == nil ? .photo : .work)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func presentSignUpViewController() {
        guard let viewController = viewController(from: .authorization, withIdentifier: .signUpViewController) as? SignUpViewController else { return }
        viewController.setProvideServiceInformation(to: true)
        viewController.profileDidSuccessfullyUpdated = { [weak self] in
            guard let self = self else { return }
            self.providedServicesButton.isSelected = self.profile?.isAlsoWorker ?? false
        }
        present(viewController, animated: true)
    }
    
    private func popToSignInViewController() {
        guard let viewController = viewController(from: .authorization, withIdentifier: .signInViewController) as? SignInViewController else { return }
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .custom
        navigationController.navigationBar.isHidden = true
        UIApplication.sceneDelegateWindow?.rootViewController = navigationController
        UIApplication.sceneDelegateWindow?.makeKeyAndVisible()
    }
}

// MARK: Requests
extension ProfileViewController {
    private func getProfileRequest() {
        showActivityIndicator()
        NetworkManager.shared.getProfile() { [weak self] response in
            guard let self = self else { return }
            ConfigDataProvider.currentProfile = response
            self.hideActivityIndicator()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(with: error)
            self.hideActivityIndicator()
        }
    }
    
    private func uploadAvatarRequest() {
        if let updatedAvatar = updatedAvatar {
            showActivityIndicator()
            NetworkManager.shared.uploadFiles(with: updatedAvatar, type: .avatar) { [weak self] updatedAvatarName in
                guard let self = self else { return }
                self.updatedAvatarName = updatedAvatarName
                self.updateProfileRequest()
            } failure: { [weak self] error in
                guard let self = self else { return }
                self.showAlert(with: error)
                self.hideActivityIndicator()
            }
        }
    }
    
    private func setProfileAvatar() {
        var avatarName = ""
        if let selectedUser = selectedUser {
            avatarName = selectedUser.avatarName
        } else {
            avatarName = profile?.avatarName ?? ""
        }
        NetworkManager.shared.getImage(with: avatarName) { [weak self] avatar in
            guard let self = self else { return }
            self.profileAvatarImageView.image = avatar
            ConfigDataProvider.currentProfile?.avatar = avatar
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(with: error)
            self.hideActivityIndicator()
        }
    }
    
    private func updateProfileRequest() {
        NetworkManager.shared.updateProfile(with: updatedAvatarName) { [weak self] profile in
            guard let self = self else { return }
            ConfigDataProvider.currentProfile = profile
            self.setupProfile()
            self.hideActivityIndicator()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(with: error)
            self.hideActivityIndicator()
        }
    }
    
    private func signOutRequest() {
        showActivityIndicator()
        NetworkManager.shared.signOut() { [weak self] response in
            guard let self = self else { return }
            if response.isSuccess {
                ConfigDataProvider.accessToken = nil
                ConfigDataProvider.currentProfile = nil
                self.popToSignInViewController()
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

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ProfileViewController {
    public override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                self.updatedAvatar = image.orientationFixed()
                self.uploadAvatarRequest()
            }
        }
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
