//
//  Provider.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/12.
//

import Foundation
import Combine

protocol Provider {
    func request<R: Decodable, E: RequestResponsable>(with endpoint: E, completion: @escaping(Result<R, Error>) -> Void) where E.Response == R
    func request<E: RequestResponsable>(_ endpoint: E, completion: @escaping(Result<Data, Error>) -> Void)
    func request(_ url: URL, completion: @escaping(Result<Data, Error>) -> Void)
}
