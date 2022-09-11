//
//  TopWorkersCompaniesCollectionViewCell.swift
//  help.me
//
//  Created by Karen Galoyan on 11/13/21.
//

import UIKit
import Alamofire

public final class TopWorkersCompaniesCollectionViewCell: UICollectionViewCell {
    
    // MARK: Outlets
    @IBOutlet private weak var workerCompanyImageView: UIImageView!
    @IBOutlet private weak var verifiedImageView: UIImageView!
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: Properties
    public static let cellNibName = UINib(nibName: "TopWorkersCompaniesCollectionViewCell", bundle: nil)
    public static let cellIdentifier = "TopWorkersCompaniesCollectionViewCell"
    private var avatarURL = ""
    
    // MARK: View Lifecycle
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Methods
    private func setupView() {
        let height = 126 / 667 * UIScreen.main.bounds.height
        let width = 77 / 126 * height
        workerCompanyImageView.backgroundColor = .placeholderBackgroundColor
        workerCompanyImageView.setCornerRadius((width - 7) / 2)
    }
    
    public func setData(from model: User) {
        setupView()
//        if model.isVerified {
//            workerCompanyImageView.setBorder(withColor: .hex_6BC24D, andWidth: 2)
//        }
//        verifiedImageView.isHidden = !model.isVerified
        fullNameLabel.text = model.name
        categoryLabel.text = model.categoryName
        ratingLabel.text = "\(model.rating)"
        avatarURL = model.avatarURL
        activityIndicatorView.startAnimating()
        if model.thumbnailImage != nil {
            workerCompanyImageView.image = model.thumbnailImage
            activityIndicatorView.stopAnimating()
        } else {
            setImage(from: model)
        }
    }
}

// MARK: Requests
extension TopWorkersCompaniesCollectionViewCell {
    func setImage(from model: User) {
        workerCompanyImageView.image = UIImage()
        AF.request(model.avatarURL).responseData { response in
            DispatchQueue.global(qos: .userInitiated).async {
                if let image = response.data {
                    model.originaImage = UIImage(data: image)
                    model.thumbnailImage = model.originaImage?.thumbnail
                    DispatchQueue.main.async {
                        if response.request?.url?.absoluteString == self.avatarURL {
                            self.workerCompanyImageView.image = model.thumbnailImage
                            self.activityIndicatorView.stopAnimating()
                        }
                    }
                }
            }
        }
    }
}
