//
//  AppInfoRepository.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/13.
//

import Foundation
import Combine

protocol AppInfoRepository {
    func fetchAppInfo(appID: String) -> AnyPublisher<AppInfoPage, Error>
}
