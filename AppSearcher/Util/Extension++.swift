//
//  Extension++.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/12.
//

import UIKit

// MARK: - UIColor
extension UIColor {
    class var primary: UIColor? { return UIColor(named: "primary") }
    class var background: UIColor? { return UIColor(named: "background") }
}

// MARK: - Date
extension Date {
    func toString(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}

// MARK: - String
extension String {
    func toDate(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}
