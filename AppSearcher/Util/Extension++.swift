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

// MARK: - CALayer
extension CALayer {
    enum ShadowDirection {
        case top, left, right, bottom
    }
    
    static func createShadowLayer(color: UIColor? = .black,
                                  opacity: Float = 0.1,
                                  offSet: CGSize,
                                  radius: CGFloat = 2.0) -> CALayer {
        let layer = CALayer()
        layer.masksToBounds = false
        layer.shadowColor = color?.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        return layer
    }
    
    static func createTopShadowLayer(position: CGFloat = 4.0) -> CALayer {
        CALayer.createShadowLayer(offSet: .init(width: 0, height: -position))
    }
    
    static func createLeftShadowLayer(position: CGFloat = 4.0) -> CALayer {
        CALayer.createShadowLayer(offSet: .init(width: -position, height: 0))
    }
    
    static func createRightShadowLayer(position: CGFloat = 4.0) -> CALayer {
        CALayer.createShadowLayer(offSet: .init(width: position, height: -0))
    }
    
    static func createBottomShadowLayer(position: CGFloat = 4.0) -> CALayer {
        CALayer.createShadowLayer(offSet: .init(width: 0, height: position))
    }
}

// MARK: - UIWindow
extension UIWindow {
    static var keyWindow: UIWindow? {
        UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow }
    }
}
