//
//  FullscreenStoryCollectionViewCell.swift
//  help.me
//
//  Created by Karen Galoyan on 2/6/22.
//

import UIKit
import Alamofire

class FullscreenStoryCollectionViewCell: UICollectionViewCell {

    // MARK: Outlets
    @IBOutlet private weak var storyImageView: UIImageView!
    @IBOutlet private weak var progressView: UIView!
    @IBOutlet private weak var progressViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var readMoreButton: UIButton!
    
    // MARK: Properties
    public static let cellNibName = UINib(nibName: "FullscreenStoryCollectionViewCell", bundle: nil)
    public static let cellIdentifier = "FullscreenStoryCollectionViewCell"
    private var imageURL = ""
    public var readMoreButtonDidTapped: (() -> Void)?

    // MARK: View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Methods
    private func setupProgressView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIView.animate(withDuration: Constants.defaultStoryShowingTime) {
                self.progressViewWidthConstraint.constant = UIScreen.main.bounds.width
                self.layoutIfNeeded()
            } completion: { [unowned self] isFinished in
                if isFinished {
                    self.progressViewWidthConstraint.constant = 0
                }
            }
        }
    }
    
    public func setData(from model: Story) {
        setupLocalization()
        progressViewWidthConstraint.constant = 0
        if model.isStoryVisible {
            setupProgressView()
        }
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        imageURL = model.imageURL
        activityIndicatorView.startAnimating()
        if model.thumbnailImage != nil {
            storyImageView.image = model.thumbnailImage
            activityIndicatorView.stopAnimating()
        } else {
            setImage(from: model)
        }
    }
    
    public func resetProgressView() {
        progressViewWidthConstraint.constant = 0
    }
    
    // MARK: Localization
    public func setupLocalization() {
        readMoreButton.setLocalizedString(.story_readMore)
    }
    
    // MARK: Action
    @IBAction private func readMoreButtonAction(_ sender: UIButton) {
        readMoreButtonDidTapped?()
    }
}

// MARK: Requests
extension FullscreenStoryCollectionViewCell {
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
