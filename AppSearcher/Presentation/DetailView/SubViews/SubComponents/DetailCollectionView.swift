//
//  DetailCollectionView.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/13.
//

import UIKit

final class DetailCollectionView: UICollectionView {
    
    // MARK: Properties
    
    // MARK: Lifecycle
    init() {
        super.init(frame: .zero, collectionViewLayout: .init())
        
        self.collectionViewLayout = createCompositionalLayout()
        self.backgroundColor = .background
        registerReusableItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func registerReusableItem() {
        self.register(DetailMainCell.self,
                      forCellWithReuseIdentifier: DetailMainCell.reuseIdentifier)
        self.register(DetailScreenshotCell.self,
                      forCellWithReuseIdentifier: DetailScreenshotCell.reuseIdentifier)
        self.register(DetailIntroduceCell.self,
                      forCellWithReuseIdentifier: DetailIntroduceCell.reuseIdentifier)
        self.register(DetailNewFeatureCell.self,
                      forCellWithReuseIdentifier: DetailNewFeatureCell.reuseIdentifier)
        self.register(DetailAdditionalCell.self,
                      forCellWithReuseIdentifier: DetailAdditionalCell.reuseIdentifier)
        
        self.register(DetailReusableHeaderView.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: DetailReusableHeaderView.reuseIdentifier)
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] section, _ -> NSCollectionLayoutSection? in
            switch section {
            case 0:  return self?.createMainSectionLayout()
            case 1:  return self?.createScreenshotSectionLayout()
            case 2:  return self?.createIntroduceSectionLayout()
            case 3:  return self?.createNewFeatureSectionLayout()
            case 4:  return self?.createAdditionalSectionLayout()
            default: return nil }
        }
        layout.register(DetailReusableBackgroundView.self,
                        forDecorationViewOfKind: DetailReusableBackgroundView.reuseIdentifier)
        return layout
    }
    
    private func createMainSectionLayout() -> NSCollectionLayoutSection {
        return createSectionLayout(itemWidth: .fractionalWidth(1.0),
                                   itemHeight: .fractionalHeight(1.0),
                                   groupWidth: .fractionalWidth(1.0),
                                   groupHeight: .absolute(150.0))
    }
    
    private func createScreenshotSectionLayout() -> NSCollectionLayoutSection {
        let sideMargin: CGFloat = 45.0
        let itemContentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16.0, bottom: 0, trailing: 16.0)
        let groupWidth = self.frame.width - (sideMargin * 2)
        let groupHeight = groupWidth * 696.0 / 392.0
        let section = createSectionLayout(itemWidth: .fractionalWidth(1.0),
                                          itemHeight: .fractionalHeight(1.0),
                                          itemContentInsets: itemContentInsets,
                                          groupWidth: .absolute(groupWidth),
                                          groupHeight: .absolute(groupHeight),
                                          scrollDirection: .horizontal)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: 36.0, leading: sideMargin, bottom: 45.0, trailing: sideMargin)
        let decorationItem = NSCollectionLayoutDecorationItem.background(
            elementKind: DetailReusableBackgroundView.reuseIdentifier)
        section.decorationItems = [decorationItem]
        return section
    }

    private func createIntroduceSectionLayout() -> NSCollectionLayoutSection {
        let estimatedHeight = NSCollectionLayoutDimension.estimated(200.0)
        let sideMargin: CGFloat = 20.0
        let headerWidth = self.frame.width - (sideMargin * 2)
        let section = createSectionLayout(itemWidth: .fractionalWidth(1.0),
                                          itemHeight: estimatedHeight,
                                          groupWidth: .fractionalWidth(1.0),
                                          groupHeight: estimatedHeight,
                                          scrollDirection: .horizontal)
        section.contentInsets = .init(top: 0, leading: sideMargin, bottom: 45.0, trailing: sideMargin)
        let sectionHeader = createSectionHeaderLayout(width: .absolute(headerWidth),
                                                            height: .absolute(35.0))
        section.boundarySupplementaryItems = [sectionHeader]
        let decorationItem = NSCollectionLayoutDecorationItem.background(
            elementKind: DetailReusableBackgroundView.reuseIdentifier)
        section.decorationItems = [decorationItem]
        return section
    }

    private func createNewFeatureSectionLayout() -> NSCollectionLayoutSection {
        let estimatedHeight = NSCollectionLayoutDimension.estimated(200.0)
        let sideMargin: CGFloat = 20.0
        let headerWidth = self.frame.width - (sideMargin * 2)
        let section = createSectionLayout(itemWidth: .fractionalWidth(1.0),
                                          itemHeight: estimatedHeight,
                                          groupWidth: .fractionalWidth(1.0),
                                          groupHeight: estimatedHeight,
                                          scrollDirection: .horizontal)
        section.contentInsets = .init(top: 0, leading: sideMargin, bottom: 45.0, trailing: sideMargin)
        let sectionHeader = createSectionHeaderLayout(width: .absolute(headerWidth),
                                                            height: .absolute(35.0))
        section.boundarySupplementaryItems = [sectionHeader]
        let decorationItem = NSCollectionLayoutDecorationItem.background(
            elementKind: DetailReusableBackgroundView.reuseIdentifier)
        section.decorationItems = [decorationItem]
        return section
    }

    private func createAdditionalSectionLayout() -> NSCollectionLayoutSection {
        let itemMargin: CGFloat = 8.5
        let sideMargin: CGFloat = 20.0
        let headerWidth = self.frame.width - (sideMargin * 2)
        let itemContentInsets = NSDirectionalEdgeInsets(top: 0, leading: itemMargin, bottom: 20.0, trailing: itemMargin)
        let section = createSectionLayout(itemWidth: .fractionalWidth(0.5),
                                          itemHeight: .fractionalHeight(1.0),
                                          itemContentInsets: itemContentInsets,
                                          groupWidth: .fractionalWidth(1.0),
                                          groupHeight: .absolute(120.0),
                                          itemCount: 2,
                                          scrollDirection: .horizontal)
        section.contentInsets = .init(top: 0, leading: sideMargin-itemMargin, bottom: 45.0, trailing: sideMargin-itemMargin)
        let sectionHeader = createSectionHeaderLayout(width: .absolute(headerWidth),
                                                            height: .absolute(35.0))
        section.boundarySupplementaryItems = [sectionHeader]
        let decorationItem = NSCollectionLayoutDecorationItem.background(
            elementKind: DetailReusableBackgroundView.reuseIdentifier)
        section.decorationItems = [decorationItem]
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
    
    private func createSectionHeaderLayout(width: NSCollectionLayoutDimension,
                                           height: NSCollectionLayoutDimension) -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: width,
                                                       heightDimension: height)
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize,
                                                           elementKind: UICollectionView.elementKindSectionHeader,
                                                           alignment: .top)
    }
}
