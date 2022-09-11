//
//  UIColor.swift
//  help.me
//
//  Created by Karen Galoyan on 11/11/21.
//

import UIKit

extension UIColor {
    
    // MARK: Properties
    public static var hex_000000: UIColor { UIColor(named: "000000") ?? .clear }
    public static var hex_2A836E: UIColor { UIColor(named: "2A836E") ?? .clear }
    public static var hex_6BC24D: UIColor { UIColor(named: "6BC24D") ?? .clear }
    public static var hex_6CC24D: UIColor { UIColor(named: "6CC24D") ?? .clear }
    public static var hex_000018: UIColor { UIColor(named: "000018") ?? .clear }
    public static var hex_46BC6C: UIColor { UIColor(named: "46BC6C") ?? .clear }
    public static var hex_292E39: UIColor { UIColor(named: "292E39") ?? .clear }
    public static var hex_292929: UIColor { UIColor(named: "292929") ?? .clear }
    public static var hex_A6A6A6: UIColor { UIColor(named: "A6A6A6") ?? .clear }
    public static var hex_B98538: UIColor { UIColor(named: "B98538") ?? .clear }
    public static var hex_C4C4C4: UIColor { UIColor(named: "C4C4C4") ?? .clear }
    public static var hex_C5C5C5: UIColor { UIColor(named: "C5C5C5") ?? .clear }
    public static var hex_CCCCCC: UIColor { UIColor(named: "CCCCCC") ?? .clear }
    public static var hex_E1D491: UIColor { UIColor(named: "E1D491") ?? .clear }
    public static var hex_E5E5E5: UIColor { UIColor(named: "E5E5E5") ?? .clear }
    public static var hex_EBEBEB: UIColor { UIColor(named: "EBEBEB") ?? .clear }
    public static var hex_EDEDED: UIColor { UIColor(named: "EDEDED") ?? .clear }
    public static var hex_FFFFFF: UIColor { UIColor(named: "FFFFFF") ?? .clear }
    public static var transparentViewBackgroundColor: UIColor { .black.withAlphaComponent(0.7) }
    public static var placeholderBackgroundColor: UIColor { .hex_6BC24D.withAlphaComponent(0.2) }
    public static var shadow: UIColor { UIColor.hex_000000 }
    public static var officialApplePlaceholderColor: UIColor {
        return UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
    }
    public var shadowImage: UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        let ctx = UIGraphicsGetCurrentContext()
        self.setFill()
        ctx?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    // MARK: Initialization
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var rgbValue: UInt64 = 0
        if hexString.count < 6 || hexString.count > 6 {
            print("Wrong hexString!!!")
        } else {
            var hexFormatted: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            if hexFormatted.hasPrefix("#") {
                hexFormatted = String(hexFormatted.dropFirst())
            }
            Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        }
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
    
    // MARK: Methods
    public func hexString() -> String {
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }
}
