//
//  BookmarkList.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/06/25.
//

import SwiftUI

struct BookmarkList: View {
    
    @State var bookmarks = BookmarkModel.findAll()
    
    @Binding var isBookmarkSheet: Bool
    
    var body: some View {
        NavigationView {
            List {
                ForEach(bookmarks) { bookmark in
                    NavigationLink(destination:
                                    ArticleView(store: .init(initialState: ArticleReducer.State(id: bookmark.id,
                                                                                                title: bookmark.title,
                                                                                                url: bookmark.url),
                                                             reducer: {
                        ArticleReducer()
                    }))
                    ) {
                        Text(bookmark.title)
                    }
                }
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
            .task {
                bookmarks = BookmarkModel.findAll()
            }
        }
    }
}


struct BookmarkList_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkList(isBookmarkSheet: .constant(true))
    }
}
