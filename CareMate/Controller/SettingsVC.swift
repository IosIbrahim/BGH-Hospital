//
//  SettingsVC.swift
//  CareMate
//
//  Created by Yo7ia on 12/31/18.
//  Copyright © 2018 khabeer Group. All rights reserved.
//
import SCLAlertView
import UIKit
class SettingsVC: UITableViewController
{
    @IBOutlet weak var loginLbl: UILabel!
    @IBOutlet weak var langLbl: UILabel!
    @IBOutlet weak var aboutLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar.instance.setuptabBar(vc: self)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tabBarController?.tabBar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)


//        self.tabBarController?.title = UserManager.isArabic ? "الإعدادات" : "Settings"
  //  UIView.appearance().semanticContentAttribute = !UserManager.isArabic ? .forceLeftToRight : .forceRightToLeft

        
        let defaults = UserDefaults.standard
        
        if  defaults.bool(forKey: "loginOrNO") ==  true
        {
            self.navigationController?.navigationBar.isHidden = true
            
        }
        else
        {
            self.navigationController?.navigationBar.isHidden = false
        }
        handleLoginState()
    }
    
    func handleLoginState() {
        loginLbl.text =  UserManager.isArabic ? "تسجيل خروج" : "Logout"
        langLbl.text = UserManager.isArabic ? "اللغة" : "Language"
        aboutLbl.text = UserManager.isArabic ? "عن التطبيق" : "About App"
    }
    
    @IBAction func loginClicked()
    {

    }
    
    @IBAction func ipServerClicked()
    {
       
    let alertView = SCLAlertView()
        alertView.addButton("English") {
            alertView.dismissAnimated()
//            UserManager.language = "en"

            Localize.setCurrentLanguage("en")

            
            self.GoToHomeView()
        }
        alertView.addButton("Arabic") {
            alertView.dismissAnimated()
//            UserManager.language = "ar"

//            self.GoToHomeView()
            Localize.setCurrentLanguage("ar")

        }
    alertView.showTitle("Note", subTitle:  "Choose language ", style: .notice, closeButtonTitle: "Dismiss", timeout: nil, colorStyle: 0x3788B0, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: .topToBottom)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return 70
        }
        return 70
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      //  self.dismiss(animated: true, completion: nil)
    }
}
