//
//  LanguageTableViewCell.swift
//  help.me
//
//  Created by Karen Galoyan on 1/30/22.
//

import UIKit

public final class LanguageTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet private weak var languageTitleLabel: UILabel!
    @IBOutlet private weak var checkmarkImageView: UIImageView!
    @IBOutlet private weak var separatorView: UIView!
    
    // MARK: Properties
    public static let cellNibName = UINib(nibName: "LanguageTableViewCell", bundle: nil)
    public static let cellIdentifier = "LanguageTableViewCell"
    
    // MARK: View Lifecycle
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Methods
    public func setData(from model: Language) {
        languageTitleLabel.text = model.name
        checkmarkImageView.isHidden = !model.isSelected
        separatorView.isHidden = model.isLastRow
    }
}
