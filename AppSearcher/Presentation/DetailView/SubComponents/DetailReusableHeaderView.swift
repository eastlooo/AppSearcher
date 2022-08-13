//
//  DetailReusableHeaderView.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/13.
//

import UIKit

final class DetailReusableHeaderView: UICollectionReusableView {
    
    // MARK: Properties
    
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
        self.backgroundColor = .systemGray3
    }
    
    private func layout() {
        
    }
}

extension DetailReusableHeaderView {
    static var reuseIdentifier: String { "DetailReusableHeaderView" }
}
