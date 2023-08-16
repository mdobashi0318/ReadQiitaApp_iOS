//
//  ArticleWidgetRow.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/08/15.
//


import SwiftUI

struct ArticleWidgetRow: View {
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("@\(article.user.id)")
                .font(.subheadline)
            Text(article.title)
                .font(.title3)
                .bold()
        }
    }
}

struct ArticleWidgetRow_Previews: PreviewProvider {
    static var previews: some View {
        ArticleWidgetRow(article: .mock)
    }
}
