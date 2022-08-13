//
//  DetailContainerViewController.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/13.
//

import UIKit

final class DetailContainerViewController: UIViewController {
    
    // MARK: Properties
    private let defaultHeight: CGFloat = UIScreen.main.bounds.height - safeAreaTopInset
    private var dismissibleHeight: CGFloat { defaultHeight * 0.7 }
    private var currentContainerHeight: CGFloat = UIScreen.main.bounds.height - safeAreaTopInset
    
    private lazy var containerHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
    private lazy var containerBottomConstraint = NSLayoutConstraint(
        item: containerView, attribute: .bottom, relatedBy: .equal,
        toItem: view, attribute: .bottom, multiplier: 1.0, constant: defaultHeight)
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.clipsToBounds = true
        return view
    }()
    
    private let holderView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.layer.cornerRadius = 2.5
        return view
    }()
    
    private let panGesture: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer()
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        return panGesture
    }()
    
    private let childViewController: UINavigationController
    
    // MARK: Lifecycle
    init() {
        let rootViewController = DetailViewController()
        self.childViewController = UINavigationController(rootViewController: rootViewController)
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animatePresentContainer()
    }
    
    // MARK: Animations
    private func animatePresentContainer() {
        UIView.animate(withDuration: 0.3) {
            self.containerBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateDismissView() {
        UIView.animate(withDuration: 0.3) {
            self.containerBottomConstraint.constant = self.defaultHeight
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
    
    private func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            NSLayoutConstraint.activate(
                self.containerView.constraints
                    .filter { $0.firstAttribute == .height }
                    .map { constraint -> NSLayoutConstraint in
                        constraint.constant = height
                        return constraint
                    }
            )
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: Actions
    @objc
    private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let newHeight = currentContainerHeight - translation.y
 
        switch gesture.state {
        case .changed:
            if newHeight < defaultHeight {
                containerHeightConstraint.constant = newHeight
                view.layoutIfNeeded()
            }

        case .ended:
            if newHeight < dismissibleHeight {
                animateDismissView()
            } else if newHeight < defaultHeight {
                animateContainerHeight(defaultHeight)
                currentContainerHeight = defaultHeight
            }

        default:
            break
        }
    }
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .clear
        containerView.backgroundColor = .white
        
        panGesture.addTarget(self, action: #selector(handlePanGesture))
        childViewController.navigationBar.addGestureRecognizer(panGesture)
    }
    
    private func layout() {
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: containerView, attribute: .left, relatedBy: .equal,
                toItem: view, attribute: .left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: containerView, attribute: .right, relatedBy: .equal,
                toItem: view, attribute: .right, multiplier: 1.0, constant: 0),
            containerBottomConstraint,
            containerHeightConstraint,
        ])
        
        let childView = childViewController.view!
        self.addChild(childViewController)
        containerView.addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: childView, attribute: .top, relatedBy: .equal,
                toItem: containerView, attribute: .top, multiplier: 1.0, constant: 10.0),
            NSLayoutConstraint(
                item: childView, attribute: .left, relatedBy: .equal,
                toItem: containerView, attribute: .left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: childView, attribute: .right, relatedBy: .equal,
                toItem: containerView, attribute: .right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: childView, attribute: .bottom, relatedBy: .equal,
                toItem: containerView, attribute: .bottom, multiplier: 1.0, constant: 0),
        ])
        childViewController.didMove(toParent: self)
 
        view.addSubview(holderView)
        holderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: holderView, attribute: .top, relatedBy: .equal,
                toItem: containerView, attribute: .top, multiplier: 1.0, constant: 20.0),
            NSLayoutConstraint(
                item: holderView, attribute: .centerX, relatedBy: .equal,
                toItem: containerView, attribute: .centerX, multiplier: 1.0, constant: 0),
            holderView.widthAnchor.constraint(equalToConstant: 45.0),
            holderView.heightAnchor.constraint(equalToConstant: 5.0),
        ])
    }
}
