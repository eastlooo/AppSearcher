//
//  DetailMainCell.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/13.
//

import UIKit

final class DetailMainCell: UICollectionViewCell {
    
    // MARK: Properties
    static var reuseIdentifier: String { "DetailMainCell" }
    
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
extension DetailMainCell {
    func bind() {
        
    }
}
