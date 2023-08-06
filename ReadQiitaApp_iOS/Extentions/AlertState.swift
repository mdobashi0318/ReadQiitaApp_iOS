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
