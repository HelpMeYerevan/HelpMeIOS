//
//  ContactUsViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 12/3/21.
//

import UIKit
import MessageUI

public final class ContactUsViewController: BaseViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var whatsAppBackgroundView: UIView!
    @IBOutlet private weak var messengerBackgroundView: UIView!
    @IBOutlet private weak var telegramBackgroundView: UIView!
    @IBOutlet private weak var viberBackgroundView: UIView!
    @IBOutlet private weak var emailButton: UIButton!
    @IBOutlet private weak var mobileButton: UIButton!
    @IBOutlet private weak var messageButton: UIButton!
    
    // MARK: Properties
    private var contactUsInformation: ContactUs? {
        didSet {
            whatsAppBackgroundView.isHidden = contactUsInformation?.whatsApp == nil
            messengerBackgroundView.isHidden = contactUsInformation?.facebookMessenger == nil
            telegramBackgroundView.isHidden = contactUsInformation?.telegram == nil
            viberBackgroundView.isHidden = contactUsInformation?.viber == nil
            emailButton.isHidden = contactUsInformation?.email == nil
            mobileButton.isHidden = contactUsInformation?.phoneNumber == nil
            messageButton.isHidden = contactUsInformation?.phoneNumber == nil
        }
    }
    private let shadowColor = UIColor.hex_000000.withAlphaComponent(0.1)

    
    // MARK: View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        getContactUsInformationRequest()
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        whatsAppBackgroundView.setShadow(with: shadowColor, shadowInsets: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), cornerRadius: Constants.cornerRadius_10)
        messengerBackgroundView.setShadow(with: shadowColor, shadowInsets: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), cornerRadius: Constants.cornerRadius_10)
        telegramBackgroundView.setShadow(with: shadowColor, shadowInsets: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), cornerRadius: Constants.cornerRadius_10)
        viberBackgroundView.setShadow(with: shadowColor, shadowInsets: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), cornerRadius: Constants.cornerRadius_10)
        emailButton.setShadow(with: shadowColor, shadowInsets: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), cornerRadius: Constants.cornerRadius_10)
        mobileButton.setShadow(with: shadowColor, shadowInsets: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), cornerRadius: Constants.cornerRadius_10)
        messageButton.setShadow(with: shadowColor, shadowInsets: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), cornerRadius: Constants.cornerRadius_10)
    }
    
    // MARK: Methods
    public override func setupView() {
        topView.setShadow(with: shadowColor, shadowInsets: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), cornerRadius: Constants.cornerRadius_15)
    }
    
    // MARK: Localization
    public override func setupLocalization() {
        backButton.setLocalizedString(.contactUs_contactUs)
    }
    
    // MARK: Actions
    @IBAction private func backButtonAction(_ sender: UIButton) {
        popViewController()
    }
    
    @IBAction private func whatsAppButtonAction(_ sender: UIButton) {
        guard let whatsApp = contactUsInformation?.whatsApp, let url = URL(string: "https://api.whatsapp.com/send?phone=\(whatsApp)") else { return }
        open(url)
    }
    
    @IBAction private func messengerButtonAction(_ sender: UIButton) {
        guard let facebookMessenger = contactUsInformation?.facebookMessenger, let url = URL(string: "fb-messenger://user-thread/\(facebookMessenger)") else { return }
        open(url)
    }
    
    @IBAction private func telegramButtonAction(_ sender: UIButton) {
        guard let telegram = contactUsInformation?.telegram, let url = URL(string: "tg://resolve?domain=\(telegram)") else { return }
        open(url)
    }
    
    @IBAction private func viberButtonAction(_ sender: UIButton) {
        guard let viber = contactUsInformation?.viber, let url = URL(string: "viber://forward?text=\(viber)") else { return }
        open(url)
    }
    
    @IBAction private func emailButtonAction(_ sender: UIButton) {
        guard let email = contactUsInformation?.email, let url = URL(string: "mailto:\(email)") else { return }
        open(url)
    }
    
    @IBAction private func mobileButtonAction(_ sender: UIButton) {
        guard let phoneNumber = contactUsInformation?.phoneNumber, let url = URL(string: "tel://\(phoneNumber)") else { return }
        open(url)
    }
    
    @IBAction private func messageButtonAction(_ sender: UIButton) {
        presentMFMessageComposeViewController()
    }
}

// MARK: Navigations
extension ContactUsViewController {
    private func presentMFMessageComposeViewController() {
        guard let phoneNumber = contactUsInformation?.phoneNumber else { return }
        let viewController = MFMessageComposeViewController()
        viewController.recipients = [phoneNumber]
        viewController.messageComposeDelegate = self
        present(viewController, animated: true)
    }
}

// MARK: Requests
extension ContactUsViewController {
    private func getContactUsInformationRequest() {
        showActivityIndicator()
        NetworkManager.shared.getContactUsInformation() { [weak self] response in
            guard let self = self else { return }
            self.contactUsInformation = response
            self.hideActivityIndicator()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(with: error)
            self.hideActivityIndicator()
        }
    }
}

// MARK: MFMessageComposeViewControllerDelegate
extension ContactUsViewController: MFMessageComposeViewControllerDelegate {
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true)
    }
}
