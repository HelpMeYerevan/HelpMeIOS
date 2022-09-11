//
//  LicenseAgreementViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 11/16/21.
//

import UIKit

public final class LicenseAgreementViewController: BaseViewController {

    // MARK: Outlets
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var licenseAgreementScrollView: UIScrollView!
    @IBOutlet private weak var licenseAgreementLabel: UILabel!
    @IBOutlet private weak var acceptButton: UIButton!
    
    // MARK: Properties
    public var acceptButtonDidTapped: (() -> Void)?
    
    // MARK: View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Methods
    public override func setupView() {
        topView.setShadow(shadowInsets: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
        licenseAgreementScrollView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        acceptButton.setCornerRadius(Constants.cornerRadius_10)
    }
    
    // MARK: Localization
    public override func setupLocalization() {
        backButton.setLocalizedString(.licenseAgreement_licenseAgreement)
        acceptButton.setLocalizedString(.licenseAgreement_accept)
    }
    
    // MARK: Actions
    @IBAction private func backButtonAction(_ sender: UIButton) {
        popViewController()
    }
    
    @IBAction private func acceptButtonAction(_ sender: UIButton) {
        acceptButtonDidTapped?()
        popViewController()
    }
}
