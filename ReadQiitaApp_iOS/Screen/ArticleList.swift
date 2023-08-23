//
//  ArticleList.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/04/17.
//

import SwiftUI
import ComposableArchitecture


// MARK: - Reducer

struct ArticleListReducer: Reducer {
    
    struct State: Equatable {
        var list: [Article] = []
        var isLoading = false
        @PresentationState var alert: AlertState<Action.Alert>?
        @PresentationState var bookmarkList: BookmarkListReducer.State?
        @PresentationState var article: ArticleReducer.State?
        var getTime = Date()
        var receiveURL: URL?
    }
    
    
    enum Action: Equatable {
        case getList
        case response(TaskResult<[Article]>)
        case timeCheck
        case alert(PresentationAction<Alert>)
        case bookmarkButtonTapped
        case bookmarkList(PresentationAction<BookmarkListReducer.Action>)
        case refresh
        case cancel
        case receiveArticle(URL)
        case articleResponse(TaskResult<Article>)
        case openArticle(PresentationAction<ArticleReducer.Action>)
        case closeButtonTapped
        case requestArticle
        
        enum Alert: Equatable {
            case retry
            case retryRequestArticle
        }
    }
    
    @Dependency(\.qiitaArticleClient) var articleClient
    @Dependency(\.date) var date
    
    private enum CancelID { case cancel }
    
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .getList:
                state.list = []
                state.isLoading = true
                return .run { send in
                    await send(.response(TaskResult { try await self.articleClient.fetchList() }))
                }
                .cancellable(id: CancelID.cancel)
                
            case let .response(.success(list)):
                state.isLoading = false
                state.list = list
                state.getTime = date.now
                return .none
                
            case .response(.failure):
                state.isLoading = false
                state.alert = .connectError()
                return .none
                
            case .timeCheck:
                return .run { [time = state.getTime, isList = state.list.isEmpty] send in
                    await send(.cancel)
                    
                    if isList || self.date.now.diffFromCurrentDate(time) >= 300 {
                        await send(.getList)
                    }
                }
                
            case .alert(.presented(.retry)):
                return .run { send in
                    await send(.getList)
                }

            case .alert(.presented(.retryRequestArticle)):
                return .run { send in
                    await send(.requestArticle)
                }
                
            case .alert:
                return .none
                
            case .bookmarkButtonTapped:
                state.bookmarkList = BookmarkListReducer.State()
                return .none
                
            case .bookmarkList(.presented(.delegate(.close))):
                return .run { send in
                    await send(.timeCheck)
                }
                
            case .bookmarkList(.presented(.delegate(.openArticle))):
                return .run { send in
                    await send(.requestArticle)
                }
                
            case .bookmarkList:
                return .none
                
            case .refresh:
                return .run { send in
                    await send(.cancel)
                    await send(.getList)
                }
                
            case .cancel:
                return .cancel(id: CancelID.cancel)
                
            case let .receiveArticle(url):
                state.receiveURL = url
                
                if state.bookmarkList != nil {
                    return .run { send in
                        await send(.bookmarkList(.presented(.receiveArticle)))
                    }
                }
                
                if state.article != nil {
                    return .run { send in
                        await send(.openArticle(.presented(.receiveArticle)))
                    }
                }
                
                return .run { send in
                    await send(.requestArticle)
                }
                
            case .openArticle(.presented(.delegate(.openArticle))):
                return .run { send in
                    await send(.requestArticle)
                }
                
            case .openArticle:
                return .none
                
            case let .articleResponse(.success(article)):
                state.article = ArticleReducer.State(id: article.id, title: article.title, url: article.url)
                return .none
                
            case .articleResponse(.failure):
                state.alert = .connectRequestArticleError()
                return .none
                
            case .closeButtonTapped:
                state.article = nil
                return .none
                
            case .requestArticle:
                guard let url = state.receiveURL else { return .none }
                return .run { send in
                    let id = url.absoluteString.replacingOccurrences(of: "readQiitaApp://deeplink?", with: "")
                    await send(.articleResponse( TaskResult { try await articleClient.fetch(id) }))
                }
            }
            
        }
        .ifLet(\.$bookmarkList, action: /Action.bookmarkList) {
            BookmarkListReducer()
        }
        .ifLet(\.$article, action: /Action.openArticle) {
            ArticleReducer()
        }
    }
    
}





// MARK: - View

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
            .fullScreenCover(store: store.scope(state: \.$article,
                                                action: ArticleListReducer.Action.openArticle),
                             content: { store in
                NavigationView {
                    ArticleView.init(store: store)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: {
                                    viewStore.send(.closeButtonTapped)
                                }) {
                                    Image(systemName: "xmark")
                                }
                            }
                        }
                }
            }
            )
            .onOpenURL {
                viewStore.send(.receiveArticle($0))
            }
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
            viewStore.send(.refresh)
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



