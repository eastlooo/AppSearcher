//
//  ScreenshotViewController.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/14.
//

import UIKit

final class ScreenshotViewController: UIViewController {
    
    // MARK: Properties
    
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
        view.backgroundColor = .white
    }
    
    private func layout() {
        
    }
}
