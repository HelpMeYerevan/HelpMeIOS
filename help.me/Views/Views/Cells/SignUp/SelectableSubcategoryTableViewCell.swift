//
//  SelectableSubcategoryTableViewCell.swift
//  help.me
//
//  Created by Karen Galoyan on 12/26/21.
//

import UIKit

public final class SelectableSubcategoryTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet private weak var checkmarkImageView: UIImageView!
    @IBOutlet private weak var categoryTitleLabel: UILabel!
    @IBOutlet private weak var separatorView: UIView!
    
    // MARK: Properties
    static let cellNibName = UINib(nibName: "SelectableSubcategoryTableViewCell", bundle: nil)
    static let cellIdentifier = "SelectableSubcategoryTableViewCell"
    public var selectButtonDidTapped: (() -> Void)?
    
    // MARK: UITableViewHeaderFooterView Lifecycle
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
