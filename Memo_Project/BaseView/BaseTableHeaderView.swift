//
//  BaseTableHeaderView.swift
//  Memo_Project
//
//  Created by 윤여진 on 2022/09/01.
//

import UIKit

class BaseTableHeaderView: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setConstraints()
        
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
       }

    
    func configureUI() { }
    
    func setConstraints() { }
}
