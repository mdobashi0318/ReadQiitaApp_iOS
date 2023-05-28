//
//  ArticleView.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/05/28.
//

import SwiftUI

struct ArticleView: View {
    let article: Article
    var body: some View {
        WebView(loardUrl: URL(string: article.url)!)
            .navigationTitle("記事")
    }
}

//struct ArticleView_Previews: PreviewProvider {
//    static var previews: some View {
//        ArticleView()
//    }
//}
