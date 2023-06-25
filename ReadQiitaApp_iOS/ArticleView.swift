//
//  ArticleView.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/05/28.
//

import SwiftUI
import RealmSwift

struct ArticleView: View {
    
    
    let id: String
    
    let title: String
    
    let url: String
    
    @ObservedResults(BookmarkModel.self) var bookmark
    
    var body: some View {
        WebView(loardUrl: URL(string: url)!)
            .navigationTitle("記事")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let result = bookmark.first(where: {$0.id == id}) {
                        Button(action: {
                            $bookmark.remove(result)
                        }) {
                            Image(systemName: "trash")
                        }
                    } else {
                        Button(action: {
                            let articles = BookmarkModel()
                            articles.id = id
                            articles.title = title
                            articles.url = url
                            $bookmark.append(BookmarkModel(value: articles))
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
    }
}
