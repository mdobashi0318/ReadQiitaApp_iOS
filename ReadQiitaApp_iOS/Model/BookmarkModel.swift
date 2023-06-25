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

}
