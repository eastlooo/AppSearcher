//
//  DetailScreenshotCell.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/13.
//

import UIKit
import Combine

final class DetailScreenshotCell: UICollectionViewCell {
    
    // MARK: Properties
    static var reuseIdentifier: String { "DetailScreenshotCell" }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let screenshotImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let leftShadowLayer = CALayer.createLeftShadowLayer()
    private let rightShadowLayer = CALayer.createRightShadowLayer()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.cancellables = Set<AnyCancellable>()
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .clear
        contentView.layer.cornerRadius = 30.0
        contentView.backgroundColor = .white
        contentView.clipsToBounds = true
    }
    
    private func layout() {
        contentView.addSubview(screenshotImageView)
        screenshotImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: screenshotImageView, attribute: .top, relatedBy: .equal,
                toItem: contentView, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: screenshotImageView, attribute: .left, relatedBy: .equal,
                toItem: contentView, attribute: .left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: screenshotImageView, attribute: .right, relatedBy: .equal,
                toItem: contentView, attribute: .right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: screenshotImageView, attribute: .bottom, relatedBy: .equal,
                toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: 0),
        ])
    }
    
    private func addShadowLayer() {
        self.layer.insertSublayer(leftShadowLayer, at: 0)
        self.layer.insertSublayer(rightShadowLayer, at: 1)
        self.layer.insertSublayer(bottomShadowLayer, at: 2)
    }
    
    private func setShadowLayerPath() {
        [leftShadowLayer, rightShadowLayer, bottomShadowLayer].forEach { layer in
            layer.shadowPath = UIBezierPath(
                roundedRect: contentView.bounds,
                cornerRadius: contentView.layer.cornerRadius
            ).cgPath
        }
    }
}

// MARK: - Bind
extension DetailScreenshotCell {
    func bind(with viewModel: DetailScreenshotCellViewModel) {
        viewModel.output.appImageData
            .compactMap { $0 }
            .map(UIImage.init)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.screenshotImageView.image = image
            }
            .store(in: &cancellables)
    }
}
