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
        let date = Calendar.current.date(byAdding: .second, value: 0, to: Format.dateFormat(addSec: true))!
        let store = TestStore(initialState: ArticleReducer.State(id: "id", title: "title", url: "url"),
                              reducer: { ArticleReducer() },
                              withDependencies: {
            $0.qiitaArticleClient.fetchList = { [.mock] }
            $0.bookmarkClient.addBookmark = { _, _, _ in "" }
            $0.bookmarkClient.fetch = { _ in .mock }
            $0.date.now = date
        })
        
        
        
        await store.send(.addButtonTapped)
        await store.receive(.addBookmarkResponse(.success(""))) {
            $0.alert = .bookmark(isAdd: true)
        }
        await store.receive(.getBookmark)
        await store.receive(.getBookmarkResponse(.success(.mock))) {
            $0.isBookmark = true
        }
        await store.receive(.checkNeedToUpdateBookmark(.mock))
    }
    
    
    func testAddButtonTappedSuccessOneDayLater() async {
        let date = Calendar.current.date(byAdding: .second, value: 60 * 60 * 24 + 1, to: Format.dateFormat(addSec: true))!
        let store = TestStore(initialState: ArticleReducer.State(id: "id", title: "title", url: "url"),
                              reducer: { ArticleReducer() },
                              withDependencies: {
            $0.qiitaArticleClient.fetchList = { [.mock] }
            $0.qiitaArticleClient.fetch = { _ in .mock }
            $0.bookmarkClient.addBookmark = { _, _, _ in "" }
            $0.bookmarkClient.fetch = { _ in .mock }
            $0.date.now = date
        })
        
        
        
        await store.send(.addButtonTapped)
        await store.receive(.addBookmarkResponse(.success(""))) {
            $0.alert = .bookmark(isAdd: true)
        }
        await store.receive(.getBookmark)
        await store.receive(.getBookmarkResponse(.success(.mock))) {
            $0.isBookmark = true
        }
        await store.receive(.checkNeedToUpdateBookmark(.mock))
        await store.receive(.getArticleResponse(.success(.mock)))
        await store.receive(.updateBookmarkResponse(.success("")))
    }
    
    
    
    func testAddButtonTappedFailure() async {
        let store = TestStore(initialState: ArticleReducer.State(id: "id", title: "title", url: "url"),
                              reducer: { ArticleReducer() },
                              withDependencies: {
            $0.qiitaArticleClient.fetchList = { [.mock] }
            $0.bookmarkClient.addBookmark = { _, _, _ in throw BookmarkError(message: "") }
        })
        
        await store.send(.addButtonTapped)
        await store.receive(.addBookmarkResponse(.failure(BookmarkError(message: "")))) {
            $0.alert = .errorAlert(message: "")
        }
    }
    
    
    func testDeleteButtonTappedSuccess() async {
        let date = Calendar.current.date(byAdding: .second, value: 0, to: Format.dateFormat(addSec: true))!
        let store = TestStore(initialState: ArticleReducer.State(id: "id", title: "title", url: "url"),
                              reducer: { ArticleReducer() },
                              withDependencies: {
            $0.qiitaArticleClient.fetchList = { [.mock] }
            $0.bookmarkClient.deleteBookmark = { _ in "" }
            $0.date.now = date
        })
        
        await store.send(.getBookmarkResponse(.success(.mock))) {
            $0.isBookmark = true
        }
        await store.receive(.checkNeedToUpdateBookmark(.mock))
        
        
        await store.send(.deleteButtonTapped)
        await store.receive(.deleteBookmarkResponse(.success(""))) {
            $0.alert = .bookmark(isAdd: false)
        }
        await store.receive(.getBookmark)
        await store.receive(.getBookmarkResponse(.success(nil))) {
            $0.isBookmark = false
        }
    }
    
    
    func testDeleteButtonTappedFailure() async {
        let store = TestStore(initialState: ArticleReducer.State(id: "id", title: "title", url: "url"),
                              reducer: { ArticleReducer() },
                              withDependencies: {
            $0.qiitaArticleClient.fetchList = { [.mock] }
            $0.bookmarkClient.deleteBookmark = { _ in throw BookmarkError(message: "") }
        })
        
        await store.send(.deleteButtonTapped)
        await store.receive(.deleteBookmarkResponse(.failure(BookmarkError(message: "")))) {
            $0.alert = .errorAlert(message: "")
        }
    }
    
    
}
