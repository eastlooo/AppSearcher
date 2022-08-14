//
//  StarView.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/15.
//

import UIKit

final class StarView: UIView {
    
    // MARK: Properties
    var fraction: Double = .zero
    
    private let starLayer = CALayer()
    private let starEdgeLayer = CALayer()
    private let colorLayer = CALayer()
    
    private let firstView = UIView()
    private let secondView = UIView()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutLayer()
    }
    
    // MARK: Helpers
    private func configure() {
        self.addSubview(firstView)
        self.addSubview(secondView)
        
        starLayer.contents = UIImage(systemName: "star.fill")?.cgImage
        starLayer.contentsGravity = .resizeAspect
        
        starEdgeLayer.contents = UIImage(systemName: "star")?.cgImage
        starEdgeLayer.contentsGravity = .resizeAspect
        
        firstView.layer.mask = starLayer
        firstView.layer.backgroundColor = UIColor.white.cgColor
        
        secondView.layer.mask = starEdgeLayer
        secondView.layer.backgroundColor = UIColor.systemGray.cgColor
        
        colorLayer.backgroundColor = UIColor.systemGray.cgColor
        firstView.layer.addSublayer(colorLayer)
    }
    
    private func layoutLayer() {
        let size = CGSize(width: bounds.width * fraction, height: bounds.height)
        starLayer.frame = self.bounds
        firstView.frame = self.bounds
        secondView.frame = self.bounds
        starEdgeLayer.frame = self.bounds
        colorLayer.frame = CGRect(origin: .zero, size: size)
    }
}
