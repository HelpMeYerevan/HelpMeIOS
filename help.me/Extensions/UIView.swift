//
//  UIView.swift
//  help.me
//
//  Created by Karen Galoyan on 11/11/21.
//

import UIKit

extension UIView {
    
    // MARK: Methods
    public func setShadow(with color: UIColor = .hex_000000.withAlphaComponent(0.1), shadowOffset: CGSize = .zero, shadowRadius: CGFloat = 5, shadowInsets: UIEdgeInsets = .zero, cornerRadius: CGFloat = 0) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.cornerRadius = cornerRadius
        layoutIfNeeded()
        let rect = CGRect(x: bounds.origin.x + shadowInsets.left, y: bounds.origin.y + shadowInsets.top, width: bounds.size.width - shadowInsets.right, height: bounds.size.height - shadowInsets.bottom)
        layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    public func setCornerRadius(_ cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
    }
    
    public func setBorder(withColor color: UIColor, andWidth width: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    public func setBorder(withColor color: UIColor, width: CGFloat, corners: UIRectCorner, andRadius radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = path.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color.cgColor
        borderLayer.lineWidth = width
        borderLayer.frame = self.bounds
        layer.addSublayer(borderLayer)
    }
    
    public func setBorder(withColor color: UIColor, width: CGFloat, topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        let topLeftRadius = CGSize(width: topLeft, height: topLeft)
        let topRightRadius = CGSize(width: topRight, height: topRight)
        let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
        let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
        let maskPath = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskPath.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color.cgColor
        borderLayer.lineWidth = width
        borderLayer.frame = self.bounds
        layer.addSublayer(borderLayer)
    }
    
    public func roundCorners(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        let topLeftRadius = CGSize(width: topLeft, height: topLeft)
        let topRightRadius = CGSize(width: topRight, height: topRight)
        let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
        let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
        let maskPath = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    
    public func setGradient(with colors: [CGColor], with cornerRadius: CGFloat = 0) {
        let gradientLayer = CAGradientLayer()
        layoutIfNeeded()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        gradientLayer.shouldRasterize = true
        gradientLayer.masksToBounds = true
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.zPosition = -99
        gradientLayer.cornerRadius = cornerRadius
        self.layer.addSublayer(gradientLayer)
    }
    
    public func setLocalizedString(_ localized: Localization, buttonState: UIControl.State = .normal, index: Int = 0) {
        if let label = self as? UILabel {
            label.text = localized.text
        } else if let textField = self as? UITextField {
            textField.placeholder = localized.text
        } else if let button = self as? UIButton {
            button.setTitle(localized.text, for: buttonState)
        } else if let segmentedControl = self as? UISegmentedControl {
            segmentedControl.setTitle(localized.text, forSegmentAt: index)
        }
    }
    
    public func showAlert(with error: Error) {
        var message = ""
        if let error = error as? NetworkError {
            if error == .unauthorized {
                guard let viewController = UIApplication.sceneDelegateWindow?.rootViewController?.viewController(from: .authorization, withIdentifier: .signInViewController) as? SignInViewController else { return }
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.modalPresentationStyle = .custom
                navigationController.navigationBar.isHidden = true
                UIApplication.sceneDelegateWindow?.rootViewController = navigationController
                UIApplication.sceneDelegateWindow?.makeKeyAndVisible()
            }
            message = error.message
        } else {
            message = error.localizedDescription
        }
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        UIApplication.sceneDelegateWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
