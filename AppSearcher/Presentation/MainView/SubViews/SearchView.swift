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
    private let accessoryView = UIView()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 18.0, weight: .medium)
        textField.textColor = .black
        textField.backgroundColor = .clear
        textField.keyboardType = .numberPad
        textField.attributedPlaceholder = NSAttributedString(
            string: "\"APP_ID\"를 입력해주세요",
            attributes: [
                .font: UIFont.systemFont(ofSize: 18.0, weight: .medium),
                .foregroundColor: UIColor.systemGray])
        return textField
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(
            NSAttributedString(
                string: "Search",
                attributes: [
                    .foregroundColor: UIColor.white,
                    .font: UIFont.systemFont(ofSize: 20.0, weight: .semibold)
                ]), for: .normal)
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 20.0, weight: .medium)
        let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = .systemGray4
        return button
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
        self.clipsToBounds = true
        searchBackgroundView.backgroundColor = .white
        searchBackgroundView.layer.cornerRadius = 20.0
        accessoryView.backgroundColor = .primary
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 20.0, weight: .medium)
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: configuration)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .systemGray
        searchTextField.leftView = imageView
        searchTextField.leftViewMode = .always
        searchTextField.inputAccessoryView = accessoryView
    }
    
    private func layout() {
        let hStackView = UIStackView(arrangedSubviews: [searchTextField, deleteButton])
        hStackView.axis = .horizontal
        hStackView.distribution = .fill
        hStackView.spacing = 0
        
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
        
        self.addSubview(hStackView)
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: hStackView, attribute: .left, relatedBy: .equal,
                toItem: searchBackgroundView, attribute: .left, multiplier: 1.0, constant: 20.0),
            NSLayoutConstraint(
                item: hStackView, attribute: .right, relatedBy: .equal,
                toItem: searchBackgroundView, attribute: .right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: hStackView, attribute: .centerY, relatedBy: .equal,
                toItem: searchBackgroundView, attribute: .centerY, multiplier: 1.0, constant: 0),
        ])
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.widthAnchor.constraint(equalToConstant: 44.0),
            deleteButton.heightAnchor.constraint(equalToConstant: 44.0),
        ])

        
        accessoryView.frame.size.width = UIScreen.main.bounds.width
        accessoryView.frame.size.height = 48.0
        accessoryView.addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: searchButton, attribute: .centerY, relatedBy: .equal,
                toItem: accessoryView, attribute: .centerY, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: searchButton, attribute: .right, relatedBy: .equal,
                toItem: accessoryView, attribute: .right, multiplier: 1.0, constant: -20.0),
            searchButton.heightAnchor.constraint(equalToConstant: 44.0),
        ])
    }
    
    private func bind() {
        searchTextField.textPublisher
            .sink { [weak self] text in
                self?.viewModel.input.text.send(text)
            }
            .store(in: &cancellables)
        
        searchButton.tapPublisher
            .sink { [weak self] _ in
                self?.viewModel.input.searchButtonTapped.send()
            }
            .store(in: &cancellables)
        
        deleteButton.tapPublisher
            .sink { [weak self] _ in
                self?.searchTextField.text = ""
                self?.viewModel.input.deleteButtonTapped.send()
            }
            .store(in: &cancellables)
        
        viewModel.output.hideDeleteButton
            .sink { [weak self] hide in
                self?.deleteButton.isHidden = hide
            }
            .store(in: &cancellables)
    }
}

extension SearchView {
    func setFirstResponder(to set: Bool) {
        if set {
            _ = searchTextField.becomeFirstResponder()
        } else {
            _ = searchTextField.resignFirstResponder()
        }
    }
}
