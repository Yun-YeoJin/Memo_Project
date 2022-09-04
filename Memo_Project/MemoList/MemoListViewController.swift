//
//  MemoListViewController.swift
//  Memo_Project
//
//  Created by 윤여진 on 2022/08/31.
//

import UIKit

import SnapKit
import RealmSwift
import SwiftUI

class MemoListViewController: BaseViewController {
    
    //지연 저장
    lazy var tableView: UITableView = {
        let view = UITableView.init(frame: .zero, style: .insetGrouped)
        view.delegate = self
        view.dataSource = self
        view.register(MemoListTableViewCell.self, forCellReuseIdentifier: MemoListTableViewCell.reusableIdentifier)
        view.rowHeight = 70
        view.backgroundColor = .black
        return view
    }()
    
    let config = Realm.Configuration(schemaVersion: 1)
    
    lazy var localRealm = try! Realm(configuration: config)
    
    let repository = MemoRepository()
    
    var memoCount = 0
    
    var tasks: Results<Memo>! {
        didSet {
            tableView.reloadData()
        }
    }
    
    var pinnedMemos: Results<Memo>! {
        repository.pinnedMemo()
    }
    
    var unPinnedMemos: Results<Memo>! {
        repository.unPinnedMemos()
    }

    
    var searchController = UISearchController(searchResultsController: nil)
    
    let pinnedLabel = "고정된 메모"
    let unPinnedLabel = "메모"
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //사용자가 두 번째 접속한건지 UserDefault로 확인
        if UserDefaults.standard.bool(forKey: "SecondRun") == false {
            
            let vc = StartPopupViewController()
            transition(vc, transitionStyle: .presentNavigation)
            
        }
        
        tasks = localRealm.objects(Memo.self)
        
        memoCount = pinnedMemos.count + unPinnedMemos.count
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(for: memoCount)!
        
        containsTitleOrContent()
        
        searchController.searchBar.placeholder = "검색"
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.tintColor = .systemOrange
        
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        
        navigationItem.searchController = searchController
        navigationItem.title = "\(formattedNumber)개의 메모"
        
        self.navigationController?.navigationBar.prefersLargeTitles = true // Large title 사용
        self.navigationItem.hidesSearchBarWhenScrolling = false // Scroll시 Search부분 남겨두기
        
        
        }
    
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memoCount = pinnedMemos.count + unPinnedMemos.count
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(for: memoCount)!
        navigationItem.title = "\(formattedNumber)개의 메모"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        tableView.reloadData()
        
    }
    
    //MARK: SearchBar가 비어있는지 확인
    func isSearchBarEmpty() -> Bool {
        
        return searchController.searchBar.text?.isEmpty ?? true
        
    }
    
    //MARK: SearchBar가 활성화 되어있고, 값이 비어있지 않다면 isFiltering
    func isFiltering() -> Bool {
        
        return searchController.isActive && !isSearchBarEmpty()
        
    }
    
    func containsTitleOrContent() {
        
        let predicate = NSPredicate(format: "memoTitle CONTAINS[c] %@ OR memoContent CONTAINS[c]  %@",searchController.searchBar.text!,searchController.searchBar.text!)
        tasks = repository.filterMemos(predicate)

    }
    //MARK: TableView UI 설정
    override func configureUI() {
        
        view.addSubview(tableView)
        

        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let write = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(writeButtonClicked))
        toolbarItems = [spacer, write]
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.tintColor = .orange
        navigationController?.toolbar.backgroundColor = .black
        
    }
    
    //MARK: 작성버튼 클릭 시
    @objc func writeButtonClicked() {
        
        let vc = MemoDetailViewController()
        transition(vc, transitionStyle: .push)
        
    }
    
    //MARK: 제약조건 설정
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    
}

