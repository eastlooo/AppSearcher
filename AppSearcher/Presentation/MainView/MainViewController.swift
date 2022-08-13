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
        label.font = .systemFont(ofSize: 20.0, weight: .heavy)
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let viewController = DetailContainerViewController()
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: false)
        }
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
                toItem: guideButton, attribute: .centerY, multiplier: 1.0, constant: 100.0),
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
            .sink { [weak self] _ in
                self?.viewModel.input.guideButtonTapped.send()
            }
            .store(in: &cancellables)
        
        viewModel.output.isSearchingMode
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] isSearchingMode in
                self?.animateSearchViewHeight(show: isSearchingMode)
                self?.searchView.setFirstResponder(to: isSearchingMode)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self?.messageLabel.isHidden = isSearchingMode
                }

            }
            .store(in: &cancellables)
    }
}
