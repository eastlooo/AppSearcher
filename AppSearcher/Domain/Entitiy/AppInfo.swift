//
//  AppInfo.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/12.
//

import Foundation

struct AppInfo {
    
    struct MainInfo {}
    
    let appName: String
    let appImageURL: URL?
    let storeURL: URL?
    
    let rating: Double
    
    
    /*
     # Main
     1. 앱 이름 -> trackName: String
     2. 앱 아이콘 -> artworkUrl100: String
     3. 앱스토어 이동, 공유하기 -> trackViewUrl: String
     
     4. 평가 -> averageUserRating: Double
     5. 연령 -> contentAdvisoryRating: String
     
     
     */
}

struct AppInfoPage {
    let count: Int
    let appInfo: [AppInfo]
}
