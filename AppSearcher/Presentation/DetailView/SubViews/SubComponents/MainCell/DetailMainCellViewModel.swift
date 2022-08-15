//
//  DetailMainCellViewModel.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/15.
//

import Foundation
import Combine

final class DetailMainCellViewModel: ViewModelType {
    
    struct Dependency {
        let mainInfo: AppInfo.Main
        let imageRepository: ImageRepository
        
        init(mainInfo: AppInfo.Main,
             imageRepository: ImageRepository = DefaultImageRepository()) {
            self.mainInfo = mainInfo
            self.imageRepository = imageRepository
        }
    }
    
    struct Input {
        let appstoreButtonTapped: PassthroughSubject<Void, Never> // <-> View
        let shareButtonTapped: PassthroughSubject<Void, Never> // <-> View
    }
    
    struct Output {
        let appImageData: AnyPublisher<Data?, Never> // <-> View
        let appName: AnyPublisher<String, Never> // <-> View
        let rating: AnyPublisher<Double, Never> // <-> View
        let openAppstore: AnyPublisher<URL?, Never> // <-> View
        let shareURL: AnyPublisher<URL?, Never> // <-> Parent
    }
    
    let dependency: Dependency
    var cancellables = Set<AnyCancellable>()
    let input: Input
    let output: Output
    
    private let mainInfo$: CurrentValueSubject<AppInfo.Main, Never>
    
    private let appstoreButtonTapped$ = PassthroughSubject<Void, Never>()
    private let shareButtonTapped$ = PassthroughSubject<Void, Never>()
    
    private let appImageData$ = CurrentValueSubject<Data?, Never>(nil)
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let mainInfo$ = CurrentValueSubject<AppInfo.Main, Never>(dependency.mainInfo)
        
        let appImageData = appImageData$.eraseToAnyPublisher()
        let appName = mainInfo$
            .map(\.appName)
            .eraseToAnyPublisher()
        let rating = mainInfo$
            .map(\.rating)
            .map { round($0 * 10) / 10 }
            .eraseToAnyPublisher()
        let openAppstore = appstoreButtonTapped$
            .map { _ in UUID().uuidString }
            .combineLatest(mainInfo$)
            .removeDuplicates { $0.0 == $1.0 }
            .map(\.1.marketURL)
            .eraseToAnyPublisher()
        let shareURL = shareButtonTapped$
            .map { _ in UUID().uuidString }
            .combineLatest(mainInfo$)
            .removeDuplicates { $0.0 == $1.0 }
            .map(\.1.marketURL)
            .eraseToAnyPublisher()
        
        // MARK: Input & Output
        self.input = Input(
            appstoreButtonTapped: appstoreButtonTapped$,
            shareButtonTapped: shareButtonTapped$
        )
        
        self.output = Output(
            appImageData: appImageData,
            appName: appName,
            rating: rating,
            openAppstore: openAppstore,
            shareURL: shareURL
        )
        
        // MARK: Binding
        self.mainInfo$ = mainInfo$
        
        mainInfo$
            .compactMap(\.appImageURL)
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
