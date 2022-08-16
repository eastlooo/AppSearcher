//
//  HapticManager.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/16.
//

import UIKit

final class HapticManager {
    
    static let instance = HapticManager()
    
    private init() {}
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
