//
//  DetailViewModel.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/15.
//

import Foundation
import Combine

final class DetailViewModel: ViewModelType {
    
    struct Dependency {
        let appInfo: AppInfo
    }
    
    struct Input {
        let screenshotItemSelected: PassthroughSubject<Int, Never> // <-> View
        let shareURL: PassthroughSubject<URL?, Never> // <-> Main
        let updateCollectionLayout: PassthroughSubject<Void, Never> // <-> Introduce
    }
    
    struct Output {
        let mainDataSource: AnyPublisher<DetailMainCellViewModel?, Never> // <-> View
        let screenshotDataSource: AnyPublisher<[DetailScreenshotCellViewModel], Never> // <-> View
        let introduceDataSource: AnyPublisher<DetailIntroduceCellViewModel?, Never> // <-> View
        let newFeatureDataSource: AnyPublisher<AppInfo.NewFeature, Never> // <-> View
        let additionalDataSource: AnyPublisher<[(String, String?)], Never> // <-> View
        let openShare: AnyPublisher<URL?, Never> // <-> View
        let updateCollectionLayout: AnyPublisher<Void, Never> // <-> View
        let showScreenshotView: AnyPublisher<ScreenshotViewModel, Never> // <-> View
    }
    
    let dependency: Dependency
    var cancellables = Set<AnyCancellable>()
    let input: Input
    let output: Output
    
    private let appInfo$: CurrentValueSubject<AppInfo, Never>
    
    private let screenshotItemSelected$ = PassthroughSubject<Int, Never>()
    private let shareURL$ = PassthroughSubject<URL?, Never>()
    private let updateCollectionLayout$ = PassthroughSubject<Void, Never>()
    
    private let mainDataSource$ = CurrentValueSubject<DetailMainCellViewModel?, Never>(nil)
    private let introduceDataSource$ = CurrentValueSubject<DetailIntroduceCellViewModel?, Never>(nil)
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        // MARK: Streams
        let appInfo$ = CurrentValueSubject<AppInfo, Never>(dependency.appInfo)
        
        let mainDataSource = mainDataSource$.eraseToAnyPublisher()
        let introduceDataSource = introduceDataSource$.eraseToAnyPublisher()
        let newFeatureDataSource = appInfo$
            .map(\.newFeature)
            .eraseToAnyPublisher()
        let screenshotDataSource = appInfo$
            .map(\.screenshotURLs)
            .map { urls -> [DetailScreenshotCellViewModel] in
                return urls.map { url -> DetailScreenshotCellViewModel in
                    let dependency = DetailScreenshotCellViewModel.Dependency(
                        screenshotURL: url)
                    return DetailScreenshotCellViewModel(dependency: dependency)
                }
            }
            .eraseToAnyPublisher()
        let additionalDataSource = appInfo$
            .map(\.additional)
            .map(DetailViewModel.refineAdditionalData)
            .eraseToAnyPublisher()
        let openShare = shareURL$.eraseToAnyPublisher()
        let updateCollectionLayout = updateCollectionLayout$.eraseToAnyPublisher()
        let showScreenshotView = screenshotItemSelected$
            .map { _ in UUID().uuidString }
            .combineLatest(screenshotItemSelected$, appInfo$)
            .removeDuplicates { $0.0 == $1.0 }
            .map { (index: $0.1, urls: $0.2.screenshotURLs) }
            .map { element -> ScreenshotViewModel in
                let dependency = ScreenshotViewModel.Dependency(
                    index: element.index, screenshotURLs: element.urls)
                return ScreenshotViewModel(dependency: dependency)
            }
            .eraseToAnyPublisher()
        
        // MARK: Input & Output
        self.input = Input(
            screenshotItemSelected: screenshotItemSelected$,
            shareURL: shareURL$,
            updateCollectionLayout: updateCollectionLayout$
        )
        
        self.output = Output(
            mainDataSource: mainDataSource,
            screenshotDataSource: screenshotDataSource,
            introduceDataSource: introduceDataSource,
            newFeatureDataSource: newFeatureDataSource,
            additionalDataSource: additionalDataSource,
            openShare: openShare,
            updateCollectionLayout: updateCollectionLayout,
            showScreenshotView: showScreenshotView
        )
        
        // MARK: Binding
        self.appInfo$ = appInfo$
        
        appInfo$
            .map { [weak self] appInfo -> DetailMainCellViewModel? in
                guard let self = self else { return nil }
                let dependency = DetailMainCellViewModel.Dependency(
                    mainInfo: appInfo.main)
                let viewModel = DetailMainCellViewModel(dependency: dependency)
                viewModel.output.shareURL
                    .sink { self.shareURL$.send($0) }
                    .store(in: &viewModel.cancellables)
                return viewModel
            }
            .compactMap { $0 }
            .sink { [weak self] viewModel in
                self?.mainDataSource$.send(viewModel)
            }
            .store(in: &cancellables)
        
        appInfo$
            .map { [weak self] appInfo -> DetailIntroduceCellViewModel? in
                guard let self = self else { return nil }
                let dependency = DetailIntroduceCellViewModel.Dependency(
                    inroduceInfo: appInfo.introduce)
                let viewModel = DetailIntroduceCellViewModel(dependency: dependency)
                viewModel.output.updateCollectionLayout
                    .sink { self.updateCollectionLayout$.send($0) }
                    .store(in: &viewModel.cancellables)
                return viewModel
            }
            .compactMap { $0 }
            .sink { [weak self] viewModel in
                self?.introduceDataSource$.send(viewModel)
            }
            .store(in: &cancellables)
    }
    
    static func refineAdditionalData(_ addtional: AppInfo.Additional) -> [(String, String?)] {
        return [
            ("제공자", Optional(addtional.provider)),
            ("카테고리", Optional(addtional.category)),
            ("언어", Optional(DetailViewModel.refineLanguage(addtional.languages))),
            ("가격", Optional(addtional.price)),
            ("연령 등급", Optional(addtional.ageRating)),
            ("크기", DetailViewModel.refineFilesize(addtional.fileSizeBytes)),
        ]
    }
    
    static func refineLanguage(_ languages: [String]) -> String {
        switch languages.count {
        case 0: return ""
        case 1: return languages[0]
        case 2: return "\(languages[0]) 및 \(languages[1])"
        default: return "\(languages[0]) 외 \(languages.count - 1)개"
        }
    }
    
    static func refineFilesize(_ size: UInt?) -> String? {
        guard var size = size.map(Double.init) else { return nil }
        var count = 0
        while(size >= 1024) {
            size /= 1024
            count += 1
        }
        size = round(size * 10) / 10
        switch count {
        case 0: return "\(size) B"
        case 1: return "\(size) KB"
        case 2: return "\(size) MB"
        case 3: return "\(size) GB"
        case 4: return "\(size) TB"
        default: return "Greatest Size"
        }
    }
}
