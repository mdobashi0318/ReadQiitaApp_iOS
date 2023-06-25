//
//  BookmarkList.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/06/25.
//

import SwiftUI
import RealmSwift

struct BookmarkList: View {
    
    @ObservedResults(BookmarkModel.self) var bookmarks
    
    @Binding var isBookmarkSheet: Bool
    
    var body: some View {
        NavigationView {
            List {
                ForEach(bookmarks) { bookmark in
                    NavigationLink(destination:
                                    ArticleView(id: bookmark.id, title: bookmark.title, url: bookmark.url)
                    ) {
                        Text(bookmark.title)
                    }

                }
                .onDelete(perform: $bookmarks.remove)
            }
            .navigationTitle("ブックマーク")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isBookmarkSheet.toggle()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}


struct BookmarkList_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkList(isBookmarkSheet: .constant(true))
    }
}
