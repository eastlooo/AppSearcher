//
//  MainViewModel.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/12.
//

import Foundation
import Combine

final class MainViewModel: ViewModelType {
    
    struct Dependency {
        let appInfoRepository: AppInfoRepository
        
        init(appInfoRepository: AppInfoRepository = DefaultAppInfoRepository()) {
            self.appInfoRepository = appInfoRepository
        }
    }
    
    struct SubViewModels {
        let searchViewModel: SearchViewModel
    }
    
    struct Input {
        let guideButtonTapped: PassthroughSubject<Void, Never> // <-> View
        let searchedText: PassthroughSubject<String, Never> // <-> Child
    }
    
    struct Output {
        let isSearchingMode: AnyPublisher<Bool, Never> // <-> View
//        let showDetailView: AnyPublisher<Void, Never> // <-> View
    }
    
    let dependency: Dependency
    let subViewModels: SubViewModels
    var cancellables = Set<AnyCancellable>()
    let input: Input
    let output: Output
    
    private let isSearchingMode$ = CurrentValueSubject<Bool, Never>(false)
    
    private let guideButtonTapped$ = PassthroughSubject<Void, Never>()
    private let searchedText$ = PassthroughSubject<String, Never>()
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(searchViewModel: SearchViewModel())
        
        // MARK: Streams
        let isSearchingMode = isSearchingMode$.eraseToAnyPublisher()
        
        // MARK: Input & Output
        self.input = Input(
            guideButtonTapped: guideButtonTapped$,
            searchedText: searchedText$
        )
        
        self.output = Output(
            isSearchingMode: isSearchingMode
        )
        
        // MARK: Binding
        guideButtonTapped$
            .combineLatest(isSearchingMode$)
            .map { !$0.1 }
            .eraseToAnyPublisher()
            .assign(to: \.value, on: isSearchingMode$)
            .store(in: &cancellables)
        
        searchedText$
            .setFailureType(to: Error.self)
            .flatMap(dependency.appInfoRepository.fetchAppInfo)
            .sink { completion in
                guard case let .failure(error) = completion else { return }
                print("ERROR: \(error)")
            } receiveValue: { appInfoPage in
                print("DEBUG: appInfoPag \(appInfoPage)")
            }
            .store(in: &cancellables)

        
        subViewModels.searchViewModel.output.searchedText
            .sink { [weak self] text in
                self?.input.searchedText.send(text)
            }
            .store(in: &cancellables)
    }
}
