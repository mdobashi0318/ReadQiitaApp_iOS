//
//  QiitaArticleClient.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/08/03.
//

import Foundation
import ComposableArchitecture


struct QiitaArticleClient {
    var fetch: @Sendable () async throws -> [Article]
}


extension DependencyValues {
    var qiitaArticleClient: QiitaArticleClient {
        get { self[QiitaArticleClient.self] }
        set { self[QiitaArticleClient.self] = newValue }
    }
}



extension QiitaArticleClient: DependencyKey {
    static let liveValue = Self(fetch: {
        return try await APIManager.get(request: "items")
    })
}

