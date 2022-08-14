//
//  DetailAdditionalCell.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/13.
//

import UIKit

final class DetailAdditionalCell: UICollectionViewCell {
    
    // MARK: Properties
    static var reuseIdentifier: String { "DetailAdditionalCell" }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제공자"
        label.font = .systemFont(ofSize: 16.0, weight: .heavy)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let contentsLabel: UILabel = {
        let label = UILabel()
        label.text = "Backpackr Inc."
        label.font = .systemFont(ofSize: 16.0, weight: .heavy)
        label.textColor = .black
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let bottomShadowLayer = CALayer.createBottomShadowLayer()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        layout()
        addShadowLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setShadowLayerPath()
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .clear
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 13.0
        contentView.clipsToBounds = true
    }
    
    private func layout() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: titleLabel, attribute: .top, relatedBy: .equal,
                toItem: contentView, attribute: .top, multiplier: 1.0, constant: 24.0),
            NSLayoutConstraint(
                item: titleLabel, attribute: .centerX, relatedBy: .equal,
                toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: titleLabel, attribute: .left, relatedBy: .lessThanOrEqual,
                toItem: contentView, attribute: .left, multiplier: 1.0, constant: 10.0),
            NSLayoutConstraint(
                item: titleLabel, attribute: .right, relatedBy: .lessThanOrEqual,
                toItem: contentView, attribute: .right, multiplier: 1.0, constant: -10.0),
        ])
        
        contentView.addSubview(contentsLabel)
        contentsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: contentsLabel, attribute: .top, relatedBy: .equal,
                toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 12.0),
            NSLayoutConstraint(
                item: contentsLabel, attribute: .centerX, relatedBy: .equal,
                toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: contentsLabel, attribute: .left, relatedBy: .lessThanOrEqual,
                toItem: contentView, attribute: .left, multiplier: 1.0, constant: 10.0),
            NSLayoutConstraint(
                item: contentsLabel, attribute: .right, relatedBy: .lessThanOrEqual,
                toItem: contentView, attribute: .right, multiplier: 1.0, constant: -10.0),
        ])
    }
    
    private func addShadowLayer() {
        self.layer.insertSublayer(bottomShadowLayer, at: 0)
    }
    
    private func setShadowLayerPath() {
        bottomShadowLayer.shadowPath = UIBezierPath(
            roundedRect: contentView.bounds,
            cornerRadius: contentView.layer.cornerRadius
        ).cgPath
    }
}

// MARK: - Bind
extension DetailAdditionalCell {
    func bind() {
        
    }
}
