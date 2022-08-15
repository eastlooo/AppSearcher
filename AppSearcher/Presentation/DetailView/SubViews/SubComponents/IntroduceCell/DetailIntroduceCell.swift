//
//  DetailIntroduceCell.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/13.
//

import UIKit
import Combine

final class DetailIntroduceCell: UICollectionViewCell {
    
    // MARK: Properties
    static var reuseIdentifier: String { "DetailIntroduceCell" }
    
    private var cancellables = Set<AnyCancellable>()
    private let updateCollectionLayout$ = PassthroughSubject<Void, Never>()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.0, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()
    
    private let contentsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        return label
    }()
    
    private let foldableButton: UIButton = {
        let button = UIButton()
        button.setTitle("자세히 보기", for: .normal)
        button.setTitleColor(UIColor.primary, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .bold)
        return button
    }()
    
    private let bottomShadowLayer = CALayer.createBottomShadowLayer()
    private lazy var contentsHeightConstraint = contentsLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 0)
    
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
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 13.0
        contentView.clipsToBounds = true
    }
    
    private func layout() {
        contentView.addSubview(artistLabel)
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: artistLabel, attribute: .top, relatedBy: .equal,
                toItem: contentView, attribute: .top, multiplier: 1.0, constant: 22.0),
            NSLayoutConstraint(
                item: artistLabel, attribute: .left, relatedBy: .equal,
                toItem: contentView, attribute: .left, multiplier: 1.0, constant: 20.0),
        ])
        
        contentView.addSubview(contentsLabel)
        contentsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: contentsLabel, attribute: .top, relatedBy: .equal,
                toItem: artistLabel, attribute: .bottom, multiplier: 1.0, constant: 20.0),
            NSLayoutConstraint(
                item: contentsLabel, attribute: .left, relatedBy: .equal,
                toItem: artistLabel, attribute: .left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: contentsLabel, attribute: .right, relatedBy: .lessThanOrEqual,
                toItem: contentView, attribute: .right, multiplier: 1.0, constant: -20.0),
            contentsHeightConstraint,
        ])
        
        contentView.addSubview(foldableButton)
        foldableButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: foldableButton, attribute: .top, relatedBy: .equal,
                toItem: contentsLabel, attribute: .bottom, multiplier: 1.0, constant: 5.5),
            NSLayoutConstraint(
                item: foldableButton, attribute: .centerX, relatedBy: .equal,
                toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: foldableButton, attribute: .bottom, relatedBy: .equal,
                toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -8.5),
            foldableButton.heightAnchor.constraint(equalToConstant: 44.0)
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
        paragraphSytle.lineBreakMode = .byTruncatingTail
        paragraphSytle.lineSpacing = 5.0
        paragraphSytle.alignment = .left
        return NSMutableAttributedString(
            string: text,
            attributes: [
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 16.0, weight: .medium),
                .paragraphStyle: paragraphSytle,
            ])
    }
    
    private func calculateEstimatedHeight() -> CGFloat {
        let width = UIScreen.main.bounds.width - 80.0
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        let estimatedHeight = contentsLabel.sizeThatFits(size).height
        guard contentsLabel.numberOfLines > 0 else { return estimatedHeight }
        
        let lineHeight: CGFloat = 23.0
        let restrictedHeight = lineHeight * CGFloat(contentsLabel.numberOfLines)
        return restrictedHeight > estimatedHeight ? estimatedHeight : restrictedHeight
    }
    
    private func setContentsLabelText(_ text: String) {
        let attributedText = getContentsNSAtrributedString(text: text)
        contentsLabel.attributedText = attributedText
        contentsHeightConstraint.constant = calculateEstimatedHeight()
        updateCollectionLayout$.send()
    }
}

// MARK: - Bind
extension DetailIntroduceCell {
    func bind(with viewModel: DetailIntroduceCellViewModel) {
        updateCollectionLayout$
            .sink { viewModel.input.updateCollectionLayout.send($0) }
            .store(in: &cancellables)
        
        foldableButton.tapPublisher
            .sink { viewModel.input.foldableButtonTapped.send($0) }
            .store(in: &cancellables)
        
        viewModel.output.isSpreadOut
            .dropFirst()
            .sink { [weak self] isSpreadOut in
                let title = isSpreadOut ? "접기" : "자세히 보기"
                self?.foldableButton.setTitle(title, for: .normal)
                self?.contentsLabel.numberOfLines = isSpreadOut ? 0 : 4
                if let text = self?.contentsLabel.attributedText?.string {
                    self?.setContentsLabelText(text)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.artistName
            .sink { [weak self] text in
                self?.artistLabel.text = text
            }
            .store(in: &cancellables)
        
        viewModel.output.contents
            .sink { [weak self] text in
                self?.setContentsLabelText(text)
            }
            .store(in: &cancellables)
    }
}
