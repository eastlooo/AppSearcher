//
//  AppInfo.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/12.
//

import Foundation

struct AppInfo {
    let main: Main
    let screenshotURLs: [URL?]
    let introduce: Introduce
    let newFeature: NewFeature
    let additional: Additional
}

extension AppInfo {
    struct Main {
        let appName: String // 앱 이름
        let appImageURL: URL? // 앱 아이콘
        let rating: Double // 평가
        let marketURL: URL? // 앱스토어 이동, 공유
    }
    
    struct Introduce {
        let artistName: String // 제작자
        let description: String // 앱 설명
    }
    
    struct NewFeature {
        let newVersion: String // 앱 버전
        let updatedDate: Date? // 업데이트 날짜
        let releaseNotes: String // 업데이트 내용
    }
    
    struct Additional {
        let provider: String // 제공자
        let category: String // 카테고리
        let languages: [String] // 언어
        let supportedDevices: [String] // 지원기기 목록
        let minimumVersion: String // 앱 최소 버전
        let ageRating: String // 연령 등급
        let fileSizeBytes: Double? // 파일 크기
    }
}

struct AppInfoPage {
    let count: Int
    let appInfos: [AppInfo]
}
