//
//  MemoRepository.swift
//  Memo_Project
//
//  Created by 윤여진 on 2022/09/01.
//

import UIKit

import RealmSwift

protocol MemoRepositoryType {
    func pinnedMemo() -> Results<Memo>
    func defaultMemo() -> Results<Memo>
    func deleteMemo(_ item: Memo)
}
    

class MemoRepository: MemoRepositoryType {
    
    
    let localRealm = try! Realm()
        
    
    func pinnedMemo() -> Results<Memo> {
        return localRealm.objects(Memo.self).filter("isPinned == true").sorted(byKeyPath: "date", ascending: false)
    }
    
    func defaultMemo() -> Results<Memo> {
        return localRealm.objects(Memo.self).filter("isPinned == false").sorted(byKeyPath: "date", ascending: false)
    }
    
    func deleteMemo(_ item: Memo) {
        try! self.localRealm.write {
            self.localRealm.delete(item)
        }
    }
    
}

