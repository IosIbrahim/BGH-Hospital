//
//  ExampleNavigationController.swift
//  ESTabBarControllerExample
//
//  Created by lihao on 16/5/16.
//  Copyright © 2017年 Egg Swift. All rights reserved.
//

import UIKit
import TPPDF
class TabBarNavigationController: UITabBarController, UITableViewDelegate, UITabBarControllerDelegate {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        let appearance = UIBarButtonItem.appearance()
        appearance.setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: 0.0, vertical: -60), for: .default)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.GoToMatch(notification:)), name: NSNotification.Name(rawValue: "CartUpdated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.GoToOrders(notification:)), name: NSNotification.Name(rawValue: "GoToOrders"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.GoToMyAppointment(notification:)), name: NSNotification.Name(rawValue: "GoToMyAppointment"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(self.GoToDetailsOrders(notification:)), name: NSNotification.Name(rawValue: "GoToDetailsOrders"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.GoToPreOrders(notification:)), name: NSNotification.Name(rawValue: "GoToPreOrders"), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.GoToHome(notification:)), name: NSNotification.Name(rawValue: "GoToHome"), object: nil)
        initiateTabBar()
            }
  
 
     
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        UIView.appearance().semanticContentAttribute = !UserManager.isArabic ? .forceLeftToRight : .forceRightToLeft

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        if CurrentLoggedUser != nil {
//            UserModel.GetNotificationsCount(vc: self, callback: { (data) in
//                CurrentLoggedUser!.count = data!
//                self.initiateNotIcon(count: data!)
//            })
//        }
        
//        self.navigationController!.navigationBar.isTranslucent = true
//        self.navigationController!.navigationBar.shadowImage = UIImage(named: "")
//        self.navigationController!.navigationBar.setBackgroundImage(UIImage(named: ""), for: .default)
    }
    func initiateTabBar() {
        let tabBarController = self
        
     

//        tabBarController.tabBar.isTranslucent = false
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let v1 = BrnachiesViewController()
//        v1.fromMedicalRecord = true
        v1.vcType = .fromReservation
        
        let v2 :MedicalRecordVC = MedicalRecordVC()
        let v5 = SettingsViewController()

        
        let barselectedGreen = UITabBarItem(title: "", image: UIImage(named: "unselectedSettings"), selectedImage: UIImage(named: "unselectedSettings"))

        let image: UIImage? = UIImage(named:"barselectedGreen")

//
        v1.tabBarItem = barselectedGreen
        v2.tabBarItem = UITabBarItem(title: "", image: image, selectedImage: image)
        v5.tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: UserManager.isArabic ? "" :"", image:#imageLiteral(resourceName: "chatingUnSelected"), selectedImage: #imageLiteral(resourceName: "chatingUnSelected"))
        


        let profiel :PatProfileViewController = PatProfileViewController()
        
        
        profiel.tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: UserManager.isArabic ? "" :"", image:#imageLiteral(resourceName: "ProfileUnselected"), selectedImage: #imageLiteral(resourceName: "ProfileUnselected"))
        tabBarController.viewControllers = [v2, v1, profiel,v5]
        tabBarController.selectedViewController = v2
//        
//        for tabBarItem in tabBar.items! {
//            let newImage = UIImage.resizeImage(image: tabBarItem.image!, targetSize: CGSize(width: 20, height: 20))
//            tabBarItem.image = newImage
//            tabBarItem.selectedImage = newImage
//        }

 
      
        
    }
    
  
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
   print("Item \(item)")
     
//            let image: UIImage? = UIImage(named:"selectedSettings")?.withRenderingMode(.alwaysOriginal)
//
//            tabBar.items?[1].selectedImage = image
//
//
//            let image2: UIImage? = UIImage(named:"profileSelected")?.withRenderingMode(.alwaysOriginal)
//
//            tabBar.items?[2].selectedImage = image2
//
//            let image3: UIImage? = UIImage(named:"chatingUnSelected")?.withRenderingMode(.alwaysOriginal)
//
//
//            tabBar.items?[3].selectedImage = image3
//
//            let image0: UIImage? = UIImage(named:"barselectedGreen")?.withRenderingMode(.alwaysOriginal)
//
//
//            tabBar.items?[0].selectedImage = image0
//
       
        
      
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @objc func GoToMatch(notification:NSNotification){
    }
    @objc func GoToDetailsOrders(notification:NSNotification){
        self.navigationController?.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "OrderDetailsVC"), animated: true)
    }
    @objc func GoToPreOrders(notification:NSNotification){
//        self.navigationController?.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "PreOrderVC"), animated: true)
        self.selectedIndex = 2

    }
    @objc func GoToMyAppointment(notification:NSNotification){
        self.tabBarController?.selectedIndex = 1
        self.navigationController?.popToRootViewController(animated: false)
    self.navigationController?.pushViewController(MyAppoimentViewController(), animated: true)
//        isFromOrder = false
    }
    @objc func GoToOrders(notification:NSNotification){
//        TabBarController!.selectedIndex = 2
 self.navigationController?.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "OrderHistoryVC"), animated: true)
        //        TabBarController!.selectedIndex = !Languages.isArabic() ? 1 : 3
    }
    @objc func GoToHome(notification:NSNotification){
        self.selectedIndex = 1
    }

}


extension UIImage {
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }

}
extension UIColor {
    
    class func fromHex(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return #colorLiteral(red: 0, green: 0.702642262, blue: 0.6274331808, alpha: 1)
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return  .black
    }
//    
//    open class var titleColor: UIColor {
//        return #colorLiteral(red: 0, green: 0.702642262, blue: 0.6274331808, alpha: 1)
//    }
    
    class func fromHex(hex:String, alpha: CGFloat) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}
