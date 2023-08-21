//
//  Format.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/08/21.
//

import Foundation

/// Dateにフォーマットを設定する
struct Format {
    
    /// フォーマットを返す
    /// - Parameter addSec: 秒数もフォーマットに設定するかの判定
    private static func _dateFormatter(addSec: Bool) -> DateFormatter {
        let formatter: DateFormatter = DateFormatter()
        if addSec {
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        } else {
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
        }
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        return formatter
    }
    
    
    /// Stringのフォーマットを設定Dateを返す
    static func dateFromString(string: String, addSec: Bool = false) -> Date {
        let formatter: DateFormatter = _dateFormatter(addSec: addSec)
        return formatter.date(from: string) ?? Date()
    }
    
    
    /// Dateのフォーマットを設定しStringを返す
    static func stringFromDate(date: Date, addSec: Bool = false) -> String {
        let formatter = _dateFormatter(addSec: addSec)
        let s_Date:String = formatter.string(from: date)
        
        return s_Date
    }
    
    
    /// 現在時間をのフォーマットを設定して返す
    static func dateFormat(date: Date = Date(), addSec: Bool = false) -> Date {
        let formatter = _dateFormatter(addSec: addSec)
        let s_Date:String = formatter.string(from: date)
        
        return formatter.date(from: s_Date) ?? Date()
    }
    
}
