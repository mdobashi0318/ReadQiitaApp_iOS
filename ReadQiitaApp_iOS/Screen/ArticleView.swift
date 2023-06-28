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
    
    /// ブックマークに追加・削除したときのアラート表示フラグ
    @State var isAlertFlag = false
    
    @State var alertTitle = "ブックマークに追加しました。"
    
    var body: some View {
        WebView(loardUrl: URL(string: url)!)
            .navigationTitle("記事")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let result = bookmark.first(where: {$0.id == id}) {
                        Button(action: {
                            $bookmark.remove(result)
                            
                            self.alertTitle = "ブックマークから削除しました。"
                            isAlertFlag.toggle()
                        }) {
                            Image(systemName: "trash")
                        }
                    } else {
                        Button(action: {
                            let article = BookmarkModel()
                            article.id = id
                            article.title = title
                            article.url = url
                            $bookmark.append(article)
                            
                            self.alertTitle = "ブックマークに追加しました。"
                            isAlertFlag.toggle()
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .alert(alertTitle, isPresented: $isAlertFlag, actions: {
                Button(role: .none, action: {}, label: { Text("OK") })
            })
    }
}
