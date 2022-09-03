//
//  MemoModel.swift
//  Memo_Project
//
//  Created by 윤여진 on 2022/08/31.
//

import Foundation
import RealmSwift

class Memo: Object {
    @Persisted var memoTitle: String //제목(필수)
    @Persisted var memoContent: String //내용(필수)
    @Persisted var memoDate: Date //날짜(필수)
    @Persisted var isPinned: Bool //고정하기
    
    @Persisted(primaryKey: true) var objectID: ObjectId
    
    convenience init(memoTitle: String, memoContent: String, memoDate: Date) {
      self.init()
        
      self.memoTitle = memoTitle
      self.memoContent = memoContent
      self.memoDate = memoDate
      self.isPinned = false
    }
}
