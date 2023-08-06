//
//  ArticleView.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/05/28.
//

import SwiftUI
import ComposableArchitecture




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
        
        enum Alert: Equatable {}
    }
    
    
    @Dependency(\.bookmarkClient) var bookmarkClient
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .addButtonTapped:
            return .run { [id = state.id, title = state.title, url = state.url] send in
                await send(.addBookmarkResponse(TaskResult { try await self.bookmarkClient.addBookmark(id, title, url) } ))
                await send(.getBookmark)
            }
            
        case .deleteButtonTapped:
            return .run { [id = state.id] send in
                await send(.deleteBookmarkResponse( TaskResult { try await self.bookmarkClient.deleteBookmark(id) }))
                await send(.getBookmark)
            }
            
        case .addBookmarkResponse(.success):
            state.alert = .bookmark(isAdd: true)
            return .none
        case let .addBookmarkResponse(.failure(error)):
            if let error = error as? BookmarkError {
                state.alert = .errorAlert(message: error.message)
            } else {
                state.alert = .errorAlert(message: "エラーが発生しました。")
            }
            
            return .none
        case .alert(_):
            return .none
        case .deleteBookmarkResponse(.success):
            state.alert = .bookmark(isAdd: false)
            return .none
        case let .deleteBookmarkResponse(.failure(error)):
            if let error = error as? BookmarkError {
                state.alert = .errorAlert(message: error.message)
            } else {
                state.alert = .errorAlert(message: "エラーが発生しました。")
            }
            return .none
        case .getBookmark:
            state.isBookmark = BookmarkModel.isAdded(id: state.id)
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

fileprivate extension AlertState where Action == ArticleReducer.Action.Alert {
    static func bookmark(isAdd: Bool) -> Self {
        AlertState {
            TextState(isAdd ? "ブックマークに追加しました。" : "ブックマークに削除しました。")
        } actions: {
            ButtonState {
                TextState("OK")
            }
        }
    }
    
    
    static func errorAlert(message: String) -> Self {
        AlertState {
            TextState(message)
        } actions: {
            ButtonState {
                TextState("OK")
            }
        }
    }
}
