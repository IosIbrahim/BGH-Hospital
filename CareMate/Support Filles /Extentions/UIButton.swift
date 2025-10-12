//
//  UIButton.swift
//  CareMate
//
//  Created by Mohammed Sami on 11/24/17.
//  Copyright © 2017 khabeer Group. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
  func underline() {
    guard let text = self.titleLabel?.text else { return }
    
    let attributedString = NSMutableAttributedString(string: text)
    attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: text.count))
    
    self.setAttributedTitle(attributedString, for: .normal)
  }
}
