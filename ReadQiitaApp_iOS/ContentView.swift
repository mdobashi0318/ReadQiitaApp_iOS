//
//  ContentView.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/04/17.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ArticleViewModel()
    
    @State var isBookmarkSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                articleList()
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isBookmarkSheet.toggle()
                    }) {
                        Image(systemName: "bookmark.fill")
                    }
                }
            }
            .fullScreenCover(isPresented: $isBookmarkSheet) {
                BookmarkList(isBookmarkSheet: $isBookmarkSheet)
            }
        }
        
        
    }
    
    
    private func articleList() -> some View {
        List {
            ForEach(0..<viewModel.articles.count, id: \.self) { row in
                NavigationLink(destination:
                                ArticleView(id: viewModel.articles[row].id, title: viewModel.articles[row].title, url: viewModel.articles[row].url)
                ) {
                    ArticleRow(article: viewModel.articles[row])
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle(Text("ReadQiitaApp"))
        .refreshable {
            await viewModel.getItems()
        }
        .task {
            await viewModel.getItems()
        }
        .alert("記事一覧の取得に失敗しました。", isPresented: $viewModel.isError) {
            Button("閉じる"){}
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



