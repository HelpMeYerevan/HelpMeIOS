//
//  WorkersTableViewCell.swift
//  help.me
//
//  Created by Karen Galoyan on 11/24/21.
//

import UIKit
import Alamofire

class WorkersTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet private weak var workerCompanyImageView: UIImageView!
    @IBOutlet private weak var verifiedImageView: UIImageView!
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: Properties
    public static let cellNibName = UINib(nibName: "WorkersTableViewCell", bundle: nil)
    public static let cellIdentifier = "WorkersTableViewCell"
    private var avatarURL = ""

    // MARK: View Lifecycle
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Methods
    private func setupView() {
        workerCompanyImageView.backgroundColor = .placeholderBackgroundColor
        workerCompanyImageView.setCornerRadius(workerCompanyImageView.frame.height / 2)
    }
    
    public func setData(from model: User) {
        setupView()
//        if model.isVerified {
//            verifiedImageView.isHidden = false
//            workerCompanyImageView.setBorder(withColor: .hex_6BC24D, andWidth: 2)
//        } else {
//            verifiedImageView.isHidden = true
//            workerCompanyImageView.setBorder(withColor: .clear, andWidth: 0)
//        }
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
extension WorkersTableViewCell {
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
