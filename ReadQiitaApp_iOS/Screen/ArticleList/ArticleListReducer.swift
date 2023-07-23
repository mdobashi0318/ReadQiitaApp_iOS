//
//  ArticleListReducer.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/07/22.
//

import Foundation
import ComposableArchitecture

struct ArticleListReducer: ReducerProtocol {
    
    struct State: Equatable {
        var list: [Article] = []
        var isLoading = false
        var alert: AlertState<Action>?
        var getTime = Date()
    }
    
    
    enum Action: Equatable {
        case getList
        case response([Article])
        case error(String)
        case timeCheck
        case alertDismissed
    }
    
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .getList:
            state.isLoading = true
            return .run { send in
                do {
                    let response: [Article] = try await APIManager.get(request: "items")
                    await send(.response(response))
                } catch {
                    let error = error as! APIError
                    await send(.error(error.message))
                }
            }
            
        case let .response(list):
            state.isLoading = false
            state.list = list
            state.getTime = Date()
            return .none
            
        case let .error(error):
            state.isLoading = false
            print(error)
            state.alert = AlertState {
                TextState("通信に失敗しました")
            } actions: {
                ButtonState(role: .cancel, label: {
                    TextState("閉じる")
                })
                ButtonState(role: .none, action: Action.getList, label: {
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
                
                if isList || dateSubtraction >= 300 {
                    await send(.getList)
                }
            }
            
        case .alertDismissed:
            state.alert = nil
            return .none
        }
    }
    
    
}


