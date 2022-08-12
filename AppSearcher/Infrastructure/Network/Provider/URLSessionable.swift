//
//  URLSessionable.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/12.
//

import Foundation

protocol URLSessionable {
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
    func dataTaskPublisher(for url: URL) -> URLSession.DataTaskPublisher
}

extension URLSession: URLSessionable {}
