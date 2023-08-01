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
        var getTime = Date()
    }
    
    
    enum Action: Equatable {
        case getList
        case response([Article])
        case error(String)
        case timeCheck
        case alert(PresentationAction<Alert>)
        
        
        enum Alert: Equatable {
            case retry
        }
    }
    
    private enum CancelID { case cancel }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
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
            .cancellable(id: CancelID.cancel, cancelInFlight: true)
            
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
                
                if isList || dateSubtraction >= 300 {
                    await send(.getList)
                }
            }
        case .alert(.presented(.retry)):
            return .run { send in
                await send(.getList)
            }
        case .alert:
            return .none
        }
    }
    
    
}


