//
//  BookmarkClient.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/08/04.
//

import Foundation
import ComposableArchitecture



struct BookmarkClient {
    var addBookmark: @Sendable (String, String, String) async throws -> String
    var deleteBookmark: @Sendable (String) async throws -> String
}


extension DependencyValues {
    var bookmarkClient: BookmarkClient {
        get { self[BookmarkClient.self] }
        set { self[BookmarkClient.self] = newValue }
    }
}



extension BookmarkClient: DependencyKey {
    static let liveValue = Self(addBookmark: { id, title, url in
        
        try BookmarkModel.add(id: id,
                          title: title,
                          url: url
        )
        
        return ""
        
    }, deleteBookmark: { id in
        try BookmarkModel.delete(id: id)
        return ""
    })
}
