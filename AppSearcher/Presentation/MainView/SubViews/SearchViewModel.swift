//
//  SearchViewModel.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/12.
//

import Foundation
import Combine

final class SearchViewModel: ViewModelType {
    
    struct Dependency {}
    
    struct Input {}
    
    struct Output {}
    
    let dependency: Dependency
    var cancellables = Set<AnyCancellable>()
    let input: Input
    let output: Output
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        
        // MARK: Streams
        
        // MARK: Input & Output
        self.input = Input()
        
        self.output = Output()
        
        // MARK: Bindind
    }
}
