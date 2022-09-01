//
//  MemoListView.swift
//  Memo_Project
//
//  Created by 윤여진 on 2022/08/31.
//

import UIKit

import SnapKit
import Then

class MemoListView: BaseView {


    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configureUI() {
        [].forEach {
            self.addSubview($0)
        }
    }

    override func setConstraints() {

    }

}
