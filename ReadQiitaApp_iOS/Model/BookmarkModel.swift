//
//  BookmarkModel.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/06/24.
//

import Foundation
import Realm
import RealmSwift



class BookmarkModel: Object, Identifiable {
    
    @Persisted(primaryKey: true) var id: String = ""
    
    @Persisted var title: String = ""
    
    @Persisted var url: String = ""
    
    @Persisted var created_at: String
    
    @Persisted var updated_at: String
    
    
    private static var realm: Realm? {
        var configuration: Realm.Configuration
        configuration = Realm.Configuration()
        configuration.schemaVersion = UInt64(1)
        return try? Realm(configuration: configuration)
    }
    
    
    static func findAll() -> [BookmarkModel] {
        guard let realm else {
            return []
        }
        
        var model = [BookmarkModel]()
        realm.objects(BookmarkModel.self).freeze().forEach {
            model.append($0)
        }
        
        return model
    }
    
    
    static func find(_ id: String) -> BookmarkModel? {
        guard let realm,
              let model = realm.object(ofType: BookmarkModel.self, forPrimaryKey: id)?.freeze() else {
            return nil
        }
        return model
    }
    
    
    static func add(id: String, title: String, url: String) throws {
        guard let realm else {
            return
        }
        
        let now = Format.stringFromDate(date: Date(), addSec: true)
        
        let model = BookmarkModel()
        model.id = id
        model.title = title
        model.url = url
        model.created_at = now
        model.updated_at = now
        
        do {
            try realm.write {
                realm.add(model)
            }
        } catch {
            throw BookmarkError(message: "追加に失敗しました。")
        }
    }
    
    static func update(id: String, title: String, url: String) throws {
        guard let realm,
              let model = realm.object(ofType: BookmarkModel.self, forPrimaryKey: id) else {
                  return
              }
        
        do {
            try realm.write {
                model.title = title
                model.url = url
                model.updated_at = Format.stringFromDate(date: Date(), addSec: true)
            }
        } catch {
            throw BookmarkError(message: "更新に失敗しました。")
        }
    }
    
    
    static func isAdded(id: String) -> Bool {
        guard let realm,
              let _ = realm.object(ofType: BookmarkModel.self, forPrimaryKey: id) else {
            return false
        }
        return true
    }
    
    
    static func delete(id: String) throws {
        guard let realm,
              let model = realm.object(ofType: BookmarkModel.self, forPrimaryKey: id) else {
            return
        }
        
        do {
            try realm.write {
                realm.delete(model)
            }
        } catch {
            throw BookmarkError(message: "削除に失敗しました。")
        }
    }
    
}




struct BookmarkError: Error, Equatable {
    let message: String
}


extension BookmarkModel {
    static let mock = {
        let model = BookmarkModel()
        model.id = "id"
        model.title = "title"
        model.url = "url"
        model.created_at = Format.stringFromDate(date: Date(), addSec: true)
        model.updated_at = Format.stringFromDate(date: Date(), addSec: true)
        return model
    }()

}
