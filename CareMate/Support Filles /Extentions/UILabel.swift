//
//  UILabel.swift
//  CareMate
//
//  Created by Mohammed Sami on 11/24/17.
//  Copyright © 2017 khabeer Group. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
  func underline() {
    if let textString = self.text {
      let attributedString = NSMutableAttributedString(string: textString)
      attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: attributedString.length - 1))
      attributedText = attributedString
    }
  }
}
