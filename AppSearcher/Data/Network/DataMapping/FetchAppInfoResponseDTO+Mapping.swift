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
        let screenshotUrls: [String]
        let artworkUrl512: String
        let releaseNotes: String
        let primaryGenreName: String
        let releaseDate: String
        let description: String
        let sellerName: String
        let trackName: String
        let currentVersionReleaseDate: String
        let languageCodesISO2A: [String]
        let fileSizeBytes: String
        let formattedPrice: String
        let contentAdvisoryRating: String
        let averageUserRating: Double
        let trackViewUrl: String
        let artistName: String
        let version: String
        let userRatingCount: Int
    }
}

extension FetchAppInfoResponseDTO {
    func toDomain() -> AppInfoPage {
        let appInfos = results.map { result -> AppInfo in
            let appImageURL = URL(string: result.artworkUrl512)
            let marketURL = URL(string: result.trackViewUrl)
            let updatedDate = result.currentVersionReleaseDate.toDate(format: "yyyy-MM-dd'T'HH:mm:ss'Z'")
            
            // 사용중인 언어를 리스트 맨 앞으로 이동 시키기
            var languageCodes = result.languageCodesISO2A
            if let mainLanguageID = Locale.preferredLanguages.first,
               let mainLanguageCode = Locale(identifier: mainLanguageID).languageCode,
               let index = languageCodes.firstIndex(of: mainLanguageCode.uppercased()) {
                let code = languageCodes.remove(at: index)
                languageCodes.insert(code, at: 0)
            }
            
            let koreanLocale = Locale(identifier: "ko_KR")
            let languages = languageCodes
                .compactMap { koreanLocale.localizedString(forLanguageCode: $0) }
            let fileSizeBytes = UInt(result.fileSizeBytes)
            
            let main = AppInfo.Main(
                appName: result.trackName,
                appImageURL: appImageURL,
                rating: result.averageUserRating,
                userRatingCount: result.userRatingCount,
                marketURL: marketURL)
            
            let screenshotUrls = result.screenshotUrls
                .map { URL(string: $0) }
            
            let introduce = AppInfo.Introduce(
                artistName: result.artistName,
                description: result.description)
            
            let newFeature = AppInfo.NewFeature(
                newVersion: result.version,
                updatedDate: updatedDate,
                releaseNotes: result.releaseNotes)
            
            let additional = AppInfo.Additional(
                provider: result.sellerName,
                category: result.primaryGenreName,
                languages: languages,
                price: result.formattedPrice,
                ageRating: result.contentAdvisoryRating,
                fileSizeBytes: fileSizeBytes)
            
            return AppInfo(
                main: main,
                screenshotURLs: screenshotUrls,
                introduce: introduce,
                newFeature: newFeature,
                additional: additional)
        }
        
        return AppInfoPage(
            count: resultCount,
            appInfos: appInfos
        )
    }
}
