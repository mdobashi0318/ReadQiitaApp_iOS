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
    
    
    static func add(id: String, title: String, url: String) throws {
        guard let realm else {
            return
        }
        
        let model = BookmarkModel()
        model.id = id
        model.title = title
        model.url = url
        
        do {
            try realm.write {
                realm.add(model)
            }
        } catch {
            throw BookmarkError(message: "追加に失敗しました。")
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
        return model
    }()
}
