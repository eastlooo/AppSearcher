//
//  ScreenshotViewController.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/14.
//

import UIKit
import Combine

final class ScreenshotViewController: UICollectionViewController {
    
    // MARK: Properties
    private let viewModel: ScreenshotViewModel
    private var cancellables = Set<AnyCancellable>()
    private let viewDidLayoutSubviews$ = PassthroughSubject<Void, Never>()
    
    private var screenshotDataSource: [DetailScreenshotCellViewModel] = [] {
        didSet { updateScreenshotSection() }
    }
    
    // MARK: Lifecycle
    init(viewModel: ScreenshotViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewDidLayoutSubviews$.send()
    }
    
    deinit { print("ScreenshotViewController deinit..") }
    
    // MARK: Helpers
    private func configure() {
        collectionView.backgroundColor = .black
        collectionView.bounces = false
        collectionView.register(DetailScreenshotCell.self,
                      forCellWithReuseIdentifier: DetailScreenshotCell.reuseIdentifier)
    }
    
    private func layout() {
        let layout =  UICollectionViewCompositionalLayout { [weak self] _, _ -> NSCollectionLayoutSection? in
            self?.createScreenshotSectionLayout()
        }
        collectionView.collectionViewLayout = layout
    }
     
    private func bind() {
        viewModel.output.screenshotDataSource
            .sink { [weak self] dataSource in
                self?.screenshotDataSource = dataSource
            }
            .store(in: &cancellables)
        
        viewDidLayoutSubviews$
            .debounce(for: 0.05, scheduler: RunLoop.main)
            .zip(viewModel.output.index)
            .map(\.1)
            .sink { [weak self] index in
                self?.collectionView.scrollToItem(
                    at: IndexPath(item: index, section: 0),
                    at: .centeredHorizontally,
                    animated: false)
            }
            .store(in: &cancellables)
    }
    
    private func createScreenshotSectionLayout() -> NSCollectionLayoutSection {
        let sideMargin: CGFloat = 25.0
        
        let itemWidth: CGFloat = collectionView.frame.width - sideMargin * 2
        let itemHeight: CGFloat = itemWidth / 392.0 * 696.0
        let verticalMargin: CGFloat = (collectionView.frame.height - itemHeight - 44.0) / 2
        
        let itemContentInsets = NSDirectionalEdgeInsets(top: 0, leading: sideMargin - 12.0, bottom: 0, trailing: sideMargin - 12.0)
        let section = createSectionLayout(itemWidth: .fractionalWidth(1.0),
                                          itemHeight: .fractionalHeight(1.0),
                                          itemContentInsets: itemContentInsets,
                                          groupWidth: .absolute(itemWidth),
                                          groupHeight: .absolute(itemHeight),
                                          scrollDirection: .horizontal)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: verticalMargin, leading: sideMargin, bottom: 0, trailing: sideMargin)
        return section
    }
    
    private func createSectionLayout(itemWidth: NSCollectionLayoutDimension,
                                     itemHeight: NSCollectionLayoutDimension,
                                     itemContentInsets: NSDirectionalEdgeInsets = .zero,
                                     groupWidth: NSCollectionLayoutDimension,
                                     groupHeight: NSCollectionLayoutDimension,
                                     groupContentInsets: NSDirectionalEdgeInsets = .zero,
                                     itemCount: Int = 1,
                                     scrollDirection: UICollectionView.ScrollDirection = .vertical) -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: itemWidth, heightDimension: itemHeight)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = itemContentInsets
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth, heightDimension: groupHeight)
        let group = (scrollDirection == .vertical) ?
        NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: itemCount) :
        NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: itemCount)
        group.contentInsets = groupContentInsets
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func updateScreenshotSection() {
        DispatchQueue.main.async {
            self.collectionView.reloadSections(.init(integer: 0))
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ScreenshotViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        screenshotDataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DetailScreenshotCell.reuseIdentifier,
            for: indexPath) as! DetailScreenshotCell
        cell.bind(with: screenshotDataSource[indexPath.item])
        return cell
    }
}
