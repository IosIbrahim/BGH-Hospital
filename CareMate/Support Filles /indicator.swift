//
//  indicator.swift
//  IBuffeh
//
//  Created by Mohamed Elmakkawy on 5/16/17.
//  Copyright © 2017 Mohamed Elmakkawy. All rights reserved.
//

import UIKit
import SVProgressHUD
import GiFHUD_Swift

class indicator {
    
    
    struct Singleton {
        static let instance = indicator()
    }
    
    class var sharedInstance: indicator {
        return Singleton.instance
    }
    
    init() {
//            SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
//            SVProgressHUD.setDefaultMaskType(.clear)
//        SVProgressHUD.setInfoImage(UIImage(named: "background.png")!)
//
//        SVProgressHUD.setImageViewSize(CGSize(width: 50, height: 50))
//        SVProgressHUD.show()


//        SVProgressHUD.setSuccessImage(UIImage(named: "background.png")!)
        SVProgressHUD.setBackgroundColor(UIColor(fromRGBHexString: "3788B0"))
            SVProgressHUD.setForegroundColor(UIColor(fromRGBHexString: "ffffff"))
        
//        Progress = JGProgressHUD(style: JGProgressHUDStyle.dark)
//        Progress?.textLabel.text = "Loading.."
    }
    func show(_ vc:UIViewController? = nil) {
////        Progress?.show(in :vc.view)
//
//
//        DimUtility.addDimView()
////
////        DimUtility.setDimViewStyles()
//
//
//
//        DispatchQueue.main.async {
//
//            let jeremyGif = UIImage.gifImageWithName("Webp.net-gifmaker")
//            let imageView = UIImageView(image:jeremyGif)
//            imageView.frame = CGRect(x: 0, y: 0, width: 1000, height: 2000)
//
//            imageView.backgroundColor = .red
//            vc?.view.addSubview(imageView)
//
////            GIFHUD.shared.setGif(images: [jeremyGif!])
////            GIFHUD.shared.show()
//
////
////                    SVProgressHUD.setBackgroundColor(UIColor(fromRGBHexString: "3788B0"))
////
////
////
////            let jeremyGif = UIImage.gifImageWithName("Webp.net-gifmaker")
////             let imageView = UIImageView(image: jeremyGif)
////            SVProgressHUD.setInfoImage(jeremyGif!)
////
////            SVProgressHUD.setSuccessImage(jeremyGif!)
////            SVProgressHUD.setShouldTintImages(false)
//            SVProgressHUD.show()
//
////
////            GIFHUD.shared.dismiss()
////            SVProgressHUD.setInfoImage(UIImage(named: "cancel.png")!)
////            SVProgressHUD.setImageViewSize(CGSize(width: 1150, height: 1111))
////            SVProgressHUD.show()
//        }
        DispatchQueue.main.async {
            showIndicator()
        }
    }
    
     func dismiss() {
         DispatchQueue.main.async {
             hideIndicator()
         }
//        DispatchQueue.main.async {
//            DimUtility.removeDimView()
//            SVProgressHUD.dismiss()
//            GIFHUD.shared.dismiss()
//
//        }
////        Progress?.dismiss()
    }
    
}
