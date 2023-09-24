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
    
    static let connectRequestArticleError = {
        AlertState {
            TextState("通信に失敗しました")
        } actions: {
            ButtonState(role: .cancel, label: {
                TextState("閉じる")
            })
            ButtonState(role: .none, action: .retryRequestArticle, label: {
                TextState("再接続")
            })
        }
    }
}



extension AlertState where Action == BookmarkListReducer.Action.Alert {

    
    static let confirmArticleOpen = {
        AlertState {
            TextState("今開いている画面を閉じて、別の記事を開きますがよろしいですか？")
        } actions: {
            ButtonState(role: .cancel, label: {
                TextState("いいえ")
            })
            ButtonState(role: .none, action: .opneArticle, label: {
                TextState("はい")
            })
        }
    }
}


extension AlertState where Action == ArticleReducer.Action.Alert {

    static let confirmArticleOpen = {
        AlertState {
            TextState("今開いている画面を閉じて、別の記事を開きますがよろしいですか？")
        } actions: {
            ButtonState(role: .cancel, label: {
                TextState("いいえ")
            })
            ButtonState(role: .none, action: .opneArticle, label: {
                TextState("はい")
            })
        }
    }
    
    
    static let confirmArticleDelete = {
        AlertState {
            TextState("記事が見つかりませんでした。")
        } actions: {
            ButtonState(role: .cancel, label: {
                TextState("いいえ")
            })
            ButtonState(role: .destructive, action: .deleteBookmark, label: {
                TextState("削除")
            })
        } message: {
            TextState("記事が削除された可能性があります。ブックマークを削除しますか?")
        }
    }
}


