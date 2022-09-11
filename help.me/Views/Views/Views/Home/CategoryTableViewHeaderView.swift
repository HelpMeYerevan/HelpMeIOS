//
//  CategoryTableViewHeaderView.swift
//  help.me
//
//  Created by Karen Galoyan on 11/24/21.
//

import UIKit

public class CategoryTableViewHeaderView: UITableViewHeaderFooterView {

    // MARK: Outlets
    @IBOutlet private weak var categoryTitleLabel: UILabel!
    
    // MARK: Properties
    static let viewNib = UINib(nibName: "CategoryTableViewHeaderView", bundle: nil)
    static let viewIdentifier = "CategoryTableViewHeaderView"
    
    // MARK: UITableViewHeaderFooterView Lifecycle
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Methods
    public func setData(from model: CategoryModel) {
        categoryTitleLabel.text = model.title
    }
}
