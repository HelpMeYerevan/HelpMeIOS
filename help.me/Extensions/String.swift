//
//  String.swift
//  help.me
//
//  Created by Karen Galoyan on 11/19/21.
//

import UIKit

extension String {
    
    // MARK: Properties
    public var localized: String {
        if let bundlePath = Bundle.main.path(forResource: ConfigDataProvider.currentLanguage.localeCode, ofType: "lproj"), let bundle = Bundle(path: bundlePath) {
            return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        }
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    public var formattedPhoneNumber: String {
        let mask = "(XX) XXX XXX"
        let numbers = self.drop(self.first == "+" ? 5 : 3).replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        for char in mask where index < numbers.endIndex {
            if char == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(char)
            }
        }
        return result
    }
    
    public var formattedCardNumber: String {
        let mask = "XXXX XXXX XXXX XXXX"
        let numbers = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        for char in mask where index < numbers.endIndex {
            if char == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(char)
            }
        }
        return result
    }
    
    public var formattedCardExpirationDate: String {
        let mask = "XX/XX"
        let numbers = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        for char in mask where index < numbers.endIndex {
            if char == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(char)
            }
        }
        return result
    }
    
    public var formattedCardCVV: String {
        let mask = "XXX"
        let numbers = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        for char in mask where index < numbers.endIndex {
            if char == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(char)
            }
        }
        return result
    }
    
    public var formattedPrice: String {
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
    
    public var phoneNumber: String {
        return self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
    
    public var cardNumber: String {
        return self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
    
    public var price: String {
        return self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
    
    public var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: self)
    }
    
    // MARK: Methods
    public func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }

    public func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
    public mutating func setLocalizedString(_ localized: Localization) {
        self = localized.text
    }
    
    public func drop(_ length: Int) -> String {
        if length <= 0 {
            return self
        } else if let from = self.index(self.startIndex, offsetBy: length, limitedBy: self.endIndex) {
            return String(self[from...])
        } else {
            return ""
        }
    }
    
    public func separate(by: String) -> String {
        var cardNumbers = [String]()
        var i = 1
        for char in self {
            let mod = i % 4
            cardNumbers.append(String(char))
            if mod == 0 {
                cardNumbers.append(by)
            }
            i += 1
        }
        
        return cardNumbers.joined(separator: "")
    }
    
    public var creditCardType: CreditCardType? {
        var creditCardType: CreditCardType?
        do {
            try CreditCardType.all.forEach { currentCreditCardType in
                let regex = try NSRegularExpression(pattern: currentCreditCardType.pattern, options: .caseInsensitive)
                if regex.matches(in: self, options: [], range: NSMakeRange(0, self.count)).isEmpty == false {
                    creditCardType = currentCreditCardType
                }
            }
            return creditCardType
        } catch {
            return creditCardType
        }
    }
}
