//
//  ViewModelType.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/12.
//

import Foundation
import Combine

protocol ViewModelType {
    associatedtype Dependency
    associatedtype Input
    associatedtype Output
    
    var dependency: Dependency { get }
    var cancellables: Set<AnyCancellable> { get set }
    
    var input: Input { get }
    var output: Output { get }
    
    init(dependency: Dependency)
}
