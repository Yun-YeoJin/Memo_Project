//
//  UIViewController+Extension.swift
//  Memo_Project
//
//  Created by 윤여진 on 2022/08/31.
//

import UIKit

extension UIViewController {
    
  
    func showAlertMessage(_ title: String, _ message: String, _ oktitle: String) { //매개변수 기본값 설정
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: oktitle, style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true)
        
    }
}
