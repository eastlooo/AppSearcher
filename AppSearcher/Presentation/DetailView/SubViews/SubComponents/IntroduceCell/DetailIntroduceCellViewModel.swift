//
//  DetailIntroduceCellViewModel.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/15.
//

import UIKit
import Combine

final class DetailIntroduceCellViewModel: ViewModelType {
    
    struct Dependency {
        let inroduceInfo: AppInfo.Introduce
    }
    
    struct Input {
        let foldableButtonTapped: PassthroughSubject<Void, Never> // <-> View
        let updateCollectionLayout: PassthroughSubject<Void, Never> // <-> View
    }
    
    struct Output {
        let isSpreadOut: AnyPublisher<Bool, Never> // <-> View
        let artistName: AnyPublisher<String, Never> // <-> View
        let contents: AnyPublisher<String, Never> // <-> View
        let updateCollectionLayout: AnyPublisher<Void, Never> // <-> Parent
    }
    
    let dependency: Dependency
    var cancellables = Set<AnyCancellable>()
    let input: Input
    let output: Output
    
    private let inroduceInfo$: CurrentValueSubject<AppInfo.Introduce, Never>
    private let isSpreadOut$ = CurrentValueSubject<Bool, Never>(false)
    
    private let foldableButtonTapped$ = PassthroughSubject<Void, Never>()
    private let updateCollectionLayout$ = PassthroughSubject<Void, Never>()
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let inroduceInfo$ = CurrentValueSubject<AppInfo.Introduce, Never>(dependency.inroduceInfo)
        
        let isSpreadOut = isSpreadOut$.eraseToAnyPublisher()
        let artistName = inroduceInfo$
            .map(\.artistName)
            .eraseToAnyPublisher()
        let contents = inroduceInfo$
            .map(\.description)
            .eraseToAnyPublisher()
        let updateCollectionLayout = updateCollectionLayout$.eraseToAnyPublisher()
        
        // MARK: Input & Output
        self.input = Input(
            foldableButtonTapped: foldableButtonTapped$,
            updateCollectionLayout: updateCollectionLayout$
        )
        
        self.output = Output(
            isSpreadOut: isSpreadOut,
            artistName: artistName,
            contents: contents,
            updateCollectionLayout: updateCollectionLayout)
        
        // MARK: Binding
        self.inroduceInfo$ = inroduceInfo$
        
        foldableButtonTapped$
            .map { _ in UUID().uuidString }
            .combineLatest(isSpreadOut$)
            .removeDuplicates { $0.0 == $1.0 }
            .map { !$0.1 }
            .sink { [weak self] isSpreadOut in
                self?.isSpreadOut$.send(isSpreadOut)
            }
            .store(in: &cancellables)
    }
}
