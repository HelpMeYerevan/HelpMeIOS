//
//  OfferViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 3/9/22.
//

import UIKit
import Alamofire

final public class OfferViewController: BaseViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var profileAvatarButton: UIButton!
    @IBOutlet private weak var profileFullNameLabel: UILabel!
    @IBOutlet private weak var profileRateLabel: UILabel!
    @IBOutlet private weak var workImageView: UIImageView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var categoryNameLabel: UILabel!
    @IBOutlet private weak var createdDateLabel: UILabel!
    @IBOutlet private weak var addressStackView: UIStackView!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var priceStackView: UIStackView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var informationStackView: UIStackView!
    @IBOutlet private weak var informationLabel: UILabel!
    @IBOutlet private weak var dateStackView: UIStackView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var walletStackView: UIStackView!
    @IBOutlet private weak var walletLabel: UILabel!
    @IBOutlet private weak var skipOfferButton: UIButton!
    @IBOutlet private weak var applyButton: UIButton!
    
    // MARK: Properties
    private var selectedWork: Work?

    // MARK: View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupWork()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.setTabBarHidden(true)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.setTabBarHidden(false)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        workImageView.roundCorners(topLeft: 0, topRight: 0, bottomLeft: 20, bottomRight: 20)
    }

    // MARK: Methods
    public override func setupView() {
        topView.setShadow(shadowInsets: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
        workImageView.setShadow(shadowInsets: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
    }
    
    private func setupWork() {
        guard let selectedWork = selectedWork else { return }
        categoryNameLabel.text = selectedWork.category?.translate?.name ?? selectedWork.translate?.name
        informationLabel.text = selectedWork.workDescription
        addressLabel.text = selectedWork.address
        priceLabel.text = selectedWork.price
        if let originalImage = selectedWork.originalImage {
            workImageView.image = originalImage
            activityIndicatorView.stopAnimating()
        } else {
            setImage(from: selectedWork)
        }
    }
    
    public func setSelectedWork(_ work: Work) {
        selectedWork = work
    }
    
    // MARK: Localization
    public override func setupLocalization() {
        skipOfferButton.setLocalizedString(.offer_skipOffer)
        applyButton.setLocalizedString(.offer_apply)
    }

    // MARK: Actions
    @IBAction private func backButtonAction(_ sender: UIButton) {
        popViewController()
    }
    
    @IBAction private func profileAvatarButtonAction(_ sender: UIButton) {
    }
    
    @IBAction private func skipOfferButtonAction(_ sender: UIButton) {
        popViewController()
    }
    
    @IBAction private func applyButtonAction(_ sender: UIButton) {
        popViewController()
    }
}

// MARK: Requests
extension OfferViewController {
    func setImage(from model: Work) {
        workImageView.image = UIImage()
        AF.request(model.imageURL).responseData { response in
            DispatchQueue.global(qos: .userInitiated).async {
                if let image = response.data {
                    model.originalImage = UIImage(data: image)
                    model.thumbnailImage = model.originalImage?.thumbnail
                    DispatchQueue.main.async {
                        self.workImageView.image = model.originalImage
                        self.activityIndicatorView.stopAnimating()
                    }
                }
            }
        }
    }
}
