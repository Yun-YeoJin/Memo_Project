//
//  StartPopupViewController.swift
//  Memo_Project
//
//  Created by 윤여진 on 2022/08/31.
//

import UIKit

class StartPopupViewController: UIViewController {
    
    let mainView = StartPopupView()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        mainView.backgroundView.backgroundColor = Constants.BaseColor.background
        mainView.titleLabel.text =
        """
처음 오셨군요!
환영합니다 :)

당신만의 메모를 작성하고
관리해보세요!
"""
        mainView.okButton.addTarget(self, action: #selector(okButtonClicked), for: .touchUpInside)
    }
    
    @objc func okButtonClicked() {
        self.dismiss(animated: true)
        UserDefaults.standard.set(true, forKey: "SecondRun")
    }
    
    
}
