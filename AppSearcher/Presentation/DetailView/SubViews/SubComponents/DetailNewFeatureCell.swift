//
//  DetailNewFeatureCell.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/13.
//

import UIKit

final class DetailNewFeatureCell: UICollectionViewCell {
    
    // MARK: Properties
    static var reuseIdentifier: String { "DetailNewFeatureCell" }
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.text = "ver 3.36.0"
        label.font = .systemFont(ofSize: 17.0, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "3일 전"
        label.font = .systemFont(ofSize: 16.0, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()
    
    private let contentsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
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
        
        let text = "이 버전에서는\n여러분이 알려주신 소소한 버그 수정 및 성능 개선이 되었습니다."
        let paragraphSytle = NSMutableParagraphStyle()
        paragraphSytle.lineBreakMode = .byCharWrapping
        paragraphSytle.lineSpacing = 5.0
        paragraphSytle.alignment = .left
        contentsLabel.attributedText = NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 16.0, weight: .medium),
                .paragraphStyle: paragraphSytle,
            ])
    }
    
    private func layout() {
        contentView.addSubview(versionLabel)
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: versionLabel, attribute: .top, relatedBy: .equal,
                toItem: contentView, attribute: .top, multiplier: 1.0, constant: 22.0),
            NSLayoutConstraint(
                item: versionLabel, attribute: .left, relatedBy: .equal,
                toItem: contentView, attribute: .left, multiplier: 1.0, constant: 20.0),
        ])
        
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: dateLabel, attribute: .centerY, relatedBy: .equal,
                toItem: versionLabel, attribute: .centerY, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: dateLabel, attribute: .right, relatedBy: .equal,
                toItem: contentView, attribute: .right, multiplier: 1.0, constant: -20.0),
        ])
        
        contentView.addSubview(contentsLabel)
        contentsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: contentsLabel, attribute: .top, relatedBy: .equal,
                toItem: versionLabel, attribute: .bottom, multiplier: 1.0, constant: 20.0),
            NSLayoutConstraint(
                item: contentsLabel, attribute: .left, relatedBy: .equal,
                toItem: versionLabel, attribute: .left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: contentsLabel, attribute: .right, relatedBy: .lessThanOrEqual,
                toItem: dateLabel, attribute: .right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: contentsLabel, attribute: .bottom, relatedBy: .equal,
                toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -20.0),
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
extension DetailNewFeatureCell {
    func bind() {
        
    }
}
