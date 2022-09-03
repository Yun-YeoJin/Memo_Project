//
//  String+Extension.swift
//  Memo_Project
//
//  Created by 윤여진 on 2022/09/01.
//

import UIKit

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

extension UILabel {
  
    func highlight(searchText: String, color: UIColor = .systemOrange) {
        guard let labelText = self.text else { return }
        do {
            let mutableString = NSMutableAttributedString(string: labelText)
            let regex = try NSRegularExpression(pattern: searchText, options: .caseInsensitive)
            
            for match in regex.matches(in: labelText, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: labelText.utf16.count)) as [NSTextCheckingResult] {
                mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: match.range)

            }
            self.attributedText = mutableString
        } catch {
            print(error)
        }
    }
}
