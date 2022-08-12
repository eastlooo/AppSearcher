//
//  DefaultAppInfoRepository.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/13.
//

import Foundation
import Combine

final class DefaultAppInfoRepository {
    
    private let provider: Provider
    
    init(provider: Provider = DefaultProvider()) {
        self.provider = provider
    }
}

extension DefaultAppInfoRepository: AppInfoRepository {
    func fetchAppInfo(appID: String) -> AnyPublisher<AppInfoPage, Error> {
        let requestDTO = FetchAppInfoRequestDTO(id: appID)
        let endpoint = APIEndpoints.fetchAppInfo(with: requestDTO)
        return provider.request(with: endpoint)
            .map { response -> AppInfoPage in
                return response.toDomain()
            }
            .eraseToAnyPublisher()
    }
}
