//
//  ArticleView.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/05/28.
//

import SwiftUI
import ComposableArchitecture


// MARK: - Reducer

struct ArticleReducer: Reducer {
    struct State: Equatable {
        let id: String
        
        let title: String
        
        let url: String
        
        var isBookmark = false
        
        @PresentationState var alert: AlertState<Action.Alert>?
    }
    
    enum Action: Equatable {
        case addButtonTapped
        case addBookmarkResponse(TaskResult<String>)
        case deleteButtonTapped
        case deleteBookmarkResponse(TaskResult<String>)
        case alert(PresentationAction<Alert>)
        case getBookmark
        case getBookmarkResponse(TaskResult<Bool>)
        case receiveArticle
        case delegate(Delegate)
        
        enum Alert: Equatable {
            case opneArticle
        }
        
        enum Delegate: Equatable {
            case openArticle
        }
        
    }
    
    
    @Dependency(\.bookmarkClient) var bookmarkClient
    @Dependency(\.dismiss) var dismiss
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .addButtonTapped:
            return .run { [id = state.id, title = state.title, url = state.url] send in
                await send(.addBookmarkResponse(TaskResult { try await self.bookmarkClient.addBookmark(id, title, url) } ))
            }
            
        case .deleteButtonTapped:
            return .run { [id = state.id] send in
                await send(.deleteBookmarkResponse( TaskResult { try await self.bookmarkClient.deleteBookmark(id) }))
            }
            
        case .addBookmarkResponse(.success):
            state.alert = .bookmark(isAdd: true)
            return .run { send in
                await send(.getBookmark)
            }
            
        case let .addBookmarkResponse(.failure(error)):
            if let error = error as? BookmarkError {
                state.alert = .errorAlert(message: error.message)
            } else {
                state.alert = .errorAlert(message: "エラーが発生しました。")
            }
            
            return .none
            
        case .alert(.presented(.opneArticle)):
            return .run { send in
                await send(.delegate(.openArticle))
                await self.dismiss()
            }
            
        case .alert(_):
            return .none
            
        case .deleteBookmarkResponse(.success):
            state.alert = .bookmark(isAdd: false)
            return .run { send in
                await send(.getBookmark)
            }
            
        case let .deleteBookmarkResponse(.failure(error)):
            if let error = error as? BookmarkError {
                state.alert = .errorAlert(message: error.message)
            } else {
                state.alert = .errorAlert(message: "エラーが発生しました。")
            }
            return .none
            
        case .getBookmark:
            return .run { [id = state.id] send in
                await send(.getBookmarkResponse(TaskResult { await self.bookmarkClient.isAdded(id) } ))
            }
            
        case let .getBookmarkResponse(.success(isAdded)):
            state.isBookmark = isAdded
            return .none
            
        case .getBookmarkResponse:
            return .none
            
        case .delegate:
            return .none
            
        case .receiveArticle:
            state.alert = .confirmArticleOpen()
            return .none
        }
    }
}


// MARK: - View

struct ArticleView: View {
    
    let store: StoreOf<ArticleReducer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            WebView(loardUrl: URL(string: viewStore.url)!)
                .navigationTitle("記事")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if viewStore.isBookmark {
                            Button(action: {
                                viewStore.send(.deleteButtonTapped)
                            }) {
                                Image(systemName: "trash")
                            }
                        } else {
                            Button(action: {
                                viewStore.send(.addButtonTapped)
                            }) {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
                .alert(store: store.scope(state: \.$alert, action: { .alert($0) }))
                .onAppear {
                    viewStore.send(.getBookmark)
                }
        }
    }
}




// MARK: - extension

extension AlertState where Action == ArticleReducer.Action.Alert {
    static func bookmark(isAdd: Bool) -> Self {
        AlertState {
            TextState(isAdd ? "ブックマークに追加しました。" : "ブックマークに削除しました。")
        } actions: {
            ButtonState {
                TextState("OK")
            }
        }
    }
    
}
