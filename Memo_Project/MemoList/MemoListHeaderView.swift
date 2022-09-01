//
//  MemoListHeaderView.swift
//  Memo_Project
//
//  Created by 윤여진 on 2022/09/01.
//

import UIKit

import SnapKit
import Then

class MemoListHeaderView: BaseTableHeaderView {
    
    static let identifier = "MemoListHeaderView"
    
    let headerLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 25)
        $0.textAlignment = .left
        $0.numberOfLines = 1
       
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
  
    }
      
    required init?(coder: NSCoder) {
           super.init(coder: coder)
       }
    
    override func configureUI() {
        [headerLabel].forEach {
            self.addSubview($0)
        }
    }
    override func setConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalTo(8)
            make.height.equalTo(44)
        }
    }
    
    
}
