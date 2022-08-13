//
//  DetailIntroduceCell.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/13.
//

import UIKit

final class DetailIntroduceCell: UICollectionViewCell {
    
    // MARK: Properties
    static var reuseIdentifier: String { "DetailIntroduceCell" }
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        
    }
    
    private func layout() {
        
    }
}

// MARK: - Bind
extension DetailIntroduceCell {
    func bind() {
        
    }
}
