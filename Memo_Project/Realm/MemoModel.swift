//
//  MemoModel.swift
//  Memo_Project
//
//  Created by 윤여진 on 2022/08/31.
//

import Foundation
import RealmSwift

class Memo: Object {
    @Persisted var title: String //제목(필수)
    @Persisted var contents: String //내용(필수)
    @Persisted var date: Date //날짜(필수)
    @Persisted var isPinned: Bool //고정하기
    
    @Persisted(primaryKey: true) var objectID: ObjectId
    
    convenience init(title: String, content: String) {
      self.init()
      self.title = title
      self.contents = content
      self.date = Date()
      self.isPinned = false
    }
}
