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
        label.font = .systemFont(ofSize: 17.0, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
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
    
    private func getContentsNSAtrributedString(text: String) -> NSAttributedString {
        let paragraphSytle = NSMutableParagraphStyle()
        paragraphSytle.lineBreakMode = .byCharWrapping
        paragraphSytle.lineSpacing = 5.0
        paragraphSytle.alignment = .left
        return NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 16.0, weight: .medium),
                .paragraphStyle: paragraphSytle,
            ])
    }
    
    private func getDateText(date: Date?) -> String? {
        return date
            .flatMap { date -> Int? in
                Calendar.current.dateComponents([.second], from: date, to: Date()).second
            }
            .flatMap { interval -> String in
                switch interval {
                case ..<60: // 초 단위
                    return "방금"
                case 60 ..< 3600: // 분 단위 [1분~60분]
                    return "\(interval / 60)분 전"
                case 3600 ..< 86400: // 시간 단위 [1시간~24시간]
                    return "\(interval / 3600)시간 전"
                case 86400 ..< 2592000: // 일 단위 [1일~30일]
                    return "\(interval / 86400)일 전"
                case 2592000 ..< 31536000: // 월 단위 [1개월~12개월]
                    return "\(interval / 2592000)개월 전"
                default:
                    return "\(interval / 31536000)년 전"
                }
            }
    }
}

// MARK: - Bind
extension DetailNewFeatureCell {
    func bind(with newFeature: AppInfo.NewFeature) {
        versionLabel.text = "ver \(newFeature.newVersion)"
        contentsLabel.attributedText = getContentsNSAtrributedString(text: newFeature.releaseNotes)
        dateLabel.text = getDateText(date: newFeature.updatedDate)
    }
}
