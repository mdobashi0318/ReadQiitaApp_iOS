//
//  APIManager.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/05/26.
//

import Foundation

struct APIManager {
    
    private static let baseUrl = "https://qiita.com/api/v2/"
    
    static func get() async throws -> [Article] {
        let (data, urlResponse) = try await URLSession.shared.data(for: URLRequest(url: URL(string: baseUrl + "items")!))
        
        guard let urlResponse = urlResponse as? HTTPURLResponse else {
            throw APIError.init(message: "")
        }
        
        guard 200 ..< 300 ~= urlResponse.statusCode else {
            throw APIError.init(message: "")
        }
        
        do {
            return try JSONDecoder().decode([Article].self, from: data)
        } catch {
            throw error
        }
        
        
    }
}


struct APIError: Error {
    var message: String = ""
    
    init(message: String) {
        self.message = message
    }
}
