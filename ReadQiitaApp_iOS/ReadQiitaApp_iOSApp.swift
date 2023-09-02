//
//  ReadQiitaApp_iOSApp.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/04/17.
//

import SwiftUI

@main
struct ReadQiitaApp_iOSApp: App {
    var body: some Scene {
        WindowGroup {
            ArticleList(store: .init(initialState: ArticleListReducer.State(),
                                     reducer: { ArticleListReducer() }
                                    )
            )
        }
    }
}
