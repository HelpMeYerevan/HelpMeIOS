//
//  LastWorksCollectionViewCell.swift
//  help.me
//
//  Created by Karen Galoyan on 11/13/21.
//

import UIKit
import Alamofire

public final class LastWorksCollectionViewCell: UICollectionViewCell {

    // MARK: Outlets
    @IBOutlet private weak var lastWorkImageView: UIImageView!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: Properties
    public static let cellNibName = UINib(nibName: "LastWorksCollectionViewCell", bundle: nil)
    public static let cellIdentifier = "LastWorksCollectionViewCell"
    private var imageURL = ""

    // MARK: View Lifecycle
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Methods
    private func setupView() {
        lastWorkImageView.backgroundColor = .placeholderBackgroundColor
        lastWorkImageView.setCornerRadius(Constants.cornerRadius_10)
    }
    
    public func setData(from model: Work) {
        setupView()
        categoryLabel.text = model.category?.translate?.name
//        fullNameLabel.text = model.workerName
//        timeLabel.text = model.time
        imageURL = model.imageURL
        activityIndicatorView.startAnimating()
        if model.thumbnailImage != nil {
            lastWorkImageView.image = model.thumbnailImage
            activityIndicatorView.stopAnimating()
        } else {
            setImage(from: model)
        }
    }
}

// MARK: Requests
extension LastWorksCollectionViewCell {
    func setImage(from model: Work) {
        lastWorkImageView.image = UIImage()
        AF.request(model.imageURL).responseData { response in
            DispatchQueue.global(qos: .userInitiated).async {
                if let image = response.data {
                    model.originalImage = UIImage(data: image)
                    model.thumbnailImage = model.originalImage?.thumbnail
                    DispatchQueue.main.async {
                        if response.request?.url?.absoluteString == self.imageURL {
                            self.lastWorkImageView.image = model.thumbnailImage
                            self.activityIndicatorView.stopAnimating()
                        }
                    }
                }
            }
        }
    }
}
