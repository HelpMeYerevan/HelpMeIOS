//
//  StoriesCollectionViewCell.swift
//  help.me
//
//  Created by Karen Galoyan on 11/13/21.
//

import UIKit
import Alamofire

public final class StoriesCollectionViewCell: UICollectionViewCell {

    // MARK: Outlets
    @IBOutlet private weak var storyImageView: UIImageView!
    @IBOutlet private weak var gradientImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    // MARK: Properties
    public static let cellNibName = UINib(nibName: "StoriesCollectionViewCell", bundle: nil)
    public static let cellIdentifier = "StoriesCollectionViewCell"
    private var imageURL = ""

    // MARK: View Lifecycle
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Methods
    private func setupView() {
        storyImageView.backgroundColor = .placeholderBackgroundColor
        setCornerRadius(Constants.cornerRadius_10)
        storyImageView.setCornerRadius(Constants.cornerRadius_10)
        gradientImageView.setCornerRadius(Constants.cornerRadius_10)
        gradientImageView.image = .imageGradient
    }
    
    public func setData(from model: Story) {
        setupView()
        titleLabel.text = model.title
        imageURL = model.imageURL
        activityIndicatorView.startAnimating()
        if model.thumbnailImage != nil {
            storyImageView.image = model.thumbnailImage
            activityIndicatorView.stopAnimating()
        } else {
            setImage(from: model)
        }
    }
}

// MARK: Requests
extension StoriesCollectionViewCell {
    func setImage(from model: Story) {
        storyImageView.image = UIImage()
        AF.request(model.imageURL).responseData { response in
            DispatchQueue.global(qos: .userInitiated).async {
                if let image = response.data {
                    model.originaImage = UIImage(data: image)
                    model.thumbnailImage = model.originaImage?.thumbnail
                    DispatchQueue.main.async {
                        if response.request?.url?.absoluteString == self.imageURL {
                            self.storyImageView.image = model.thumbnailImage
                            self.activityIndicatorView.stopAnimating()
                        }
                    }
                }
            }
        }
    }
}
