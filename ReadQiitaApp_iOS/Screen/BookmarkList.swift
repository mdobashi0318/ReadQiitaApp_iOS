//
//  BookmarkList.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/06/25.
//

import SwiftUI
import ComposableArchitecture


// MARK: - Reducer

struct BookmarkListReducer: Reducer {
    struct State: Equatable {
        var bookmarks = [BookmarkModel]()
        @PresentationState var alert: AlertState<Action.Alert>?
    }
    
    
    enum Action: Equatable {
        case getAll
        case getResponce(TaskResult<[BookmarkModel]>)
        case closeButtonTapped
        case delegate(Delegate)
        case alert(PresentationAction<Alert>)
        case receiveArticle
        
        enum Delegate: Equatable {
            case close
            case openArticle
        }
        
        enum Alert: Equatable {
            case opneArticle
        }
    }
    
    @Dependency(\.bookmarkClient) var bookmarkClient
    
    @Dependency(\.dismiss) var dismiss
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .getAll:
            return .run { send in
                await send(.getResponce(TaskResult { try await self.bookmarkClient.getAll() }))
            }
            
        case let .getResponce(.success(list)):
            state.bookmarks = list
            return .none
            
        case .getResponce(.failure):
            state.bookmarks = []
            return .none
            
        case .closeButtonTapped:
            return .run { send in
                await send(.delegate(.close))
                await self.dismiss()
            }
            
        case .delegate:
            return .none
            
        case .alert(.presented(.opneArticle)):
            return .run { send in
                await send(.delegate(.openArticle))
                await self.dismiss()
            }
            
        case .alert:
            return .none
            
        case .receiveArticle:
            state.alert = .confirmArticleOpen()
            return .none
            
        }
    }
}



// MARK: - View

struct BookmarkList: View {
    
    let store: StoreOf<BookmarkListReducer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                List {
                    if viewStore.bookmarks.isEmpty {
                        Text("ブックマークがありません")
                    } else {
                        ForEach(viewStore.bookmarks) { bookmark in
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
                }
                .navigationTitle("ブックマーク")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            viewStore.send(.closeButtonTapped)
                        }) {
                            Image(systemName: "xmark")
                        }
                    }
                }
                .task {
                    viewStore.send(.getAll)
                }
                .alert(store: store.scope(state: \.$alert, action: { .alert($0) }))
            }
        }
    }
}


struct BookmarkList_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkList(store: .init(initialState: BookmarkListReducer.State(), reducer: { BookmarkListReducer() })
        )
    }
}
