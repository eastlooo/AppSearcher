//
//  DefaultImageRepository.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/12.
//

import Foundation
import Combine

final class DefaultImageRepository {
    
    private let provider: Provider
    
    init(provider: Provider = DefaultProvider()) {
        self.provider = provider
    }
}

extension DefaultImageRepository: ImageRepository {
    func fetchImageData(url: URL) -> AnyPublisher<Data, Error> {
        return provider.request(url)
    }
}
