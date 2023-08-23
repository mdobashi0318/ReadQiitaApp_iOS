//
//  BookmarkListReducerTests.swift
//  ReadQiitaApp_iOSTests
//
//  Created by 土橋正晴 on 2023/08/13.
//

import XCTest
import ComposableArchitecture

@testable import ReadQiitaApp_iOS

@MainActor
final class BookmarkListReducerTests: XCTestCase {

    
    func testGetAll() async {
        let store = TestStore(initialState: BookmarkListReducer.State(),
                              reducer: { BookmarkListReducer() },
                              withDependencies: {
            $0.qiitaArticleClient.fetch = { [] }
            $0.bookmarkClient.getAll = { [.mock] }
        })
                
        await store.send(.getAll)
        await store.receive(.getResponce(.success([.mock]))) {
            $0.bookmarks = [.mock]
        }
    }
    
    
    func testGetAllFailure() async {
        let store = TestStore(initialState: BookmarkListReducer.State(),
                              reducer: { BookmarkListReducer() },
                              withDependencies: {
            $0.qiitaArticleClient.fetch = { [] }
            $0.bookmarkClient.getAll = { throw BookmarkError(message: "") }
        })
        await store.send(.getAll)
        await store.receive(.getResponce(.failure(BookmarkError(message: ""))))
    }
    
    
    func testCloseButtonTapped() async {
        let dismissed = self.expectation(description: "dismissed")
        let store = TestStore(initialState: BookmarkListReducer.State(),
                              reducer: { BookmarkListReducer() },
                              withDependencies: {
            $0.qiitaArticleClient.fetch = { [] }
            $0.bookmarkClient.getAll = { [.mock] }
            $0.dismiss = DismissEffect { dismissed.fulfill() }
        })
        await store.send(.closeButtonTapped)
        await store.receive(.delegate(.close))
        await self.fulfillment(of: [dismissed])
    }


}
