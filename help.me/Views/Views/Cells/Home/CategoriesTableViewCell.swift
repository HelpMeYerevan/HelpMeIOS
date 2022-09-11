//
//  CategoriesTableViewCell.swift
//  help.me
//
//  Created by Karen Galoyan on 11/24/21.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet private weak var checkmarkImageView: UIImageView!
    @IBOutlet private weak var categoryTitleLabel: UILabel!
    @IBOutlet private weak var separatorView: UIView!
    
    // MARK: Properties
    static let cellNibName = UINib(nibName: "CategoriesTableViewCell", bundle: nil)
    static let cellIdentifier = "CategoriesTableViewCell"
    public var selectButtonDidTapped: (() -> Void)?
    
    // MARK: View Lifecycle
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Methods
    public func setData(from model: Category) {
        categoryTitleLabel.text = model.translate?.name
        checkmarkImageView.image = model.isSelected ? .iconCheckmarkSelected : .iconCheckmarkDeselected
    }
    
    // MARK: Actions
    @IBAction private func selectButtonAction(_ sender: UIButton) {
        selectButtonDidTapped?()
    }
}
