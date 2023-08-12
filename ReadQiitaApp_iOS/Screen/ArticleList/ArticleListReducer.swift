//
//  ArticleListReducer.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/07/22.
//

import Foundation
import ComposableArchitecture

struct ArticleListReducer: Reducer {
    
    struct State: Equatable {
        var list: [Article] = []
        var isLoading = false
        @PresentationState var alert: AlertState<Action.Alert>?
        @PresentationState var bookmarkList: BookmarkListReducer.State?
        var getTime = Date()
    }
    
    
    enum Action: Equatable {
        case getList
        case response(TaskResult<[Article]>)
        case timeCheck
        case alert(PresentationAction<Alert>)
        case bookmarkButtonTapped
        case bookmarkList(PresentationAction<BookmarkListReducer.Action>)
        
        
        enum Alert: Equatable {
            case retry
        }
    }
    
    @Dependency(\.qiitaArticleClient) var articleClient
    
    private enum CancelID { case cancel }
    
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .getList:
                state.isLoading = true
                return .run { send in
                    await send(.response(TaskResult { try await self.articleClient.fetch() }))
                }
                .cancellable(id: CancelID.cancel, cancelInFlight: true)
                
            case let .response(.success(list)):
                state.isLoading = false
                state.list = list
                state.getTime = Date()
                return .none
                
            case .response(.failure):
                state.isLoading = false
                state.alert = AlertState {
                    TextState("通信に失敗しました")
                } actions: {
                    ButtonState(role: .cancel, label: {
                        TextState("閉じる")
                    })
                    ButtonState(role: .none, action: .retry, label: {
                        TextState("再接続")
                    })
                }
                return .none
                
            case .timeCheck:
                return .run { [time = state.getTime, isList = state.list.isEmpty] send in
                    let nowTime: Date = Date()
                    let dateFormat = DateFormatter()
                    dateFormat.dateFormat = "HH:mm:ss"
                    let getTimeStr = dateFormat.string(from: time)
                    let nowTimeStr = dateFormat.string(from: nowTime)
                    let _getTime = dateFormat.date(from: getTimeStr) ?? Date()
                    let _nowTime = dateFormat.date(from: nowTimeStr) ?? Date()
                    let dateSubtraction: Int = Int(_nowTime.timeIntervalSince(_getTime))
                    
                    if isList || dateSubtraction >= 10 {
                        await send(.getList)
                    }
                }
                
            case .alert(.presented(.retry)):
                return .run { send in
                    await send(.getList)
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
                
            case .bookmarkList:
                return .none
                
            }
        }
        .ifLet(\.$bookmarkList, action: /Action.bookmarkList) {
            BookmarkListReducer()
        }
           
    }
    
    
}


