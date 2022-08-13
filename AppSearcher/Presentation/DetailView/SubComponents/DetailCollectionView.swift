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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func createCompositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] section, _ -> NSCollectionLayoutSection? in
            switch section {
            case 0:  return self?.createMainSectionLayout()
            case 1:  return self?.createScreenshotSectionLayout()
            case 2:  return self?.createIntroduceSectionLayout()
            case 3:  return self?.createNewFeatureSectionLayout()
            case 4:  return self?.createAdditionalSectionLayout()
            default: return nil }
        }
    }
    
    private func createMainSectionLayout() -> NSCollectionLayoutSection {
        return createSectionLayout(itemWidth: .fractionalWidth(1.0),
                                   itemHeight: .fractionalHeight(1.0),
                                   groupWidth: .fractionalWidth(1.0),
                                   groupHeight: .absolute(145.0))
    }
    
    private func createScreenshotSectionLayout() -> NSCollectionLayoutSection {
        let itemContentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12.0, bottom: 0, trailing: 12.0)
        let groupWidth = self.frame.width - (35.0 * 2)
        let groupHeight = groupWidth * 696.0 / 392.0
        let sectionLayout = createSectionLayout(itemWidth: .fractionalWidth(1.0),
                                                itemHeight: .fractionalHeight(1.0),
                                                itemContentInsets: itemContentInsets,
                                                groupWidth: .absolute(groupWidth),
                                                groupHeight: .absolute(groupHeight),
                                                scrollDirection: .horizontal)
        sectionLayout.orthogonalScrollingBehavior = .groupPaging
        sectionLayout.contentInsets = .init(top: 36.0, leading: 35.0, bottom: 40.0, trailing: 35.0)
        return sectionLayout
    }

    private func createIntroduceSectionLayout() -> NSCollectionLayoutSection {
        let headerWidth = self.frame.width - (17.0 * 2)
        let sectionLayout = createSectionLayout(itemWidth: .fractionalWidth(1.0),
                                   itemHeight: .fractionalHeight(1.0),
                                   groupWidth: .fractionalWidth(1.0),
                                   groupHeight: .absolute(187.0))
        sectionLayout.contentInsets = .init(top: 0, leading: 17.0, bottom: 40.0, trailing: 17.0)
        let sectionHeaderLayout = createSectionHeaderLayout(width: .absolute(headerWidth),
                                                            height: .absolute(30.0))
        sectionLayout.boundarySupplementaryItems = [sectionHeaderLayout]
        return sectionLayout
    }

    private func createNewFeatureSectionLayout() -> NSCollectionLayoutSection {
        let headerWidth = self.frame.width - (17.0 * 2)
        let sectionLayout = createSectionLayout(itemWidth: .fractionalWidth(1.0),
                                   itemHeight: .fractionalHeight(1.0),
                                   groupWidth: .fractionalWidth(1.0),
                                   groupHeight: .absolute(138.0))
        sectionLayout.contentInsets = .init(top: 0, leading: 17.0, bottom: 40.0, trailing: 17.0)
        let sectionHeaderLayout = createSectionHeaderLayout(width: .absolute(headerWidth),
                                                            height: .absolute(30.0))
        sectionLayout.boundarySupplementaryItems = [sectionHeaderLayout]
        return sectionLayout
    }

    private func createAdditionalSectionLayout() -> NSCollectionLayoutSection {
        let headerWidth = self.frame.width - (17.0 * 2)
        let itemContentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 8.5, bottom: 5.0, trailing: 8.5)
        let sectionLayout = createSectionLayout(itemWidth: .fractionalWidth(0.5),
                                   itemHeight: .fractionalHeight(1.0),
                                   itemContentInsets: itemContentInsets,
                                   groupWidth: .fractionalWidth(1.0),
                                   groupHeight: .absolute(100.0),
                                   itemCount: 2,
                                   scrollDirection: .horizontal)
        sectionLayout.contentInsets = .init(top: 0, leading: 8.5, bottom: 40.0, trailing: 8.5)
        let sectionHeaderLayout = createSectionHeaderLayout(width: .absolute(headerWidth),
                                                            height: .absolute(30.0))
        sectionLayout.boundarySupplementaryItems = [sectionHeaderLayout]
        return sectionLayout
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
