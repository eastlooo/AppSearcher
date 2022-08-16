//
//  MainViewController.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/12.
//

import UIKit
import Combine

final class MainViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: MainViewModel
    private var cancellables = Set<AnyCancellable>()
    private let topView = UIView()
    private let bottomView = UIView()
    private let searchView: SearchView
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "터치하여 검색하기"
        label.font = .systemFont(ofSize: 21.0, weight: .black)
        label.textColor = .primary
        return label
    }()
    
    private let guideButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "app_mark"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.adjustsImageWhenHighlighted = false
        return button
    }()

    // MARK: Lifecycle
    init(viewModel: MainViewModel) {
        let searchViewModel = viewModel.subViewModels.searchViewModel
        self.viewModel = viewModel
        self.searchView = SearchView(viewModel: searchViewModel)
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
        bind()
        addNotificationCenter()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animateGuideButton(true)
    }
    
    // MARK: Animations
    private func animateSearchViewHeight(show: Bool) {
        let height = show ? 80.0 : 0
        UIView.animate(withDuration: 0.3) {
            NSLayoutConstraint.activate(
                self.searchView.constraints
                    .filter { $0.firstAttribute == .height }
                    .map { constraint -> NSLayoutConstraint in
                        constraint.constant = height
                        return constraint
                    }
            )
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateGuideButton(_ animate: Bool) {
        guideButton.layer.removeAllAnimations()
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = 1.09

        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 1.0
        animationGroup.repeatCount = .infinity
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animationGroup.autoreverses = true
        animationGroup.animations = [scaleAnimation]
        
        if animate {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.guideButton.layer.add(animationGroup, forKey: "pulse")
            }
        } else {
            guideButton.layer.removeAnimation(forKey: "pulse")
        }
    }
    
    // MARK: Actions
    @objc
    private func observeWillEnterForegroundNotification() {
        if !messageLabel.isHidden {
            animateGuideButton(true)
        }
    }
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .white
        topView.backgroundColor = .primary
        bottomView.backgroundColor = .primary
    }
    
    private func layout() {
        view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: topView, attribute: .top, relatedBy: .equal,
                toItem: view, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: topView, attribute: .left, relatedBy: .equal,
                toItem: view, attribute: .left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: topView, attribute: .right, relatedBy: .equal,
                toItem: view, attribute: .right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: topView, attribute: .bottom, relatedBy: .equal,
                toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0),
        ])
        
        view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: bottomView, attribute: .left, relatedBy: .equal,
                toItem: view, attribute: .left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: bottomView, attribute: .right, relatedBy: .equal,
                toItem: view, attribute: .right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: bottomView, attribute: .bottom, relatedBy: .equal,
                toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: bottomView, attribute: .height, relatedBy: .equal,
                toItem: topView, attribute: .height, multiplier: 1.0, constant: 0),
        ])
        
        view.addSubview(guideButton)
        guideButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: guideButton, attribute: .centerX, relatedBy: .equal,
                toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: guideButton, attribute: .centerY, relatedBy: .equal,
                toItem: view, attribute: .centerY, multiplier: 1.0, constant: -35.0),
            guideButton.widthAnchor.constraint(equalToConstant: 170.0),
            guideButton.heightAnchor.constraint(equalToConstant: 170.0),
        ])
        
        view.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: messageLabel, attribute: .centerX, relatedBy: .equal,
                toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: messageLabel, attribute: .top, relatedBy: .equal,
                toItem: guideButton, attribute: .centerY, multiplier: 1.0, constant: 110.0),
        ])
        
        view.addSubview(searchView)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: searchView, attribute: .top, relatedBy: .equal,
                toItem: topView, attribute: .bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: searchView, attribute: .left, relatedBy: .equal,
                toItem: view, attribute: .left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: searchView, attribute: .right, relatedBy: .equal,
                toItem: view, attribute: .right, multiplier: 1.0, constant: 0),
            searchView.heightAnchor.constraint(equalToConstant: 0),
        ])
    }
    
    private func bind() {
        guideButton.tapPublisher
            .throttle(for: 0.7, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                HapticManager.instance.impact(style: .medium)
                self?.viewModel.input.guideButtonTapped.send()
            }
            .store(in: &cancellables)
        
        viewModel.output.isSearchingMode
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] isSearchingMode in
                self?.animateGuideButton(!isSearchingMode)
                self?.animateSearchViewHeight(show: isSearchingMode)
                self?.searchView.setFirstResponder(to: isSearchingMode)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self?.messageLabel.isHidden = isSearchingMode
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.showDetailView
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewModel in
                let viewController = DetailContainerViewController(viewModel: viewModel)
                viewController.modalPresentationStyle = .overFullScreen
                self?.present(viewController, animated: false)
            }
            .store(in: &cancellables)
        
        viewModel.output.showAlert
            .receive(on: DispatchQueue.main)
            .sink { message in
                HapticManager.instance.notification(type: .warning)
                let message = "유효하지 않은 APP_ID 입니다."
                let alert = AlertView(message: message)
                alert.show()
            }
            .store(in: &cancellables)
    }
    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(observeWillEnterForegroundNotification),
            name: UIApplication.willEnterForegroundNotification,
            object: nil)
    }
}
