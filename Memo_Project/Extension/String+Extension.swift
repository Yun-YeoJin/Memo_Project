//
//  String+Extension.swift
//  Memo_Project
//
//  Created by 윤여진 on 2022/09/01.
//

import Foundation

extension Int {
    
  var thousandDivideString: String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    return numberFormatter.string(from: self as NSNumber) ?? ""
  }
    
}

extension Date {
  var customDateString: String {
    let formatter = DateFormatter()
    if Calendar.current.isDateInToday(self) {
      formatter.dateFormat = "a HH:mm"
    } else if self >= Date(timeIntervalSinceNow: 60 * 60 * 24 * -7) {
      formatter.dateFormat = "EEEE"
    } else {
      formatter.dateFormat = "yyyy. MM. dd. a hh:mm"
    }
    formatter.locale = .init(identifier: "ko_KR")
    return formatter.string(from: self)
  }
}
