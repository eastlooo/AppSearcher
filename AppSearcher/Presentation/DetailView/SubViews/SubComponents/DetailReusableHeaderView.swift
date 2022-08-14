//
//  DetailReusableHeaderView.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/13.
//

import UIKit

final class DetailReusableHeaderView: UICollectionReusableView {
    
    // MARK: Properties
    var title: String? {
        didSet { titleLabel.text = title }
    }
    
    static var reuseIdentifier: String { "DetailReusableHeaderView" }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "소개"
        label.font = .systemFont(ofSize: 20.0, weight: .heavy)
        label.textColor = .black
        return label
    }()
    
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
        self.backgroundColor = .clear
    }
    
    private func layout() {
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: titleLabel, attribute: .top, relatedBy: .equal,
                toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: titleLabel, attribute: .left, relatedBy: .equal,
                toItem: self, attribute: .left, multiplier: 1.0, constant: 0),
        ])
    }
}
