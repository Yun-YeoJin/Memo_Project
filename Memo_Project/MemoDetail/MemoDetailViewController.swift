//
//  MemoDetailViewController.swift
//  Memo_Project
//
//  Created by 윤여진 on 2022/08/31.
//

import UIKit
import RealmSwift

class MemoDetailViewController: BaseViewController {
    
    let mainView = MemoDetailView()
    
    let config = Realm.Configuration(schemaVersion: 1)
    
    lazy var localRealm = try! Realm(configuration: config)
    
    var memo: Memo?
   
    let repository = MemoRepository()
    
    var memoTitle = ""
    var memoContent = ""
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        print("Realm:",localRealm.configuration.fileURL!)
        
    }
    
    //View가 사라질 때 text가 비어있는지, 안비어있는지 확인하고 Action
    override func viewWillDisappear(_ animated: Bool) {
        
        if mainView.textView.text == "" {
            
        } else {
            saveMemo()
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    override func configureUI() {
        navigationController?.navigationBar.tintColor = .orange
        
        let doneButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(doneButtonClicked))
        let sharedButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
        
        navigationItem.rightBarButtonItems = [doneButton, sharedButton]
        
        doneButton.tintColor = .orange
        sharedButton.tintColor = .orange
        
        if memo != nil {
            mainView.textView.text = "\(memo!.memoTitle)\n\(memo!.memoContent)"
            doneButton.title = "완료"
        } else {
            mainView.textView.text = ""
            doneButton.title = "저장"
        }
        
        mainView.textView.becomeFirstResponder()
        
        }
    
    @objc func doneButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func shareButtonClicked() {
        
        if memo == nil {
            
            if mainView.textView.text == "" {
                
                showAlertMessage("빈 메모에요!", "빈 메모는 저장할 수가 없답니다ㅠㅠ", "확인")
                
            } else {
                
                let alert = UIAlertController(title: "저장 및 공유", message: "현재 메모를 저장하고 공유하실래용?", preferredStyle: .alert)
                let ok = UIAlertAction(title: "공유", style: .default){ (_) in
                    self.saveTextFile()
                    self.presentActivityViewController()
                }
                let cancel = UIAlertAction(title: "취소", style: .cancel)
                
                alert.addAction(ok)
                alert.addAction(cancel)
               
                present(alert, animated: true, completion: nil)
            
            }
            
   
        } else {
            saveTextFile()
            presentActivityViewController()
            
        }
        
    }
    
    //MARK: ActivityController 띄우기
  func presentActivityViewController() {
        
        let fileName = (loadFromDocument()! as NSString).appendingPathComponent("SeSACMemo.txt")
        let fileURL = URL(fileURLWithPath: fileName)
        
        let vc = UIActivityViewController(activityItems: [fileURL], applicationActivities: [])
        
        self.present(vc, animated: true, completion: nil)
        
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: TextView 내용 저장하기 (메모 저장하기)
    func saveMemo() {
        
        let splitedTextList = mainView.textView.text.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: false)
        

        if mainView.textView.text.isEmpty {
            navigationController?.popViewController(animated: true)
            return
            
        } else if splitedTextList.count == 1 { // 제목만 있는 경우
            memoTitle = String(splitedTextList[0])
            
        } else { // 내용만 있는 경우 & 내용과 제목이 둘 다 있는 경우
            memoTitle = String(splitedTextList[0])
            memoContent = String(splitedTextList[1])
        }
        
        if memo == nil { // 메모가 비어있으면 새로 작성하기
            let task = Memo(memoTitle: memoTitle, memoContent: memoContent, memoDate: Date())
            repository.fetchMemo(task)
            
        
        } else { // 메모 수정하기
            let task = memo
            
            try! localRealm.write {
                task?.memoTitle = memoTitle
                task?.memoContent = memoContent
            }
        }
        
    }
    
    //MARK: 메모 파일 저장하기
    func saveTextFile() {
        if memo != nil {
            
            let title: String? = memo!.memoTitle
            let content: String? = memo!.memoContent
            let text =  "\(title!)\n\(content!)"
      
            let filename = documentDirectoryPath()!.appendingPathComponent("SeSACMemo.txt")

            do {
                try text.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
            } catch {
                print("ERROR")
            }
        } else {
            let text = mainView.textView.text
            let filename = documentDirectoryPath()!.appendingPathComponent("SeSACMemo.txt")

            do {
                try text!.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
            } catch {
                print("ERROR")
            }
        }
        
    }
    
    
   
}



