//
//  FetchAppInfoResponseDTO+Mapping.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/12.
//

import Foundation

struct FetchAppInfoResponseDTO: Decodable {
    let resultCount: Int
    let results: [ResultDTO]
}

extension FetchAppInfoResponseDTO {
    struct ResultDTO: Decodable {
        let supportedDevices: [String]
        let screenshotUrls: [String]
        let artworkUrl100: String
        let releaseNotes: String
        let primaryGenreName: String
        let releaseDate: String
        let description: String
        let sellerName: String
        let trackName: String
        let currentVersionReleaseDate: String
        let minimumOsVersion: String
        let languageCodesISO2A: [String]
        let fileSizeBytes: String
        let formattedPrice: String
        let contentAdvisoryRating: String
        let averageUserRating: Double
        let trackViewUrl: String
        let version: String
        let userRatingCount: Int
    }
}

extension FetchAppInfoResponseDTO {
    func toDomain() -> AppInfoPage {
        print(self)
        return AppInfoPage(
            count: self.resultCount,
            appInfo: []
        )
    }
}
