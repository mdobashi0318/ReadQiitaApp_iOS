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
    
    private var getTime: Date = Date()
    
    
    @MainActor
    func getItems() async {
        isLoading = true
        do {
            articles = try await APIManager.get(request: "items")
            getTime = Date()
        } catch {
            print("ArticleViewModel.getItems() Error = \(error)")
            isError = true
        }
        isLoading = false
    }
    
    
    @MainActor
    func getItems_timeCheck() async {
        let nowTime: Date = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "HH:mm:ss"
        let getTimeStr = dateFormat.string(from: getTime)
        let nowTimeStr = dateFormat.string(from: nowTime)
        let _getTime = dateFormat.date(from: getTimeStr) ?? Date()
        let _nowTime = dateFormat.date(from: nowTimeStr) ?? Date()
        let dateSubtraction: Int = Int(_nowTime.timeIntervalSince(_getTime))
        
        if articles.isEmpty || dateSubtraction >= 300 {
            await getItems()
        }
    }
    
}


