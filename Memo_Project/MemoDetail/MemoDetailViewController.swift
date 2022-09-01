//
//  MemoDetailViewController.swift
//  Memo_Project
//
//  Created by 윤여진 on 2022/08/31.
//

import UIKit

class MemoDetailViewController: BaseViewController {
    
    let mainView = MemoDetailView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    override func configureUI() {
        navigationController?.navigationBar.tintColor = .orange
        
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneButtonClicked))
        let sharedButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(sharedButtonClicked))
        
        navigationItem.rightBarButtonItems = [doneButton, sharedButton]

    }
    
    
    @objc func doneButtonClicked() {
        
    }
    
    @objc func sharedButtonClicked() {
        
    }
    
}
