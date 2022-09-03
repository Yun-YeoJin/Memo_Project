//
//  MemoListViewController.swift
//  Memo_Project
//
//  Created by 윤여진 on 2022/08/31.
//

import UIKit

import SnapKit
import RealmSwift

class MemoListViewController: BaseViewController {
    
    //지연 저장
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(MemoListTableViewCell.self, forCellReuseIdentifier: MemoListTableViewCell.reusableIdentifier)
        view.rowHeight = 100
        view.backgroundColor = .black
        return view
    }()
    
    let config = Realm.Configuration(schemaVersion: 1)
    
    lazy var localRealm = try! Realm(configuration: config)
    
    let repository = MemoRepository()
    
    var tasks: Results<Memo>! {
        didSet {
            tableView.reloadData()
        }
    }
    var pinnedMemos: Results<Memo> {
        repository.pinnedMemo()
    }
    
    var unPinnedMemos: Results<Memo> {
        repository.unPinnedMemos()
    }
    
    var searchedMemos: Results<Memo>! {
        didSet {
            tableView.reloadData()
        }
    }
    
    var memoCount = 0
    
    var searchController = UISearchController(searchResultsController: nil)
    
    let pinnedLabel = "고정된 메모"
    let unPinnedLabel = "메모"
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //사용자가 두 번째 접속한건지 UserDefault로 확인
        if UserDefaults.standard.bool(forKey: "SecondRun") == false {
            
            let vc = StartPopupViewController()
            transition(vc, transitionStyle: .presentNavigation)
            
        }
        
        tasks = localRealm.objects(Memo.self).sorted(byKeyPath: "memoDate")
        
        
        containsTitleOrContent()
        
       
       
        searchController.searchBar.placeholder = "검색"
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.tintColor = .systemOrange
        
        searchController.searchBar.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
      
        self.navigationController?.navigationBar.prefersLargeTitles = true // Large title 사용
        self.navigationItem.hidesSearchBarWhenScrolling = false // Scroll시 Search부분 남겨두기
        
    }
    
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
    //SearchBar가 비어있는지 확인
    func isSearchBarEmpty() -> Bool {
        
        return searchController.searchBar.text?.isEmpty ?? true
        
    }
    
    //SearchBar가 활성화 되어있고, SearchBar가 안비어있다면
    func isFiltering() -> Bool {
        
        return searchController.isActive && !isSearchBarEmpty()
        
    }
    
    func containsTitleOrContent() {
        
        let predicate = NSPredicate(format: "memoTitle CONTAINS[c] %@ OR memoContent CONTAINS[c]  %@",searchController.searchBar.text!,searchController.searchBar.text!)
        print(searchController.searchBar.text!)
        searchedMemos = repository.filterMemos(predicate)

    }
    
    override func configureUI() {
        
        view.addSubview(tableView)
        
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let write = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(writeButtonClicked))
        toolbarItems = [spacer, write]
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.tintColor = .orange
        navigationController?.toolbar.backgroundColor = .black
        
    }
    
    @objc func writeButtonClicked() {
        
        let vc = MemoDetailViewController()
        transition(vc, transitionStyle: .push)
        
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

//MARK: UITableViewDelegate, UITableViewDataSource 설정
extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return searchedMemos.count
            
        } else {
            return section == 0 ? pinnedMemos.count : unPinnedMemos.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.reusableIdentifier, for: indexPath) as? MemoListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel.textColor = .white
        cell.contentsLabel.textColor = .lightGray
        
        let nowDate = Calendar.current.dateComponents([.weekOfYear, .day], from: Date())
        
        if isFiltering() {
            let row = searchedMemos[indexPath.row]
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
            cell.contentsLabel.text = "\(dateString)  \(row.memoContent)"
            cell.titleLabel.highlight(searchText: searchController.searchBar.text!)
            cell.contentsLabel.highlight(searchText: searchController.searchBar.text!)
            
            
            
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
                cell.contentsLabel.text = "\(dateString)  \(row.memoContent)"
                
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
                cell.contentsLabel.text = "\(dateString)  \(row.memoContent)"
            }
        }
        
        return cell
        
    }
    
    //테이블뷰 셀 선택 시 Action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let vc = MemoDetailViewController()
        
        let backBarItem = UIBarButtonItem(title: "검색", style: .plain , target: self, action: nil)
        
        if isFiltering() {
            vc.memo = searchedMemos[indexPath.row]
            
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
    
    //MARK: trailingSwipe시 Task 삭제하기
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
   
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            repository.deleteMemo(tasks[indexPath.row])
        }
        tableView.reloadData()
        
    }
    
    
    //MARK: TableViewHeader 설정
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView{
            //테이블뷰 헤더 UI 설정
            headerView.textLabel?.textColor = .white
            headerView.textLabel?.font = .boldSystemFont(ofSize: 30)
        }
    }
    
    //헤더 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
            //고정된 메모에 대한 Header Height
            if isFiltering() {
                return 70
        
            //고정된 메모가 없다면!?
            } else {
                if pinnedMemos.count == 0 && section == 0 { return 0 }
                return 70
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
            return "\(searchedMemos.count)개 검색됨"
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
