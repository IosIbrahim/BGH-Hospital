//
//  Utils.swift
//  CareMate
//
//  Created by Khabber on 11/01/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import Foundation
import SCLAlertView

//class setupTabBar:UIViewController
//{
//    
//    static let instance = setupTabBar()
//    var VCVC  = UIViewController()
//
//    func setuptabBar(vc:UIViewController)
//    {
//        VCVC = vc
//        
//        let button = UIButton()
//        //        button.setImage(UIImage(named: "global-2.png"), for: UIControlState.normal)
//
//        button.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        if UserManager.language == "ar"
//        {
//            
//            button.setTitle(" لغه", for: .normal)
//
//            
//        }
//        else
//        {
//            button.setTitle("Language", for: .normal)
//
//        }
//        button.addTarget(vc, action:#selector(language), for: UIControlEvents.touchUpInside)
//        button.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
//        let barButton = UIBarButtonItem(customView: button)
//
//        let buttonNotifcation = UIButton()
//        //        button.setImage(UIImage(named: "global-2.png"), for: UIControlState.normal)
//
//        buttonNotifcation.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        if UserManager.language == "ar"
//        {
//            
//            buttonNotifcation.setTitle("الاشعارات", for: .normal)
//
//            
//        }
//        else
//        {
//            buttonNotifcation.setTitle("Notifcations", for: .normal)
//
//        }
//        buttonNotifcation.addTarget(vc, action:#selector(Notifcation), for: UIControlEvents.touchUpInside)
//        buttonNotifcation.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
//        let barButtonNotifcation = UIBarButtonItem(customView: buttonNotifcation)
//
//        vc.navigationItem.rightBarButtonItems = [barButton ,barButtonNotifcation]
//    }
//    
//   @objc func language()
//    {
//        let alertView = SCLAlertView()
//            alertView.addButton("English") {
//                alertView.dismissAnimated()
//                UserManager.language = "en"
//                self.VCVC.GoToHomeView()
//            }
//            alertView.addButton("Arabic") {
//                alertView.dismissAnimated()
//                UserManager.language = "ar"
//                self.VCVC.GoToHomeView()
//            }
//        alertView.showTitle("Note", subTitle:  "Choose language ", style: .notice, closeButtonTitle: "Dismiss", timeout: nil, colorStyle: 0x3788B0, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: .topToBottom)
//    }
//    
//    @objc func Notifcation()
//     {
//       let vc =  NotifcationsViewController()
//         AppPopUpHandler.instance.openVCPop(vc, height: 600)
//     }
//
//}




