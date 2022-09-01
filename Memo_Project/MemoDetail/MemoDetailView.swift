//
//  MemoDetailView.swift
//  Memo_Project
//
//  Created by 윤여진 on 2022/08/31.
//

import UIKit

import SnapKit
import Then

class MemoDetailView: BaseView {
    
    let textView = UITextView().then {
        $0.font = .systemFont(ofSize: 15)
        $0.textAlignment = .left
        $0.backgroundColor = .black
        $0.textColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [textView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        textView.snp.makeConstraints { make in
            make.leading.top.bottom.trailing.equalTo(0)
        }
    }
    
}
