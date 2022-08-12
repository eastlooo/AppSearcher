//
//  SearchView.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/12.
//

import UIKit
import Combine

final class SearchView: UIView {
    
    // MARK: Properties
    private let viewModel: SearchViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let searchBackgroundView = UIView()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 18.0, weight: .medium)
        textField.textColor = .black
        textField.backgroundColor = .clear
        textField.keyboardType = .numberPad
        return textField
    }()
    
    // MARK: Lifecycle
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func configure() {
        self.backgroundColor = .primary
        searchBackgroundView.backgroundColor = .white
        searchBackgroundView.layer.cornerRadius = 20.0
    }
    
    private func layout() {
        self.addSubview(searchBackgroundView)
        searchBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: searchBackgroundView, attribute: .left, relatedBy: .equal,
                toItem: self, attribute: .left, multiplier: 1.0, constant: 20.0),
            NSLayoutConstraint(
                item: searchBackgroundView, attribute: .right, relatedBy: .equal,
                toItem: self, attribute: .right, multiplier: 1.0, constant: -20.0),
            NSLayoutConstraint(
                item: searchBackgroundView, attribute: .bottom, relatedBy: .equal,
                toItem: self, attribute: .bottom, multiplier: 1.0, constant: -15.0),
            searchBackgroundView.heightAnchor.constraint(equalToConstant: 40.0),
        ])

        searchBackgroundView.addSubview(searchTextField)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: searchTextField, attribute: .top, relatedBy: .equal,
                toItem: searchBackgroundView, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: searchTextField, attribute: .left, relatedBy: .equal,
                toItem: searchBackgroundView, attribute: .left, multiplier: 1.0, constant: 25.0),
            NSLayoutConstraint(
                item: searchTextField, attribute: .right, relatedBy: .equal,
                toItem: searchBackgroundView, attribute: .right, multiplier: 1.0, constant: -25.0),
            NSLayoutConstraint(
                item: searchTextField, attribute: .bottom, relatedBy: .equal,
                toItem: searchBackgroundView, attribute: .bottom, multiplier: 1.0, constant: 0),
        ])
    }
    
    private func bind() {
        
    }
}

extension SearchView {
    func setInputAccessoryView(_ view: UIView) {
        searchTextField.inputAccessoryView = view
    }
}
