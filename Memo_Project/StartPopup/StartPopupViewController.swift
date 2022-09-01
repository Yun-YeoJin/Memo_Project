//
//  StartPopupViewController.swift
//  Memo_Project
//
//  Created by 윤여진 on 2022/08/31.
//

import UIKit

class StartPopupViewController: BaseViewController {
    
    let mainView = StartPopupView()
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        mainView.titleLabel.text =
        """
처음 오셨군요!
환영합니다 :)

당신만의 메모를 작성하고
관리해보세요!
"""

    }
    
    
}