//MARK: UITableViewDelegate, UITableViewDataSource 설정
extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK: 섹션 갯수 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() { //searchBar 활성시
            return tasks.count
            
        } else { //searchBar 비활성시
            return section == 0 ? pinnedMemos.count : unPinnedMemos.count
        }
        
    }
    
    //MARK: 섹션의 내용 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.reusableIdentifier, for: indexPath) as? MemoListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel.textColor = .white
        cell.registDateLabel.textColor = .lightGray
        
        let nowDate = Calendar.current.dateComponents([.weekOfYear, .day], from: Date())
        
        if isFiltering() {
            let row = tasks[indexPath.row]
            cell.titleLabel.text = row.memoTitle
            
            //MARK: 메모 작성 날짜 하기 (day, weekOfYear, 나머지)
            let date = row.memoDate
            let releasedDate = Calendar.current.dateComponents([.weekOfYear, .day], from: date)
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.locale = Locale(identifier: "ko_kr")
            
            if releasedDate.day == nowDate.day {
                dateFormatter.dateFormat = "a hh:mm"
            } else if releasedDate.weekOfYear == nowDate.weekOfYear {
                dateFormatter.dateFormat = "EEEE"
            } else {
                dateFormatter.dateFormat = "yyyy.MM.dd a hh:mm"
            }
            
            let dateString = dateFormatter.string(from: date)
            cell.registDateLabel.text = "\(dateString)  \(row.memoContent)"
            
            cell.titleLabel.highlight(searchText: searchController.searchBar.text!)
            cell.registDateLabel.highlight(searchText: searchController.searchBar.text!)
            
            
            
        } else {
            if indexPath.section == 0 {
                
                let row = pinnedMemos[indexPath.row]
                cell.titleLabel.text = row.memoTitle
                
                let date = row.memoDate
                let releasedDate = Calendar.current.dateComponents([.weekOfYear, .day], from: date)
                let dateFormatter = DateFormatter()
                
                dateFormatter.locale = Locale(identifier: "ko_kr")
                
                if releasedDate.day == nowDate.day {
                    dateFormatter.dateFormat = "a hh:mm"
                } else if releasedDate.weekOfYear == nowDate.weekOfYear {
                    dateFormatter.dateFormat = "EEEE"
                } else {
                    dateFormatter.dateFormat = "yyyy.MM.dd a hh:mm"
                }
                
                let dateString = dateFormatter.string(from: date)
                cell.registDateLabel.text = "\(dateString)  \(row.memoContent)"
                
            } else if indexPath.section == 1 {
                let row = unPinnedMemos[indexPath.row]
                cell.titleLabel.text = row.memoTitle
                
                let date = row.memoDate
                let releasedDate = Calendar.current.dateComponents([.weekOfYear, .day], from: date)
                
                let dateFormatter = DateFormatter()
                
                dateFormatter.locale = Locale(identifier: "ko_kr")
                
                if releasedDate.day == nowDate.day {
                    dateFormatter.dateFormat = "a hh:mm"
                } else if releasedDate.weekOfYear == nowDate.weekOfYear {
                    dateFormatter.dateFormat = "EEEE"
                } else {
                    dateFormatter.dateFormat = "yyyy.MM.dd a hh:mm"
                }
                
                let dateString = dateFormatter.string(from: date)
                cell.registDateLabel.text = "\(dateString)  \(row.memoContent)"
            }
        }
        
        return cell
        
    }
    
    //MARK: didSelectRowAt 설정, isFiltering 유무에 따른 데이터 전달하기
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let vc = MemoDetailViewController()
        
        let backBarItem = UIBarButtonItem(title: "검색", style: .plain , target: self, action: nil)
        
        if isFiltering() {
            vc.memo = tasks[indexPath.row]
            
        } else {
            if indexPath.section == 0 {
                vc.memo = pinnedMemos[indexPath.row]
            } else {
                vc.memo = unPinnedMemos[indexPath.row]
            }
        }
        self.navigationItem.backBarButtonItem = backBarItem
        
        transition(vc, transitionStyle: .push)
        
    }
    
    //MARK: leadingSwipeActionsConfigurationForRowAt : Pin 고정하기 및 해제하기 (isFiltering & 아닌경우)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if isFiltering() {
            
        if tasks[indexPath.row].isPinned == true { //핀 고정 -> 핀 해제
            
            let unpinAction = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
  
                try! self.localRealm.write {
                    self.tasks[indexPath.row].isPinned = false
                }
                self.tableView.reloadData()
                
            }
            unpinAction.backgroundColor = .systemOrange
            unpinAction.image = UIImage(systemName: "pin.slash.fill")
            
            return UISwipeActionsConfiguration(actions: [unpinAction])
            
            
        } else { //핀 해제 -> 핀 고정
            
            let pinAction = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
             
                if self.pinnedMemos.count < 5 { // 5개 미만일 때
                    try! self.localRealm.write {
                        self.tasks[indexPath.row].isPinned = true
                    }
                    self.tableView.reloadData()
                    
                } else { // 고정된 메모가 5개 이상일 때
                    
                    self.showAlertMessage("고정된 메모가 너무 많아용!!", "메모는 5개까지만 고정이 가능해용!!", "확인!")
                   
                }
            }
            
            pinAction.backgroundColor = .systemOrange
            pinAction.image = UIImage(systemName: "pin.fill")
            
            return UISwipeActionsConfiguration(actions: [pinAction])
            
        }
        
        } else {
                
                if indexPath.section == 0 {
                    let unpinAction = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
          
                        try! self.localRealm.write {
                            self.tasks[indexPath.row].isPinned = false
                        }
                        self.tableView.reloadData()
                        
                    }
                    unpinAction.backgroundColor = .systemOrange
                    unpinAction.image = UIImage(systemName: "pin.slash.fill")
                    
                    return UISwipeActionsConfiguration(actions: [unpinAction])
                    
                } else {
                    let pinAction = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
                     
                        if self.pinnedMemos.count < 5 {
                            try! self.localRealm.write {
                                self.tasks[indexPath.row].isPinned = true
                            }
                            self.tableView.reloadData()
                            
                        } else {
                            
                            self.showAlertMessage("고정된 메모가 너무 많아용!!", "메모는 5개까지만 고정이 가능해용!!", "확인!")
                           
                        }
                    }
                    pinAction.backgroundColor = .systemOrange
                    pinAction.image = UIImage(systemName: "pin.fill")
                    
                    return UISwipeActionsConfiguration(actions: [pinAction])
                }
                
            }
    }
    
    
    //MARK: trailingSwipe시 Task 삭제하기
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if isFiltering() {
        
            let delete = UIContextualAction(style: .destructive, title: "삭제") { action, view, completionHandler in
    
            let alert = UIAlertController(title: "메모 삭제", message: "정말로 삭제하실거에용?", preferredStyle: .alert)
   
            let ok = UIAlertAction(title: "삭제", style: .default) { _ in
                try! self.localRealm.write {
                    self.localRealm.delete(self.tasks[indexPath.row])
                }
                self.tableView.reloadData()
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        delete.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [delete])
    
        } else {
            if indexPath.section == 0 {
                
                let delete = UIContextualAction(style: .destructive, title: "삭제") { action, view, completionHandler in
        
                let alert = UIAlertController(title: "메모 삭제", message: "정말로 삭제하실거에용?", preferredStyle: .alert)
       
                let ok = UIAlertAction(title: "삭제", style: .default) { _ in
                    try! self.localRealm.write {
                        self.localRealm.delete(self.tasks[indexPath.row])
                    }
                    self.tableView.reloadData()
                }
                let cancel = UIAlertAction(title: "취소", style: .cancel)
                alert.addAction(ok)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            }
                
                delete.image = UIImage(systemName: "trash.fill")
                
                return UISwipeActionsConfiguration(actions: [delete])
                
            } else {
                let delete = UIContextualAction(style: .destructive, title: "삭제") { action, view, completionHandler in
        
                let alert = UIAlertController(title: "메모 삭제", message: "정말로 삭제하실거에용?", preferredStyle: .alert)
       
                let ok = UIAlertAction(title: "삭제", style: .default) { _ in
                    try! self.localRealm.write {
                        self.localRealm.delete(self.tasks[indexPath.row])
                    }
                    self.tableView.reloadData()
                }
                let cancel = UIAlertAction(title: "취소", style: .cancel)
                alert.addAction(ok)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            }
                
                delete.image = UIImage(systemName: "trash.fill")
                
                return UISwipeActionsConfiguration(actions: [delete])
            }
        }
    }
    

    //MARK: TableViewHeader UI 설정
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView{
            //테이블뷰 헤더 UI 설정
            headerView.textLabel?.textColor = .white
            headerView.textLabel?.font = .boldSystemFont(ofSize: 30)
        }
    }
    
    //헤더 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
            //SearchBar 활성화 되었을 때
            if isFiltering() {
                return 70
        
            //SearchBar 비활성화일때
            } else {
                if pinnedMemos.count == 0 && section == 0 { return 0 }
                return 50
            }
    }
    
    //섹션 수 설정
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering() {
            return 1
        } else {
            return 2
        }
    }
    
    //section이 0일 때, section이 1일 때 구분
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if isFiltering() {
            return "\(tasks.count)개 찾음"
        } else {
            if section == 0 {
                return pinnedLabel
            } else {
                return unPinnedLabel
            }
        }
    }
}

//MARK: UISearchBarController 설정
extension MemoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
    }
    
}

//MARK: UISearchResultsUpdating 설정
extension MemoListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text else { return }
        containsTitleOrContent()
    }
    
}
