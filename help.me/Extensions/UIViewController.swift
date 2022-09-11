//
//  UIViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 11/11/21.
//

import UIKit

extension UIViewController: UIGestureRecognizerDelegate {
    
    // MARK: Navigation Enums
    public enum StoryboardType: String {
        case authorization = "Authorization"
        case main = "Main"
    }
    
    public enum ViewControllerIdentifier: String {
        // MARK: Authorization
        case launchViewController = "LaunchViewController"
        case signInViewController = "SignInViewController"
        case recoveryViewController = "RecoveryViewController"
        case signUpViewController = "SignUpViewController"
        case phoneNumberVerificationViewController = "PhoneNumberVerificationViewController"
        case biometricAuthorizationViewController = "BiometricAuthorizationViewController"
        case licenseAgreementViewController = "LicenseAgreementViewController"
        
        // MARK: Main
        case tabBarController = "TabBarController"
        case homeViewController = "HomeViewController"
        case storyViewController = "StoryViewController"
        case seeAllViewController = "SeeAllViewController"
        case mapViewController = "MapViewController"
        case scanViewController = "ScanViewController"
        case offerViewController = "OfferViewController"
        case addWorkViewController = "AddWorkViewController"
        case addPhotoViewController = "AddPhotoViewController"
        case notificationsViewController = "NotificationsViewController"
        case chatViewController = "ChatViewController"
        case currentChatViewController = "CurrentChatViewController"
        case profileViewController = "ProfileViewController"
        case activeHistoryViewController = "ActiveHistoryViewController"
        case paymentCardsViewController = "PaymentCardsViewController"
        case scanPaymentCardViewController = "ScanPaymentCardViewController"
        case mobileViewController = "MobileViewController"
        case emailViewController = "EmailViewController"
        case languageViewController = "LanguageViewController"
        case contactUsViewController = "ContactUsViewController"
    }
    
    // MARK: Properties

    // MARK: Methods
    public func viewController(from storyboard: StoryboardType, withIdentifier identifier: ViewControllerIdentifier) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier.rawValue)
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
    
    public func setNavigationBarHidden(_ isHidden: Bool) {
        navigationController?.setNavigationBarHidden(isHidden, animated: true)
    }
    
    public func setNavigationBarClear() {
        setNavigationBar(color: .clear)
    }
    
    public func setNavigationBar(color: UIColor) {
        navigationController?.navigationBar.setBackgroundImage(color.shadowImage, for: .default)
    }
    
    public func setNavigationBarShadowHidden() {
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    public func setNavigationBarShadow(color: UIColor) {
        navigationController?.navigationBar.shadowImage = color.shadowImage
    }
    
    public func setNavigationBarTintColor(_ color: UIColor) {
        navigationController?.navigationBar.tintColor = color
    }
    
    public func setNavigationBarTitle(_ title: String) {
//        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.poppinsRegularFont(ofSize: 26)]
        self.title = title
        tabBarController?.tabBar.items?.forEach({ (item) in
            item.title = ""
        })
    }
    
    public func setNavigationBarBackButton(title: String = "", image: UIImage? = nil, action: Selector? = nil) {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        if let action = action {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button(with: title, image: image, andAction: action))
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button(with: title, image: image, andAction: #selector(navigationControllerBackButtonAction)))
        }
    }
    
    public func setNavigationBarLeftButton(title: String = "", image: UIImage? = nil, action: Selector) {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button(with: title, image: image, andAction: action))
    }
    
    public func setNavigationBarBackButtonHidden() {
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.leftBarButtonItems = []
        navigationItem.hidesBackButton = true
    }
    
    private func button(with title: String, image: UIImage? = nil, andAction action: Selector) -> UIButton {
        let backButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        backButton.addTarget(self, action: action, for: .touchUpInside)
        backButton.contentHorizontalAlignment = .left
//        backButton.setAttributedTitle(NSAttributedString(string: title, attributes: [.font : UIFont.poppinsRegularFont(ofSize: 26), .foregroundColor : UIColor.black]), for: .normal)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        backButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8)
        if let image = image {
            backButton.setImage(image, for: .normal)
        }
        return backButton
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: Actions
    @objc private func navigationControllerBackButtonAction() {
        navigationController?.popViewController(animated: true)
    }
}
