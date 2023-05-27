//
//  ArticleRow.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/05/27.
//

import SwiftUI

struct ArticleRow: View {
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("@\(article.user.id)")
                Text(article.user.organization ?? "")
            }
            
            Text(dateFormatStr())
            Text(article.title)
                .font(.title2)
                .bold()
                
            
            HStack(alignment: .top) {
                Image(systemName: "tag")
                Text(tags())
            }
            HStack {
                Image(systemName: "heart")
                Text("\(article.likes_count)")
                
            }
        }
    }
    
    
    
    private func tags() -> String {
        var tags: [String] = []
        article.tags.forEach {
            tags.append($0.name)
        }
        return tags.joined(separator: ",")
    }
    
    
    private func dateFormatStr() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssX"
        let date = dateFormatter.date(from: article.created_at)
        
        if let date {
            dateFormatter.dateFormat = "yyyy年MM月dd日"
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
}

