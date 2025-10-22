//
//  signUpErroePopUp.swift
//  CareMate
//
//  Created by mostafa gabry on 5/31/21.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit
class signUpErroePopUp: BaseViewController {

    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var lblMobile: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar.instance.setuptabBar(vc: self)
        lblMobile.text = "\(ConstantsData.mobile) - \(ConstantsData.mobile1)"
        btnEmail.setTitle(ConstantsData.email, for: .normal)
        // Do any additional setup after loading the view.
    }

    @IBAction func openWhatsApp(_ sender: Any) {
        let phoneNumber =  ConstantsData.whatsapp// you need to change this number
        let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)")!
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(appURL)
            }
        } else {
            // WhatsApp is not installed
        }
        
    }
  

}
