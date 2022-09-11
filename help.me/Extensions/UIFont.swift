//
//  UIFont.swift
//  help.me
//
//  Created by Karen Galoyan on 11/11/21.
//

import UIKit

extension UIFont {
    
    // MARK: Properties
    private static var _fontSize: CGFloat = 0
    public var fontSize: CGFloat {
        get {
            return UIFont._fontSize
        }
        set {
            UIFont._fontSize = newValue
        }
    }
    
    static func robotoBlackFont(ofSize size: CGFloat) -> UIFont {
        let font = UIFont(name: "Roboto-Black", size: size)
        font?.fontSize = size
        return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font ?? UIFont.systemFont(ofSize: size))
    }
    static func robotoBlackItalicFont(ofSize size: CGFloat) -> UIFont {
        let font = UIFont(name: "Roboto-BlackItalic", size: size)
        font?.fontSize = size
        return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font ?? UIFont.systemFont(ofSize: size))
    }
    static func robotoBoldFont(ofSize size: CGFloat) -> UIFont {
        let font = UIFont(name: "Roboto-Bold", size: size)
        font?.fontSize = size
        return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font ?? UIFont.systemFont(ofSize: size))
    }
    static func robotoBoldItalicFont(ofSize size: CGFloat) -> UIFont {
        let font = UIFont(name: "Roboto-BoldItalic", size: size)
        font?.fontSize = size
        return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font ?? UIFont.systemFont(ofSize: size))
    }
    static func robotoItalicFont(ofSize size: CGFloat) -> UIFont {
        let font = UIFont(name: "Roboto-Italic", size: size)
        font?.fontSize = size
        return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font ?? UIFont.systemFont(ofSize: size))
    }
    static func robotoLightFont(ofSize size: CGFloat) -> UIFont {
        let font = UIFont(name: "Roboto-Light", size: size)
        font?.fontSize = size
        return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font ?? UIFont.systemFont(ofSize: size))
    }
    static func robotoLightItalicFont(ofSize size: CGFloat) -> UIFont {
        let font = UIFont(name: "Roboto-LightItalic", size: size)
        font?.fontSize = size
        return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font ?? UIFont.systemFont(ofSize: size))
    }
    static func robotoMediumFont(ofSize size: CGFloat) -> UIFont {
        let font = UIFont(name: "Roboto-Medium", size: size)
        font?.fontSize = size
        return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font ?? UIFont.systemFont(ofSize: size))
    }
    static func robotoMediumItalicFont(ofSize size: CGFloat) -> UIFont {
        let font = UIFont(name: "Roboto-MediumItalic", size: size)
        font?.fontSize = size
        return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font ?? UIFont.systemFont(ofSize: size))
    }
    static func robotoRegularFont(ofSize size: CGFloat) -> UIFont {
        let font = UIFont(name: "Roboto-Regular", size: size)
        font?.fontSize = size
        return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font ?? UIFont.systemFont(ofSize: size))
    }
    static func robotoThinFont(ofSize size: CGFloat) -> UIFont {
        let font = UIFont(name: "Roboto-Thin", size: size)
        font?.fontSize = size
        return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font ?? UIFont.systemFont(ofSize: size))
    }
    static func robotoThunItalicFont(ofSize size: CGFloat) -> UIFont {
        let font = UIFont(name: "Roboto-ThunItalic", size: size)
        font?.fontSize = size
        return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font ?? UIFont.systemFont(ofSize: size))
    }
    static func mardotoBlackFont(ofSize size: CGFloat) -> UIFont {
        let font = UIFont(name: "Mardoto-Black", size: size)
        font?.fontSize = size
        return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font ?? UIFont.systemFont(ofSize: size))
    }
    static func mardotoBlackItalicFont(ofSize size: CGFloat) -> UIFont {
        let font = UIFont(name: "Mardoto-BlackItalic", size: size)
        font?.fontSize = size
        return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font ?? UIFont.systemFont(ofSize: size))
    }
    static func mardotoBoldFont(ofSize size: CGFloat) -> UIFont {
        let font = UIFont(name: "Mardoto-Bold", size: size)
        font?.fontSize = size
        return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font ?? UIFont.systemFont(ofSize: size))
    }
    static func mardotoBoldItalicFont(ofSize size: CGFloat) -> UIFont {
        let font = UIFont(name: "Mardoto-BoldItalic", size: size)
        font?.fontSize = size
        return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font ?? UIFont.systemFont(ofSize: size))
    }
    static func mardotoItalicFont(ofSize size: CGFloat) -> UIFont {
        let font = UIFont(name: "Mardoto-Italic", size: size)
        font?.fontSize = size
        return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font ?? UIFont.systemFont(ofSize: size))
    }
    static func mardotoLightFont(ofSize size: CGFloat) -> UIFont {
        let font = UIFont(name: "Mardoto-Light", size: size)
        font?.fontSize = size
        return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font ?? UIFont.systemFont(ofSize: size))
    }
    static func mardotoLightItalicFont(ofSize size: CGFloat) -> UIFont {
        let font = UIFont(name: "Mardoto-LightItalic", size: size)
        font?.fontSize = size
        return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font ?? UIFont.systemFont(ofSize: size))
    }
    static func mardotoMediumFont(ofSize size: CGFloat) -> UIFont {
        let font = UIFont(name: "Mardoto-Medium", size: size)
        font?.fontSize = size
        return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font ?? UIFont.systemFont(ofSize: size))
    }
    static func mardotoMediumItalicFont(ofSize size: CGFloat) -> UIFont {
        let font = UIFont(name: "Mardoto-MediumItalic", size: size)
        font?.fontSize = size
        return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font ?? UIFont.systemFont(ofSize: size))
    }
    static func mardotoRegularFont(ofSize size: CGFloat) -> UIFont {
        let font = UIFont(name: "Mardoto-Regular", size: size)
        font?.fontSize = size
        return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font ?? UIFont.systemFont(ofSize: size))
    }
    static func mardotoThinFont(ofSize size: CGFloat) -> UIFont {
        let font = UIFont(name: "Mardoto-Thin", size: size)
        font?.fontSize = size
        return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font ?? UIFont.systemFont(ofSize: size))
    }
    static func mardotoThunItalicFont(ofSize size: CGFloat) -> UIFont {
        let font = UIFont(name: "Mardoto-ThunItalic", size: size)
        font?.fontSize = size
        return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font ?? UIFont.systemFont(ofSize: size))
    }
    
    // MARK: Methods
    public static func printAllFonts() {
        for family: String in familyNames {
            print(family)
            for names: String in fontNames(forFamilyName: family) {
                print("== \(names)")
            }
        }
    }
}
