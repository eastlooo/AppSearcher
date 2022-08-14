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
    
    private let appImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .background
        return imageView
    }()
    
    private let appImageShadowView = UIView()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "아이디어스(idus)"
        label.textColor = .black
        label.font = .systemFont(ofSize: 22.0, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "4.7"
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 18.0, weight: .heavy)
        return label
    }()
    
    private let ratingView = RatingView()
    
    private let appstoreButton = UIButton()
    
    private let appstoreButtonLabel: UILabel = {
        let label = UILabel()
        label.text = "App Store"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.backgroundColor = .primary
        label.layer.cornerRadius = 16.0
        label.textAlignment = .center
        label.clipsToBounds = true
        return label
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 22.0, weight: .semibold)
        let image = UIImage(systemName: "square.and.arrow.up", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let leftShadowLayer = CALayer.createLeftShadowLayer(position: 2.0)
    private let rightShadowLayer = CALayer.createRightShadowLayer(position: 2.0)
    private let bottomShadowLayer = CALayer.createBottomShadowLayer(position: 2.0)
    
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
        contentView.backgroundColor = .white
        _ = ratingView.setRating(4.7)
    }
    
    private func layout() {
        contentView.addSubview(appImageShadowView)
        appImageShadowView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: appImageShadowView, attribute: .left, relatedBy: .equal,
                toItem: contentView, attribute: .left, multiplier: 1.0, constant: 20.0),
            NSLayoutConstraint(
                item: appImageShadowView, attribute: .bottom, relatedBy: .equal,
                toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -20.0),
            appImageShadowView.widthAnchor.constraint(equalToConstant: 110.0),
            appImageShadowView.heightAnchor.constraint(equalToConstant: 110.0),
        ])
        
        appImageShadowView.addSubview(appImageView)
        appImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: appImageView, attribute: .top, relatedBy: .equal,
                toItem: appImageShadowView, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: appImageView, attribute: .left, relatedBy: .equal,
                toItem: appImageShadowView, attribute: .left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: appImageView, attribute: .right, relatedBy: .equal,
                toItem: appImageShadowView, attribute: .right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: appImageView, attribute: .bottom, relatedBy: .equal,
                toItem: appImageShadowView, attribute: .bottom, multiplier: 1.0, constant: 0),
        ])
        
        contentView.addSubview(appNameLabel)
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: appNameLabel, attribute: .top, relatedBy: .equal,
                toItem: appImageShadowView, attribute: .top, multiplier: 1.0, constant: 5.0),
            NSLayoutConstraint(
                item: appNameLabel, attribute: .left, relatedBy: .equal,
                toItem: appImageShadowView, attribute: .right, multiplier: 1.0, constant: 20.0),
            NSLayoutConstraint(
                item: appNameLabel, attribute: .right, relatedBy: .lessThanOrEqual,
                toItem: contentView, attribute: .right, multiplier: 1.0, constant: -17.0),
        ])
        
        contentView.addSubview(ratingLabel)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: ratingLabel, attribute: .top, relatedBy: .equal,
                toItem: appNameLabel, attribute: .bottom, multiplier: 1.0, constant: 5.0),
            NSLayoutConstraint(
                item: ratingLabel, attribute: .left, relatedBy: .equal,
                toItem: appNameLabel, attribute: .left, multiplier: 1.0, constant: 0),
        ])
        
        contentView.addSubview(ratingView)
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: ratingView, attribute: .centerY, relatedBy: .equal,
                toItem: ratingLabel, attribute: .centerY, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: ratingView, attribute: .left, relatedBy: .equal,
                toItem: ratingLabel, attribute: .right, multiplier: 1.0, constant: 7.0),
            ratingView.widthAnchor.constraint(equalToConstant: 79.0),
            ratingView.heightAnchor.constraint(equalToConstant: 16.0),
        ])
        
        contentView.addSubview(appstoreButton)
        appstoreButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            NSLayoutConstraint(
                item: appstoreButton, attribute: .left, relatedBy: .equal,
                toItem: ratingLabel, attribute: .left, multiplier: 1.0, constant: 0),
            appstoreButton.widthAnchor.constraint(equalToConstant: 107.0),
            appstoreButton.heightAnchor.constraint(equalToConstant: 44.0),
        ])
        
        appstoreButton.addSubview(appstoreButtonLabel)
        appstoreButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: appstoreButtonLabel, attribute: .bottom, relatedBy: .equal,
                toItem: appImageShadowView, attribute: .bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: appstoreButtonLabel, attribute: .centerX, relatedBy: .equal,
                toItem: appstoreButton, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: appstoreButtonLabel, attribute: .centerY, relatedBy: .equal,
                toItem: appstoreButton, attribute: .centerY, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: appstoreButtonLabel, attribute: .width, relatedBy: .equal,
                toItem: appstoreButton, attribute: .width, multiplier: 1.0, constant: 0),
            appstoreButtonLabel.heightAnchor.constraint(equalToConstant: 32.0),
            
        ])
        
        contentView.addSubview(shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: shareButton, attribute: .centerY, relatedBy: .equal,
                toItem: appstoreButton, attribute: .centerY, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: shareButton, attribute: .right, relatedBy: .equal,
                toItem: contentView, attribute: .right, multiplier: 1.0, constant: -8.0),
            shareButton.widthAnchor.constraint(equalToConstant: 44.0),
            shareButton.heightAnchor.constraint(equalToConstant: 44.0),
        ])
    }
    
    private func addShadowLayer() {
        appImageView.layer.cornerRadius = 26.0
        appImageShadowView.layer.cornerRadius = 26.0
        appImageShadowView.layer.masksToBounds = false
        appImageShadowView.layer.insertSublayer(leftShadowLayer, at: 0)
        appImageShadowView.layer.insertSublayer(rightShadowLayer, at: 1)
        appImageShadowView.layer.insertSublayer(bottomShadowLayer, at: 2)
    }
    
    private func setShadowLayerPath() {
        [leftShadowLayer, rightShadowLayer, bottomShadowLayer].forEach { layer in
            layer.shadowPath = UIBezierPath(
                roundedRect: .init(x: 0, y: 0, width: 110.0, height: 110.0),
                cornerRadius: appImageShadowView.layer.cornerRadius
            ).cgPath
        }
    }
}

// MARK: - Bind
extension DetailMainCell {
    func bind() {
        
    }
}
