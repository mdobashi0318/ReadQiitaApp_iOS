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
                            viewStore.send(.bookmarkButtonTapped)
                        }) {
                            Image(systemName: "bookmark.fill")
                        }
                    }
                }
            }
            .alert(store: self.store.scope(state:
                                            \.$alert, action: { .alert($0) }))
            .fullScreenCover(store: store.scope(state: \.$bookmarkList,
                                                action: ArticleListReducer.Action.bookmarkList),
                             content: BookmarkList.init(store:)
            )
        }
        
        
    }
    
    @MainActor
    private func articleList(_ viewStore: ViewStore<ArticleListReducer.State, ArticleListReducer.Action>) -> some View {
        List {
            ForEach(0..<viewStore.list.count, id: \.self) { row in
                NavigationLink(destination:
                                ArticleView(store: .init(initialState: ArticleReducer.State(id: viewStore.list[row].id,
                                                                                            title: viewStore.list[row].title,
                                                                                            url: viewStore.list[row].url),
                                                         reducer: {
                    ArticleReducer()
                }))
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



