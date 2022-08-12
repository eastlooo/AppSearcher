//
//  ImageRepository.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/12.
//

import Foundation
import Combine

protocol ImageRepository {
    func fetchImageData(url: URL) -> AnyPublisher<Data, Error>
}
