//
//  LayoutVariable.swift
//  AppSearcher
//
//  Created by 정동천 on 2022/08/13.
//

import UIKit

public var safeAreaTopInset: CGFloat {
    return UIApplication.shared.connectedScenes
        .filter { $0.activationState == .foregroundActive }
        .first(where: { $0 is UIWindowScene })
        .flatMap({ $0 as? UIWindowScene })?.windows
        .first(where: \.isKeyWindow)
        .map { $0.safeAreaInsets.top } ?? 0
}
