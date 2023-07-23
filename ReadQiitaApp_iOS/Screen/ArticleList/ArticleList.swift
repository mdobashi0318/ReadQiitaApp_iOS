//
//  ArticleList.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/04/17.
//

import SwiftUI
import ComposableArchitecture

struct ArticleList: View {
    
    var store: StoreOf<ArticleListReducer>
    
    @State var isBookmarkSheet = false
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                ZStack {
                    articleList(viewStore)
                    if viewStore.isLoading {
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
                        .onDisappear {
                            viewStore.send(.timeCheck)
                        }
                }
            }
            .alert(self.store.scope(state: \.alert, action: { $0 }), dismiss: .alertDismissed)
        }
        
        
    }
    
    @MainActor
    private func articleList(_ viewStore: ViewStore<ArticleListReducer.State, ArticleListReducer.Action>) -> some View {
        List {
            ForEach(0..<viewStore.list.count, id: \.self) { row in
                NavigationLink(destination:
                                ArticleView(id: viewStore.list[row].id,
                                            title: viewStore.list[row].title,
                                            url: viewStore.list[row].url)
                ) {
                    ArticleRow(article: viewStore.list[row])
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle(Text("ReadQiitaApp"))
        .refreshable {
            viewStore.send(.getList)
        }
        .task {
            viewStore.send(.timeCheck)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleList(store: .init(initialState: ArticleListReducer.State(), reducer: {
            ArticleListReducer()
        }))
    }
}


