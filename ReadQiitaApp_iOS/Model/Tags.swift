//
//  Tags.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/04/19.
//

import Foundation

struct Tags: Codable {
    let name: String
    let versions: [String]
}




extension Tags {
    
    static func names(_ tags: [Tags]) -> String {
        var names: [String] = []
        tags.forEach {
            names.append($0.name)
        }
        return names.joined(separator: ",")
    }
    
}
