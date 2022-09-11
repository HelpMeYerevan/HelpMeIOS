//
//  SelectableCategoryTableViewHeaderView.swift
//  help.me
//
//  Created by Karen Galoyan on 12/26/21.
//

import UIKit

public class SelectableCategoryTableViewHeaderView: UITableViewHeaderFooterView {

    // MARK: Outlets
    @IBOutlet private weak var checkmarkImageView: UIImageView!
    @IBOutlet private weak var categoryTitleLabel: UILabel!
    @IBOutlet private weak var categoryTitleLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var arrowImageView: UIImageView!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var expandButton: UIButton!
    
    // MARK: Properties
    static let viewNib = UINib(nibName: "SelectableCategoryTableViewHeaderView", bundle: nil)
    static let viewIdentifier = "SelectableCategoryTableViewHeaderView"
    public var selectButtonDidTapped: (() -> Void)?
    public var expandButtonDidTapped: (() -> Void)?
    
    // MARK: View Lifecycle
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Methods
    public func setData(from model: Category) {
        categoryTitleLabel.text = model.translate?.name
        checkmarkImageView.image = model.isSelected ? .iconCheckmarkSelected : .iconCheckmarkDeselected
        arrowImageView.image = model.isExpanded ? .iconArrowLeft : .iconArrowDown
        separatorView.isHidden = model.isExpanded
        categoryTitleLabelLeadingConstraint.constant = (model.subCategories ?? []).isEmpty ? 20 : 0
        checkmarkImageView.isHidden = !(model.subCategories ?? []).isEmpty
        arrowImageView.isHidden = (model.subCategories ?? []).isEmpty
        expandButton.isHidden = (model.subCategories ?? []).isEmpty
    }
    
    // MARK: Actions
    @IBAction private func selectButtonAction(_ sender: UIButton) {
        selectButtonDidTapped?()
    }
    
    @IBAction func expandButtonAction(_ sender: UIButton) {
        expandButtonDidTapped?()
    }
}
