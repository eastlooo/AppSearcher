//
//  AlertView.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/16.
//

import UIKit

final class AlertView: UIView {
    
    // MARK: Properties
    private let maxDimmedAlpha: CGFloat = 0.3
    private let dimmedView = UIView()
    private let alertMessage: String
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15.0
        view.isHidden = true
        return view
    }()
    
    private let warningImageView: UIImageView = {
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: 32.0, weight: .semibold)
        let image = UIImage(systemName: "exclamationmark.triangle", withConfiguration: configuration)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .primary
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "알림"
        label.textColor = .black
        label.font = .systemFont(ofSize: 30.0, weight: .heavy)
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black.withAlphaComponent(0.87)
        label.font = .systemFont(ofSize: 20.0, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Lifecycle
    init(message: String) {
        self.alertMessage = message
        super.init(frame: UIScreen.main.bounds)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        animateDismissView()
    }
    
    // MARK: Animations
    private func animateShowDimmedView() {
        dimmedView.backgroundColor = .black
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    private func animatePresentContainer() {
        UIView.animate(withDuration: 0.4, delay: 0.4, options: .transitionCrossDissolve) {
            self.containerView.isHidden = false
            self.layoutIfNeeded()
        }
    }
    
    private func animateDismissView() {
        UIView.animate(withDuration: 0.3) {
            self.containerView.isHidden = true
            self.layoutIfNeeded()
        }
        
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .clear
        messageLabel.text = alertMessage
    }
    
    private func layout() {
        let hStackView = UIStackView(arrangedSubviews: [warningImageView, titleLabel])
        hStackView.axis = .horizontal
        hStackView.distribution = .fillProportionally
        hStackView.spacing = 11.0
        
        self.addSubview(dimmedView)
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: dimmedView, attribute: .top, relatedBy: .equal,
                toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: dimmedView, attribute: .left, relatedBy: .equal,
                toItem: self, attribute: .left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: dimmedView, attribute: .right, relatedBy: .equal,
                toItem: self, attribute: .right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: dimmedView, attribute: .bottom, relatedBy: .equal,
                toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0),
        ])
        
        self.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: containerView, attribute: .centerY, relatedBy: .equal,
                toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: containerView, attribute: .left, relatedBy: .equal,
                toItem: self, attribute: .left, multiplier: 1.0, constant: 30.0),
            NSLayoutConstraint(
                item: containerView, attribute: .right, relatedBy: .equal,
                toItem: self, attribute: .right, multiplier: 1.0, constant: -30.0),
        ])
        
        containerView.addSubview(hStackView)
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: hStackView, attribute: .top, relatedBy: .equal,
                toItem: containerView, attribute: .top, multiplier: 1.0, constant: 33.0),
            NSLayoutConstraint(
                item: hStackView, attribute: .centerX, relatedBy: .equal,
                toItem: containerView, attribute: .centerX, multiplier: 1.0, constant: 0),
        ])
        
        containerView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: messageLabel, attribute: .top, relatedBy: .equal,
                toItem: hStackView, attribute: .bottom, multiplier: 1.0, constant: 40.0),
            NSLayoutConstraint(
                item: messageLabel, attribute: .centerX, relatedBy: .equal,
                toItem: containerView, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: messageLabel, attribute: .left, relatedBy: .greaterThanOrEqual,
                toItem: containerView, attribute: .left, multiplier: 1.0, constant: 33.0),
            NSLayoutConstraint(
                item: messageLabel, attribute: .right, relatedBy: .lessThanOrEqual,
                toItem: containerView, attribute: .right, multiplier: 1.0, constant: -33.0),
            NSLayoutConstraint(
                item: messageLabel, attribute: .bottom, relatedBy: .equal,
                toItem: containerView, attribute: .bottom, multiplier: 1.0, constant: -44.0),
        ])
    }
}

extension AlertView {
    func show() {
        DispatchQueue.main.async {
            let mainWindow = UIWindow.keyWindow ?? UIWindow()
            mainWindow.addSubview(self)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.animateShowDimmedView()
            self.animatePresentContainer()
        }
    }
}
