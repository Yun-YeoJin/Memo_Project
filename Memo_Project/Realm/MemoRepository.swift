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
    func unPinnedMemos() -> Results<Memo>
    func deleteMemo(_ item: Memo)
}
    

class MemoRepository: MemoRepositoryType {
    
    let config = Realm.Configuration(schemaVersion: 1)

    lazy var localRealm = try! Realm(configuration: config)
    
    func pinnedMemo() -> Results<Memo> {
        return localRealm.objects(Memo.self).filter("isPinned == true").sorted(byKeyPath: "memoDate", ascending: false)
    }
    
    func unPinnedMemos() -> Results<Memo> {
        return localRealm.objects(Memo.self).filter("isPinned == false").sorted(byKeyPath: "memoDate", ascending: false)
    }
    
    func filterMemos(_ filter: NSPredicate) -> Results<Memo> {
        return localRealm.objects(Memo.self).filter(filter).sorted(byKeyPath: "memoDate", ascending: false)
    }
    
    func deleteMemo(_ item: Memo) {
        try! self.localRealm.write {
            self.localRealm.delete(item)
        }
    }
    
    func fetchMemo(_ item: Memo) {
        try! self.localRealm.write {
            self.localRealm.add(item)
        }
    }
    
}

