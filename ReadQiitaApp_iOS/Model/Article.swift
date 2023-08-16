//
//  Article.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/04/19.
//

import Foundation


struct Article: Codable, Identifiable {
    let created_at: String
    let likes_count: Int
    let title: String
    let user: User
    let tags: [Tags]
    let url: String
    let id: String
    
    
    /// ページあたりに含まれる要素数 (1から100まで)
    static func per_page(_ count: Int) -> String {
        guard 0 ..< 100 ~= count else {
            return ""
        }
        return "?per_page=\(count)"
    }
}


extension Article: Equatable {
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.id == rhs.id
    }
}



extension Article {
    static let mock = Self(
        created_at: "2023-01-01T00:00:00+09:00", likes_count: 0, title: "Test Article",
        user: User(description: nil,
                   facebook_id: nil,
                   followees_count: 0,
                   followers_count: 0,
                   github_login_name: nil,
                   id: "User Name",
                   items_count: 0,
                   linkedin_id: nil,
                   location: nil,
                   name: "",
                   organization: "organization",
                   permanent_id: 0,
                   profile_image_url: nil,
                   team_only: false,
                   twitter_screen_name: nil,
                   website_url: nil),
        tags: [Tags(name: "", versions: [])],
        url: "https://www.apple.com/jp/",
        id: "1"
    )
    
    
    static let mockArray = [
        Self(
            created_at: "2023-01-02T00:00:00+09:00", likes_count: 10, title: "Test Article1",
            user: User(description: nil,
                       facebook_id: nil,
                       followees_count: 0,
                       followers_count: 0,
                       github_login_name: nil,
                       id: "User1",
                       items_count: 0,
                       linkedin_id: nil,
                       location: nil,
                       name: "",
                       organization: "organization",
                       permanent_id: 0,
                       profile_image_url: nil,
                       team_only: false,
                       twitter_screen_name: nil,
                       website_url: nil),
            tags: [Tags(name: "", versions: [])],
            url: "https://www.apple.com/jp/",
            id: "baf5c130c67d6b3c9fef"
        ),
        Self(
            created_at: "2023-01-03T00:00:00+09:00", likes_count: 100, title: "Test Article2",
            user: User(description: nil,
                       facebook_id: nil,
                       followees_count: 0,
                       followers_count: 0,
                       github_login_name: nil,
                       id: "User2",
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
            url: "https://www.apple.com/jp/iphone/",
            id: "89a13293e53221cb62d4"
        ),
        Self(
            created_at: "", likes_count: 0, title: "Test Article3",
            user: User(description: nil,
                       facebook_id: nil,
                       followees_count: 0,
                       followers_count: 0,
                       github_login_name: nil,
                       id: "User3",
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
            url: "https://www.apple.com/jp/ipad/",
            id: "7bf689dacfa05cb9971d"
        ),
    ]
}
