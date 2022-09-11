//
//  ChatTableViewCell.swift
//  help.me
//
//  Created by Karen Galoyan on 11/25/21.
//

import UIKit

public final class ChatTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet private weak var chatShadowView: UIView!
    @IBOutlet private weak var chatBackgraundView: UIView!
    @IBOutlet private weak var borderView: UIView!
    @IBOutlet private weak var workImageView: UIImageView!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var categoryTitleLabel: UILabel!
    @IBOutlet private weak var profileNameLabel: UILabel!
    @IBOutlet private weak var receivedMessageBackgroundView: UIView!
    @IBOutlet private weak var receivedMessageView: UIView!
    @IBOutlet private weak var receivedMessageLabel: UILabel!
    @IBOutlet private weak var sentMessageBackgroundView: UIView!
    @IBOutlet private weak var sentMessageView: UIView!
    @IBOutlet private weak var sentMessageLabel: UILabel!
    @IBOutlet private weak var isActiveView: UIView!
    
    // MARK: Properties
    public static let cellNibName = UINib(nibName: "ChatTableViewCell", bundle: nil)
    public static let cellIdentifier = "ChatTableViewCell"
    private var model: ChatModel?
    
    // MARK: View Lifecycle
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupGradient()
        setupShadows()
        setupBorder()
    }
    
    // MARK: Methods
    private func setupView() {
        chatBackgraundView.setCornerRadius(Constants.cornerRadius_10)
        profileImageView.setCornerRadius(profileImageView.frame.height / 2)
        profileImageView.setBorder(withColor: .hex_FFFFFF, andWidth: 2)
    }
    
    private func setupBorder() {
        borderView.setBorder(withColor: .hex_6CC24D, width: 2, corners: [.topRight, .bottomRight], andRadius: Constants.cornerRadius_10)
    }
    
    private func setupGradient() {
        receivedMessageView.setGradient(with: [UIColor.hex_C4C4C4.cgColor, UIColor.hex_E5E5E5.cgColor], with: receivedMessageView.frame.height / 2)
        sentMessageView.setGradient(with: [UIColor.hex_46BC6C.cgColor, UIColor.hex_6CC24D.cgColor], with: sentMessageView.frame.height / 2)
    }
    
    private func setupShadows() {
        chatShadowView.setShadow(with: UIColor.shadow.withAlphaComponent(0.3), shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 3, cornerRadius: Constants.cornerRadius_10)
    }
    
    public func setData(from model: ChatModel) {
        self.model = model
        setupView()
        workImageView.image = model.workImage
        profileImageView.image = model.worker.image
        categoryTitleLabel.text = model.categoryName
        profileNameLabel.text = model.worker.workerName
        if model.messages.last?.isOwnerMessage ?? false {
            receivedMessageBackgroundView.isHidden = true
            sentMessageBackgroundView.isHidden = false
            sentMessageLabel.text = model.messages.last?.message
        } else {
            receivedMessageBackgroundView.isHidden = false
            sentMessageBackgroundView.isHidden = true
            receivedMessageLabel.text = model.messages.last?.message
        }
        isActiveView.isHidden = model.isActive
    }
}
