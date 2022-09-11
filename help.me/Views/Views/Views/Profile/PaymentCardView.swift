//
//  PaymentCardView.swift
//  help.me
//
//  Created by Karen Galoyan on 2/7/22.
//

import UIKit

public final class PaymentCardView: UIView {
    
    // MARK: Outlets
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var cardView: UIView!
    @IBOutlet private var cardTypeLabel: UILabel!
    @IBOutlet private var cardNumberLabel: UILabel!
    @IBOutlet private var selectButton: UIButton!

    // MARK: Properties
    public var selectButtonDidTapped: ((Bool) -> Void)?
    
    // MARK: Initialization
    init() {
        super.init(frame: .init(origin: .zero, size: .init(width: UIScreen.main.bounds.width - 32, height: 100)))
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIView Lifecycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: Methods
    private func setupView() {
        Bundle.main.loadNibNamed("PaymentCardView", owner: self, options: nil)
        addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    public func setData(from model: PaymentCard) {
        cardView.setCornerRadius(Constants.cornerRadius_10)
        cardView.setGradient(with: model.isActive ? [UIColor.hex_2A836E.cgColor, UIColor.hex_6CC24D.cgColor] : [UIColor.hex_C5C5C5.cgColor, UIColor.hex_EBEBEB.cgColor])
        cardTypeLabel.text = model.name
        cardNumberLabel.text = "**** **** **** \(model.data?.number?.suffix(4) ?? "0000")"
        selectButton.setCornerRadius(selectButton.frame.height / 2)
        selectButton.isSelected = model.isActive
    }
    
    // MARK: Actions
    @IBAction private func selectButtonAction(_ sender: UIButton) {
        selectButtonDidTapped?(!sender.isSelected)
    }
}

