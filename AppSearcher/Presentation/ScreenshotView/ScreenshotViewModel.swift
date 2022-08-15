//
//  ScreenshotViewModel.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/15.
//

import Foundation
import Combine

final class ScreenshotViewModel: ViewModelType {
    
    struct Dependency {
        let index: Int
        let screenshotURLs: [URL?]
    }
    
    struct Input {}
    
    struct Output {
        let screenshotDataSource: AnyPublisher<[DetailScreenshotCellViewModel], Never> // <-> View
        let index: AnyPublisher<Int, Never> // <-> View
    }
    
    let dependency: Dependency
    var cancellables = Set<AnyCancellable>()
    let input: Input
    let output: Output
    
    private let index$: CurrentValueSubject<Int, Never>
    private let screenshotURLs$: CurrentValueSubject<[URL?], Never>
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let index$ = CurrentValueSubject<Int, Never>(dependency.index)
        let screenshotURLs$ = CurrentValueSubject<[URL?], Never>(dependency.screenshotURLs)

        
        let screenshotDataSource = screenshotURLs$
            .map { urls -> [DetailScreenshotCellViewModel] in
                return urls.map { url -> DetailScreenshotCellViewModel in
                    let dependency = DetailScreenshotCellViewModel.Dependency(
                        screenshotURL: url)
                    return DetailScreenshotCellViewModel(dependency: dependency)
                }
            }
            .eraseToAnyPublisher()
        let index = index$.eraseToAnyPublisher()
        
        // MARK: Input & Output
        self.input = Input()
        
        self.output = Output(
            screenshotDataSource: screenshotDataSource,
            index: index
        )
        
        // MARK: Binding
        self.index$ = index$
        self.screenshotURLs$ = screenshotURLs$
    }
}
