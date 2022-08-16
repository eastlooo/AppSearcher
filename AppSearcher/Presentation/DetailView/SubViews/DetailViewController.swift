//
//  DetailViewController.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/13.
//

import UIKit
import Combine

final class DetailViewController: UIViewController {
    
    // MARK: Properties
    weak var containerViewController: DetailContainerViewController?
    
    var isScrollEnabled: Bool = false // <-> ContainerView
    
    private let viewModel: DetailViewModel
    private var cancellables = Set<AnyCancellable>()
    private let itemSelected$ = PassthroughSubject<IndexPath, Never>()
    
    private var mainDataSource: DetailMainCellViewModel? {
        didSet { updateMainSection(mainDataSource) }
    }
    
    private var screenshotDataSource: [DetailScreenshotCellViewModel] = [] {
        didSet { updateScreenshotSection() }
    }
    
    private var introduceDataSource: DetailIntroduceCellViewModel? {
        didSet { updateIntroduceSection(introduceDataSource) }
    }
    
    private var newFeatureDataSource: AppInfo.NewFeature? {
        didSet { updateNewFeatureSection(newFeatureDataSource) }
    }
    
    private var additionalDataSource: [(String, String?)] = [] {
        didSet { updateAddtionalSection() }
    }
    
    private let collectionView = DetailCollectionView()
    
    // MARK: Lifecycle
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let defaultOffset = navigationController?.navigationBar.frame.height,
           collectionView.contentOffset.y == -defaultOffset {
            containerViewController?.isDismissable = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        containerViewController?.isDismissable = false
    }
    
    deinit { print("DetailViewController deinit..") }
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .clear
        
        collectionView.dataSource = self
        collectionView.delegate = self
        navigationItem.backButtonTitle = ""
    }
    
    private func layout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: collectionView, attribute: .top, relatedBy: .equal,
                toItem: view, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: collectionView, attribute: .left, relatedBy: .equal,
                toItem: view, attribute: .left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: collectionView, attribute: .right, relatedBy: .equal,
                toItem: view, attribute: .right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(
                item: collectionView, attribute: .bottom, relatedBy: .equal,
                toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0),
        ])
    }
    
    private func bind() {
        itemSelected$
            .filter { $0.section == 1 }
            .map(\.item)
            .sink { [weak self] item in
                self?.viewModel.input.screenshotItemSelected.send(item)
            }
            .store(in: &cancellables)
        
        viewModel.output.mainDataSource
            .compactMap { $0 }
            .sink { [weak self] dataSource in
                self?.mainDataSource = dataSource
            }
            .store(in: &cancellables)
        
        viewModel.output.screenshotDataSource
            .sink { [weak self] dataSource in
                self?.screenshotDataSource = dataSource
            }
            .store(in: &cancellables)
        
        viewModel.output.introduceDataSource
            .compactMap { $0 }
            .sink { [weak self] dataSource in
                self?.introduceDataSource = dataSource
            }
            .store(in: &cancellables)
        
        viewModel.output.newFeatureDataSource
            .sink { [weak self] dataSource in
                self?.newFeatureDataSource = dataSource
            }
            .store(in: &cancellables)
        
        viewModel.output.additionalDataSource
            .sink { [weak self] dataSource in
                self?.additionalDataSource = dataSource
            }
            .store(in: &cancellables)
        
        viewModel.output.openShare
            .compactMap { $0 }
            .sink { [weak self] url in
                let viewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                viewController.popoverPresentationController?.sourceView = self?.view
                self?.present(viewController, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.output.updateCollectionLayout
            .sink { [weak self] _ in
                self?.collectionView.collectionViewLayout.invalidateLayout()
            }
            .store(in: &cancellables)
        
        viewModel.output.showScreenshotView
            .sink { [weak self] viewModel in
                let viewController = ScreenshotViewController(viewModel: viewModel)
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func updateMainSection(_ dataSource: DetailMainCellViewModel?) {
        guard dataSource != nil else { return }
        DispatchQueue.main.async {
            self.collectionView.reloadSections(.init(integer: 0))
        }
    }
    
    private func updateScreenshotSection() {
        DispatchQueue.main.async {
            self.collectionView.reloadSections(.init(integer: 1))
        }
    }
    
    private func updateIntroduceSection(_ dataSource: DetailIntroduceCellViewModel?) {
        guard dataSource != nil else { return }
        DispatchQueue.main.async {
            self.collectionView.reloadSections(.init(integer: 2))
        }
    }
    
    private func updateNewFeatureSection(_ dataSource: AppInfo.NewFeature?) {
        guard dataSource != nil else { return }
        DispatchQueue.main.async {
            self.collectionView.reloadSections(.init(integer: 3))
        }
    }
    
    private func updateAddtionalSection() {
        DispatchQueue.main.async {
            self.collectionView.reloadSections(.init(integer: 4))
        }
    }
}

// MARK: - UICollectionViewDataSource
extension DetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0, 2, 3: return 1
        case 1: return screenshotDataSource.count
        case 4: return additionalDataSource.count
        default: return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DetailMainCell.reuseIdentifier,
                for: indexPath) as! DetailMainCell
            mainDataSource.map { cell.bind(with: $0) }
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DetailScreenshotCell.reuseIdentifier,
                for: indexPath) as! DetailScreenshotCell
            cell.bind(with: screenshotDataSource[indexPath.item])
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DetailIntroduceCell.reuseIdentifier,
                for: indexPath) as! DetailIntroduceCell
            introduceDataSource.map { cell.bind(with: $0) }
            return cell
            
        case 3:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DetailNewFeatureCell.reuseIdentifier,
                for: indexPath) as! DetailNewFeatureCell
            newFeatureDataSource.map { cell.bind(with: $0) }
            return cell
            
        case 4:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DetailAdditionalCell.reuseIdentifier,
                for: indexPath) as! DetailAdditionalCell
            cell.bind(with: additionalDataSource[indexPath.item])
            return cell
            
        default:
            assert(false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: DetailReusableHeaderView.reuseIdentifier,
            for: indexPath) as! DetailReusableHeaderView
        
        switch indexPath.section {
        case 2: headerView.title = "소개"
        case 3: headerView.title = "새로운 기능"
        case 4: headerView.title = "정보"
        default: break
        }
        
        return headerView
    }
}

// MARK: - UICollectionViewDelegate
extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemSelected$.send(indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let defaultOffset = navigationController?.navigationBar.frame.height else { return }
        if scrollView.contentOffset.y < -defaultOffset || !isScrollEnabled {
            scrollView.contentOffset.y = -defaultOffset
            containerViewController?.isDismissable = true
        } else {
            containerViewController?.isDismissable = false
        }
    }
}
