//
//  DetailViewController.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/13.
//

import UIKit

final class DetailViewController: UIViewController {
    
    // MARK: Properties
    var isScrollEnabled: Bool = false
    private(set) var isScrollsTop: Bool = true
    
    private let collectionView = DetailCollectionView()
    
    // MARK: Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
}

// MARK: - UICollectionViewDataSource
extension DetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0, 2, 3: return 1
        case 1: return 7
        case 4: return 6
        default: return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DetailMainCell.reuseIdentifier,
                for: indexPath) as! DetailMainCell
            
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DetailScreenshotCell.reuseIdentifier,
                for: indexPath) as! DetailScreenshotCell
                
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DetailIntroduceCell.reuseIdentifier,
                for: indexPath) as! DetailIntroduceCell
            cell.delegate = self
            return cell
            
        case 3:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DetailNewFeatureCell.reuseIdentifier,
                for: indexPath) as! DetailNewFeatureCell
                
            return cell
            
        case 4:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DetailAdditionalCell.reuseIdentifier,
                for: indexPath) as! DetailAdditionalCell
                
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
        if indexPath.section == 1 {
            let viewContoller = ScreenshotViewController()
            self.navigationController?.pushViewController(viewContoller, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let defaultOffset = navigationController?.navigationBar.frame.height else { return }
        if scrollView.contentOffset.y < -defaultOffset || !isScrollEnabled {
            scrollView.contentOffset.y = -defaultOffset
            isScrollsTop = true
        } else {
            isScrollsTop = false
        }
    }
}

extension DetailViewController: DetailIntroduceCellDelegate {
    func updateLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}
