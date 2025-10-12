//
//  DimUtility.swift
//  Le Cadeau
//
//  Created by Mohammad Shaker on 2/17/16.
//  Copyright © 2016 AMIT-Software. All rights reserved.
//

import UIKit

class DimUtility {
    
    fileprivate static var dimView: UIView! = UIView()
    
    class func setDimViewStyles() {
        dimView.frame = CGRect(x: 0, y: 0, width: Constants.ScreenWidth  , height: Constants.ScreenHeight )
        dimView.backgroundColor = #colorLiteral(red: 0.1346794665, green: 0.5977677703, blue: 0.5819112062, alpha: 1)
    }
    
    class func addDimView() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController!.view.addSubview(dimView)
    }
    
    class func removeDimView() {
        dimView.removeFromSuperview()
    }
    
}
