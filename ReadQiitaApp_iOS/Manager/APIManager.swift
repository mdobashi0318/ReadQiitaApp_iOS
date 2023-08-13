//
//  APIManager.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/05/26.
//

import Foundation

struct APIManager {
    
    private static let baseUrl = "https://qiita.com/api/v2/"
    
    static func get<T: Codable>(request: String) async throws -> T {
        
        guard let url = URL(string: baseUrl + request) else {
            throw APIError.init(message: "url Error")
        }
        
        let (data, urlResponse) = try await URLSession.shared.data(from: url)
        
        guard let urlResponse = urlResponse as? HTTPURLResponse else {
            throw APIError.init(message: "urlResponse Error")
        }
        
        guard 200 ..< 300 ~= urlResponse.statusCode else {
            throw APIError.init(message: "statusCode: \(urlResponse.statusCode)")
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.init(message: error.localizedDescription)
        }
        
        
    }
}


struct APIError: Error, Equatable {
    var message: String = ""
    
    init(message: String) {
        self.message = message
    }
}
