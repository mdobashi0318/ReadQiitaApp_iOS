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



extension Article {
    static let mock = Self(
        created_at: "", likes_count: 0, title: "Test Article",
                user: User(description: nil,
                           facebook_id: nil,
                           followees_count: 0,
                           followers_count: 0,
                           github_login_name: nil,
                           id: "",
                           items_count: 0,
                           linkedin_id: nil,
                           location: nil,
                           name: "",
                           organization: nil,
                           permanent_id: 0,
                           profile_image_url: nil,
                           team_only: false,
                           twitter_screen_name: nil,
                           website_url: nil),
                tags: [Tags(name: "", versions: [])],
                url: "",
                id: ""
    )
}
