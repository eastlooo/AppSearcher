//
//  Provider.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/12.
//

import Foundation
import Combine

protocol Provider {
    func request<R: Decodable, E: RequestResponsable>(with endpoint: E) -> AnyPublisher<R, Error> where E.Response == R
    func request(_ url: URL) -> AnyPublisher<Data, Error>
}
