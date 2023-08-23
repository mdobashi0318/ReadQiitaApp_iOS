//
//  AlertState.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/08/07.
//

import Foundation
import ComposableArchitecture

extension AlertState {
    
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



extension AlertState where Action == ArticleListReducer.Action.Alert {
    static let connectError = {
        AlertState {
            TextState("通信に失敗しました")
        } actions: {
            ButtonState(role: .cancel, label: {
                TextState("閉じる")
            })
            ButtonState(role: .none, action: .retry, label: {
                TextState("再接続")
            })
        }
    }
}

