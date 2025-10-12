//
//  UIViewExtensions.swift
//  HIS_Patient
//
//  Created by m3azy on 04/07/2022.
//

import Foundation
import UIKit

extension UIView {
    
    
    func popIn() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 0.2
//        animation.toValue = 1.0
        animation.duration = 0.2
//        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        animation.autoreverses = false
        animation.repeatCount = 1
        self.layer.add(animation, forKey: "pulsing")
    }
    
    func popOut() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = 0.2
        animation.duration = 0.2
//        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = false
        animation.repeatCount = 1
        self.layer.add(animation, forKey: "pulsing")
    }
}
