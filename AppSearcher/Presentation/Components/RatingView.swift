//
//  RatingView.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/15.
//

import UIKit

final class RatingView: UIStackView {
    
    // MARK: Properties
    private let firstStar = StarView()
    private let secondStar = StarView()
    private let thirdStar = StarView()
    private let fourthStar = StarView()
    private let fifthStar = StarView()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        layout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .clear
    }
    
    private func layout() {
        for view in [firstStar, secondStar, thirdStar, fourthStar, fifthStar] {
            self.addArrangedSubview(view)
        }
        
        self.axis = .horizontal
        self.distribution = .fillEqually
        self.spacing = 1.0
    }
    
    private func updateStarLayer(rating: Double) {
        var rating = rating
        for star in [firstStar, secondStar, thirdStar, fourthStar, fifthStar] {
            if rating >= 1.0 {
                star.fraction = 1.0
                rating -= 1.0
            } else {
                star.fraction = rating
                rating = 0
            }
        }
    }
}

extension RatingView {
    func setRating(_ rating: Double) -> Bool {
        guard rating >= 0 && rating <= 5.0 else { return false }
        updateStarLayer(rating: rating)
        return true
    }
}
