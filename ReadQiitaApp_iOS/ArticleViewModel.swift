//
//  ArticleViewModel.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/05/26.
//

import Foundation


class ArticleViewModel: ObservableObject {
    
    @Published var articles: [Article] = []
    
    @Published var isError = false
    
    @Published var isLoading = false
    
    init() {
        Task {
            await getItems()
        }
    }
    
    @MainActor
    func getItems() async {
        isLoading = true
        do {
            articles = try await APIManager.get()
        } catch {
            print("ArticleViewModel.getItems() Error = \(error)")
            isError = true
        }
        isLoading = false
    }
    
}


