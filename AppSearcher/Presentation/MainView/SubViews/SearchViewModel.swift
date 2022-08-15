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
    
    struct Input {
        let text: CurrentValueSubject<String, Never>
        let searchButtonTapped: PassthroughSubject<Void, Never>
        let deleteButtonTapped: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let searchedText: AnyPublisher<String, Never>
        let hideDeleteButton: AnyPublisher<Bool, Never>
    }
    
    let dependency: Dependency
    var cancellables = Set<AnyCancellable>()
    let input: Input
    let output: Output
    
    private let text$ = CurrentValueSubject<String, Never>("")
    private let searchButtonTapped$ = PassthroughSubject<Void, Never>()
    private let deleteButtonTapped$ = PassthroughSubject<Void, Never>()
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
        
        // MARK: Streams
        let searchedText = searchButtonTapped$
            .map { _ in UUID().uuidString }
            .combineLatest(text$)
            .removeDuplicates { $0.0 == $1.0 }
            .map(\.1)
            .eraseToAnyPublisher()
        let hideDeleteButton = text$
            .map(\.isEmpty)
            .eraseToAnyPublisher()
        
        // MARK: Input & Output
        self.input = Input(
            text: text$,
            searchButtonTapped: searchButtonTapped$,
            deleteButtonTapped: deleteButtonTapped$
        )
        
        self.output = Output(
            searchedText: searchedText,
            hideDeleteButton: hideDeleteButton
        )
        
        // MARK: Binding
        deleteButtonTapped$
            .map { _ in "" }
            .assign(to: \.value, on: text$)
            .store(in: &cancellables)
    }
}
