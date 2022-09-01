//
//  StartPopupView.swift
//  Memo_Project
//
//  Created by 윤여진 on 2022/08/31.
//

import UIKit

import SnapKit
import Then

class StartPopupView: BaseView {
    
    let titleLabel = UILabel().then {
        $0.font =  .boldSystemFont(ofSize: 20)
        $0.textAlignment = .left
        $0.contentMode = .top
        $0.numberOfLines = 0
        $0.textColor = .white
    }
    
    let backgroundView = UIView().then {
        $0.backgroundColor = .darkGray
        $0.layer.cornerRadius = Constants.Design.cornerRadius
        $0.layer.borderWidth = Constants.Design.borderWidth
        $0.layer.borderColor = Constants.BaseColor.border
    }
    
    let okButton = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("확인", for: .normal)
        $0.layer.cornerRadius = Constants.Design.cornerRadius
        $0.layer.borderWidth = Constants.Design.borderWidth
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [backgroundView, titleLabel, okButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        backgroundView.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(safeAreaLayoutGuide)
            make.width.height.equalTo(277)
        }
        
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.topMargin).offset(8)
            make.leading.equalTo(backgroundView.snp.leadingMargin).offset(8)
            make.height.width.equalTo(200)
        }
        
        okButton.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(0)
            make.width.equalTo(245)
            make.height.equalTo(44)
            
        }
        
    }
    
}
