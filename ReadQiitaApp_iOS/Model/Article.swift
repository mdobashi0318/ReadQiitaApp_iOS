//
//  Article.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/04/19.
//

import Foundation


struct Article: Codable {
    let created_at: String
    let likes_count: Int
    let title: String
    let user: User
    let tags: [Tags]
    let url: String
    let id: String
}


extension Article: Equatable {
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.id == rhs.id
    }
}

