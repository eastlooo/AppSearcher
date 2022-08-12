//
//  MainViewModel.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/12.
//

import Foundation
import Combine

final class MainViewModel: ViewModelType {
    
    struct Dependency {}
    
    struct SubViewModels {
        let searchViewModel: SearchViewModel
    }
    
    struct Input {}
    
    struct Output {}
    
    let dependency: Dependency
    let subViewModels: SubViewModels
    var cancellables = Set<AnyCancellable>()
    let input: Input
    let output: Output
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(searchViewModel: SearchViewModel())
        
        // MARK: Streams
        
        // MARK: Input & Output
        self.input = Input()
        
        self.output = Output()
        
        // MARK: Bindind
    }
}
