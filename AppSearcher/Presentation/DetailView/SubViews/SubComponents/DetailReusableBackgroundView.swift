//
//  DetailReusableBackgroundView.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/14.
//

import UIKit

final class DetailReusableBackgroundView: UICollectionReusableView {
    
    // MARK: Properties
    static var reuseIdentifier: String { "DetailReusableBackgroundView" }
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
