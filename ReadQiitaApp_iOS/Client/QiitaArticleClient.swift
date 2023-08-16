//
//  QiitaArticleClient.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/08/03.
//

import Foundation
import ComposableArchitecture


struct QiitaArticleClient {
    var fetchList: @Sendable () async throws -> [Article]
    var fetch: @Sendable (String) async throws -> Article
}


extension DependencyValues {
    var qiitaArticleClient: QiitaArticleClient {
        get { self[QiitaArticleClient.self] }
        set { self[QiitaArticleClient.self] = newValue }
    }
}



extension QiitaArticleClient: DependencyKey {
    static let liveValue = Self(fetchList: {
        return try await APIManager.get(request: "items")
    }, fetch: { id in
        return try await APIManager.get(request: "items/\(id)")
    })
}

