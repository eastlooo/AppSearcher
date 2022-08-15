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
        let showDetailView: AnyPublisher<DetailViewModel?, Never> // <-> View
        let showAlert: AnyPublisher<String, Never> // <-> View
    }
    
    let dependency: Dependency
    let subViewModels: SubViewModels
    var cancellables = Set<AnyCancellable>()
    let input: Input
    let output: Output
    
    private let guideButtonTapped$ = PassthroughSubject<Void, Never>()
    private let searchedText$ = PassthroughSubject<String, Never>()
    
    private let isSearchingMode$ = CurrentValueSubject<Bool, Never>(false)
    private let showDetailView$ = PassthroughSubject<DetailViewModel?, Never>()
    private let showAlert$ = PassthroughSubject<String, Never>()
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        self.subViewModels = SubViewModels(searchViewModel: SearchViewModel())
        
        // MARK: Streams
        let isSearchingMode = isSearchingMode$.eraseToAnyPublisher()
        let showDetailView = showDetailView$.eraseToAnyPublisher()
        let showAlert = showAlert$.eraseToAnyPublisher()
        
        // MARK: Input & Output
        self.input = Input(
            guideButtonTapped: guideButtonTapped$,
            searchedText: searchedText$
        )
        
        self.output = Output(
            isSearchingMode: isSearchingMode,
            showDetailView: showDetailView,
            showAlert: showAlert
        )
        
        // MARK: Binding
        guideButtonTapped$
            .map { _ in UUID().uuidString }
            .combineLatest(isSearchingMode$)
            .removeDuplicates { $0.0 == $1.0 }
            .map { !$0.1 }
            .eraseToAnyPublisher()
            .assign(to: \.value, on: isSearchingMode$)
            .store(in: &cancellables)
        
        searchedText$
            .map { _ in false }
            .eraseToAnyPublisher()
            .assign(to: \.value, on: isSearchingMode$)
            .store(in: &cancellables)
        
        searchedText$
            .setFailureType(to: Error.self)
            .flatMap(dependency.appInfoRepository.fetchAppInfo)
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else { return }
                print("ERROR: \(error)")
                let errorMessage = "유효하지 않은 APP_ID 입니다."
                self?.showAlert$.send(errorMessage)
            } receiveValue: { [weak self] appInfoPage in
                guard appInfoPage.count > 0 && !appInfoPage.appInfos.isEmpty else {
                    let errorMessage = "유효하지 않은 APP_ID 입니다."
                    self?.showAlert$.send(errorMessage)
                    return
                }
                let appInfo = appInfoPage.appInfos[0]
                let viewModel = DetailViewModel(dependency: .init(appInfo: appInfo))
                self?.showDetailView$.send(viewModel)
            }
            .store(in: &cancellables)
        
        subViewModels.searchViewModel.output.searchedText
            .sink { [weak self] text in
                self?.input.searchedText.send(text)
            }
            .store(in: &cancellables)
    }
}
