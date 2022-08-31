//
//  UIViewController+Extension.swift
//  Memo_Project
//
//  Created by 윤여진 on 2022/08/31.
//

import UIKit

extension UIViewController {
    
  
    func showAlertMessage(title: String, buttonTitle: String = "확인") { //매개변수 기본값 설정
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: buttonTitle, style: .cancel)
        alert.addAction(ok)
        self.present(alert, animated: true)
        
    }
}
