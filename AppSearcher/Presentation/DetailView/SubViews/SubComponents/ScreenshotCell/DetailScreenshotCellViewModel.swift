//
//  DetailScreenshotCellViewModel.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/15.
//

import UIKit
import Combine

final class DetailScreenshotCellViewModel: ViewModelType {
    
    struct Dependency {
        let screenshotURL: URL?
        let imageRepository: ImageRepository
        
        init(screenshotURL: URL?,
             imageRepository: ImageRepository = DefaultImageRepository()) {
            self.screenshotURL = screenshotURL
            self.imageRepository = imageRepository
        }
    }
    
    struct Input {}
    
    struct Output {
        let appImageData: AnyPublisher<Data?, Never> // <-> View
    }
    
    let dependency: Dependency
    var cancellables = Set<AnyCancellable>()
    let input: Input
    let output: Output
    
    private let screenshotURL$: CurrentValueSubject<URL?, Never>
    
    private let appImageData$ = CurrentValueSubject<Data?, Never>(nil)
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let screenshotURL$ = CurrentValueSubject<URL?, Never>(dependency.screenshotURL)
        
        let appImageData = appImageData$.eraseToAnyPublisher()
        
        // MARK: Input & Output
        self.input = Input()
        
        self.output = Output(
            appImageData: appImageData
        )
        
        // MARK: Binding
        self.screenshotURL$ = screenshotURL$
        
        screenshotURL$
            .compactMap { $0 }
            .setFailureType(to: Error.self)
            .flatMap(dependency.imageRepository.fetchImageData)
            .sink { completion in
                guard case let .failure(error) = completion else { return }
                print("ERROR: \(error)")
            } receiveValue: { [weak self] data in
                self?.appImageData$.send(data)
            }
            .store(in: &cancellables)
    }
}
