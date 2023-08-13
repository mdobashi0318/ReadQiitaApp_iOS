//
//  ArticleListReducerTests.swift
//  ReadQiitaApp_iOSTests
//
//  Created by 土橋正晴 on 2023/08/12.
//

import XCTest
import ComposableArchitecture

@testable import ReadQiitaApp_iOS


@MainActor
final class ArticleListReducerTests: XCTestCase {

    func testGetListSuccess() async {
        let date = Date()
        let store = TestStore(initialState: ArticleListReducer.State(),
                              reducer: { ArticleListReducer() },
                              withDependencies: {
            $0.qiitaArticleClient.fetch = { [.mock] }
            $0.date.now = date
        })
        
        await store.send(.getList) {
            $0.isLoading = true
            $0.list = []
        }
        
        await store.receive(.response(.success([.mock]))) {
            $0.isLoading = false
            $0.getTime = date
            $0.list = [.mock]
        }
    }
    
    
    func testGetListFailure() async {
        let store = TestStore(initialState: ArticleListReducer.State(),
                              reducer: { ArticleListReducer() },
                              withDependencies: {
            $0.qiitaArticleClient.fetch = { throw APIError(message: "") }
        })
        
        await store.send(.getList) {
            $0.isLoading = true
            $0.list = []
        }
        
        await store.receive(.response(.failure(APIError(message: "")))) {
            $0.isLoading = false
            $0.alert = .connectError()
        }
    }
    
    
    func testTimeCheckListEmpty() async {
        let date = Date()
        let store = TestStore(initialState: ArticleListReducer.State(),
                              reducer: { ArticleListReducer() },
                              withDependencies: {
            $0.qiitaArticleClient.fetch = { [.mock] }
            $0.date.now = date
        })
 
        await store.send(.timeCheck)
        await store.receive(.cancel)
        await store.receive(.getList) {
            $0.isLoading = true
            $0.list = []
        }
        
        await store.receive(.response(.success([.mock]))) {
            $0.isLoading = false
            $0.getTime = date
            $0.list = [.mock]
        }
    }
    
    
    func testTimeCheck300SecAfter() async {
        let date = Calendar.current.date(byAdding: .second, value: -300, to: Date())!
        let now = Date()
        let store = TestStore(initialState: ArticleListReducer.State(),
                              reducer: { ArticleListReducer() },
                              withDependencies: {
            $0.qiitaArticleClient.fetch = { [.mock] }
            $0.date.now = date
        })
        
        await store.send(.getList) {
                $0.isLoading = true
                $0.list = []
            }
        
        await store.receive(.response(.success([.mock]))) {
            $0.isLoading = false
            $0.getTime = date
            $0.list = [.mock]
        }
        
        store.dependencies.date = DateGenerator({ now })
        
        await store.send(.timeCheck)
        await store.receive(.cancel)
        await store.receive(.getList) {
            $0.isLoading = true
            $0.list = []
        }
        
        await store.receive(.response(.success([.mock]))) {
            $0.isLoading = false
            $0.getTime = now
            $0.list = [.mock]
        }
    }
    
    
    func testTimeCheck() async {
        let date = Calendar.current.date(byAdding: .second, value: -299, to: Date())!
        let now = Date()
        
        let store = TestStore(initialState: ArticleListReducer.State(),
                              reducer: { ArticleListReducer() },
                              withDependencies: {
            $0.qiitaArticleClient.fetch = { [.mock] }
            $0.date.now = date
        })
        
        await store.send(.getList) {
                $0.isLoading = true
                $0.list = []
            }
        
        await store.receive(.response(.success([.mock]))) {
            $0.isLoading = false
            $0.getTime = date
            $0.list = [.mock]
        }
        
        store.dependencies.date = DateGenerator({ now })
        
        await store.send(.timeCheck)
        await store.receive(.cancel)
    }
    
    
    func testBookmarkButtonTapped() async {
        let store = TestStore(initialState: ArticleListReducer.State(),
                              reducer: { ArticleListReducer() },
                              withDependencies: { $0.qiitaArticleClient.fetch = { [] } })
        
        
        await store.send(.bookmarkButtonTapped) {
            $0.bookmarkList = BookmarkListReducer.State()
        }
    }
    
    
    func testDelegateClose() async {
        let date = Date()
        let store = TestStore(initialState: ArticleListReducer.State(),
                              reducer: { ArticleListReducer() },
                              withDependencies: {
            $0.qiitaArticleClient.fetch = { [.mock] }
            $0.date.now = date
        })
        
        
        await store.send(.bookmarkButtonTapped) {
            $0.bookmarkList = BookmarkListReducer.State()
        }
        
        await store.send(.bookmarkList(.presented(.delegate(.close))))
        await store.receive(.timeCheck)
        await store.receive(.cancel)
        await store.receive(.getList) {
            $0.isLoading = true
            $0.list = []
        }
        
        await store.receive(.response(.success([.mock]))) {
            $0.isLoading = false
            $0.getTime = date
            $0.list = [.mock]
        }
    }
    
    
    func testRefresh() async {
        let date = Date()
        let store = TestStore(initialState: ArticleListReducer.State(),
                              reducer: { ArticleListReducer() },
                              withDependencies: {
            $0.qiitaArticleClient.fetch = { [.mock] }
            $0.date.now = date
        })
        
        await store.send(.refresh)
        await store.receive(.cancel)
        await store.receive(.getList) {
            $0.isLoading = true
            $0.list = []
        }
        
        await store.receive(.response(.success([.mock]))) {
            $0.isLoading = false
            $0.getTime = date
            $0.list = [.mock]
        }
    }
}
