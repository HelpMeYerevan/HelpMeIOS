//
//  TopCategoriesCollectionViewCell.swift
//  help.me
//
//  Created by Karen Galoyan on 11/13/21.
//

import UIKit

public final class TopCategoriesCollectionViewCell: UICollectionViewCell {

    // MARK: Outlets
    @IBOutlet private weak var categoryBackgroundView: UIView!
    @IBOutlet private weak var categoryLabel: UILabel!

    // MARK: Properties
    public static let cellNibName = UINib(nibName: "TopCategoriesCollectionViewCell", bundle: nil)
    public static let cellIdentifier = "TopCategoriesCollectionViewCell"
    
    // MARK: View Lifecycle
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Methods
    public func setData(from model: Category) {
        let color = UIColor.hex_292929.withAlphaComponent(0.6)
        categoryBackgroundView.backgroundColor = model.isSelected ? color : .hex_EDEDED
        categoryLabel.textColor = model.isSelected ? .hex_FFFFFF : .hex_292E39
        categoryLabel.text = model.translate?.name
        categoryBackgroundView.setCornerRadius(model.size.height / 2)
    }
}
