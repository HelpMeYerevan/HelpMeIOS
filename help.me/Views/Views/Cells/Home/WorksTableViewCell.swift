//
//  WorksTableViewCell.swift
//  help.me
//
//  Created by Karen Galoyan on 11/24/21.
//

import UIKit
import Alamofire

public final class WorksTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet private weak var workShadowView: UIView!
    @IBOutlet private weak var workBackgraundView: UIView!
    @IBOutlet private weak var workImageView: UIImageView!
    @IBOutlet private weak var workNameLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: Properties
    public static let cellNibName = UINib(nibName: "WorksTableViewCell", bundle: nil)
    public static let cellIdentifier = "WorksTableViewCell"
    private var imageURL = ""
    
    // MARK: View Lifecycle
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupShadows()
    }
    
    // MARK: Methods
    private func setupView() {
        workImageView.backgroundColor = .placeholderBackgroundColor
        workBackgraundView.setCornerRadius(Constants.cornerRadius_10)
    }
    
    private func setupShadows() {
        workShadowView.setShadow(with: UIColor.shadow.withAlphaComponent(0.3), shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 3, cornerRadius: Constants.cornerRadius_10)
    }
    
    public func setData(from model: Work) {
        setupView()
        workNameLabel.text = model.category?.translate?.name
        addressLabel.text = model.address
        priceLabel.text = model.price
        infoLabel.text = model.workDescription
//        timeLabel.text = model.time
        imageURL = model.imageURL
        activityIndicatorView.startAnimating()
        if model.thumbnailImage != nil {
            workImageView.image = model.thumbnailImage
            activityIndicatorView.stopAnimating()
        } else {
            setImage(from: model)
        }
    }
}

// MARK: Requests
extension WorksTableViewCell {
    func setImage(from model: Work) {
        workImageView.image = UIImage()
        AF.request(model.imageURL).responseData { response in
            DispatchQueue.global(qos: .userInitiated).async {
                if let image = response.data {
                    model.originalImage = UIImage(data: image)
                    model.thumbnailImage = model.originalImage?.thumbnail
                    DispatchQueue.main.async {
                        if response.request?.url?.absoluteString == self.imageURL {
                            self.workImageView.image = model.thumbnailImage
                            self.activityIndicatorView.stopAnimating()
                        }
                    }
                }
            }
        }
    }
}
