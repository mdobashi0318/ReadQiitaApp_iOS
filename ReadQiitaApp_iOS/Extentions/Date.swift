//
//  Date.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/08/15.
//

import Foundation


extension Date {
    static func dateFormatStr(_ dateStr: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssX"
        let date = dateFormatter.date(from: dateStr)
        
        if let date {
            dateFormatter.dateFormat = "yyyy年MM月dd日"
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
    
    /// 現在日時と比較する
    /// - Parameter date: 比較したい日時
    /// - Returns: 差分を返す
    func diffFromCurrentDate(_ date: Date) -> Int {
        Int(Format.dateFormat(date: self, addSec: true).timeIntervalSince(date))
    }
    
}
