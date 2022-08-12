//
//  APIEndpoints.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/12.
//

import Foundation

struct APIEndpoints {
    static func fetchAppInfo(with fetchAppInfoRequestDTO: FetchAppInfoRequestDTO) -> Endpoint<FetchAppInfoResponseDTO> {
        return Endpoint(
            baseURL: "http://itunes.apple.com/",
            path: "lookup",
            method: .get,
            queryParameters: fetchAppInfoRequestDTO)
    }
}
