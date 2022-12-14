//
//  BaseViewController.swift
//  Memo_Project
//
//  Created by 윤여진 on 2022/08/31.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      
        setBarColor()
        configureUI()
        setConstraints()
        
    }
    
    func configureUI() { }
    
    func setConstraints() { }
    
    func setBarColor() {
        
        let barColor = UINavigationBarAppearance()
        barColor.configureWithOpaqueBackground()
        barColor.backgroundColor = Constants.BaseColor.background
        
        self.navigationItem.standardAppearance = barColor
        self.navigationItem.scrollEdgeAppearance = barColor
    }
    
}
