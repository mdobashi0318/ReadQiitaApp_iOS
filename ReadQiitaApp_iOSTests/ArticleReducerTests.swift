//
//  ArticleReducerTests.swift
//  ReadQiitaApp_iOSTests
//
//  Created by 土橋正晴 on 2023/08/13.
//

import XCTest
import ComposableArchitecture

@testable import ReadQiitaApp_iOS

@MainActor
final class ArticleReducerTests: XCTestCase {

    func testAddButtonTappedSuccess() async {
        let store = TestStore(initialState: ArticleReducer.State(id: "id", title: "title", url: "url"),
                              reducer: { ArticleReducer() },
                              withDependencies: {
            $0.qiitaArticleClient.fetch = { [.mock] }
            $0.bookmarkClient.addBookmark = { _, _, _ in "" }
            $0.bookmarkClient.isAdded = { _ in true }
        })
        
        
        
        await store.send(.addButtonTapped)
        await store.receive(.addBookmarkResponse(.success(""))) {
            $0.alert = .bookmark(isAdd: true)
        }
        await store.receive(.getBookmark)
        await store.receive(.getBookmarkResponse(.success(true))) {
            $0.isBookmark = true
        }
    }
    
    
    
    func testAddButtonTappedFailure() async {
        let store = TestStore(initialState: ArticleReducer.State(id: "id", title: "title", url: "url"),
                              reducer: { ArticleReducer() },
                              withDependencies: {
            $0.qiitaArticleClient.fetch = { [.mock] }
            $0.bookmarkClient.addBookmark = { _, _, _ in throw BookmarkError(message: "") }
        })
        
        await store.send(.addButtonTapped)
        await store.receive(.addBookmarkResponse(.failure(BookmarkError(message: "")))) {
            $0.alert = .errorAlert(message: "")
        }
    }
    
    
    func testDeleteButtonTappedSuccess() async {
        let store = TestStore(initialState: ArticleReducer.State(id: "id", title: "title", url: "url"),
                              reducer: { ArticleReducer() },
                              withDependencies: {
            $0.qiitaArticleClient.fetch = { [.mock] }
            $0.bookmarkClient.deleteBookmark = { _ in "" }
            $0.bookmarkClient.isAdded = { _ in true }
        })
        
        await store.send(.getBookmarkResponse(.success(true))) {
            $0.isBookmark = true
        }
        
        store.dependencies.bookmarkClient.isAdded = { _ in false }
        await store.send(.deleteButtonTapped)
        await store.receive(.deleteBookmarkResponse(.success(""))) {
            $0.alert = .bookmark(isAdd: false)
        }
        await store.receive(.getBookmark)
        await store.receive(.getBookmarkResponse(.success(false))) {
            $0.isBookmark = false
        }
    }
    
    
    func testDeleteButtonTappedFailure() async {
        let store = TestStore(initialState: ArticleReducer.State(id: "id", title: "title", url: "url"),
                              reducer: { ArticleReducer() },
                              withDependencies: {
            $0.qiitaArticleClient.fetch = { [.mock] }
            $0.bookmarkClient.deleteBookmark = { _ in throw BookmarkError(message: "") }
        })
        
        await store.send(.deleteButtonTapped)
        await store.receive(.deleteBookmarkResponse(.failure(BookmarkError(message: "")))) {
            $0.alert = .errorAlert(message: "")
        }
    }
    
    
}
