//
//  HelpTextViewController.swift
//  CareMate
//
//  Created by mostafa gabry on 3/24/21.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

class HelpTextViewController: BaseViewController {

    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var byEmail: UILabel!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var diffcultiesLAbel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.diffcultiesLAbel.text = UserManager.isArabic ? "إذا كنت تواجه أي صعوبات أو كنت بحاجة إلى أي مساعدة ، يمكنك الإتصال بمركز الإتصالات على رقم 24997000 للحصول على الدعم أو عن طريق البريد الإلكتروني : \(ConstantsData.email)" : "If you are Facing difficulties or you need any assistance contact the Call Center on"

        self.email.text = UserManager.isArabic ? "البريد الالكتروني" : "ِEmail"
        
        self.byEmail.text = UserManager.isArabic ? "البريد الالكتروني" : "By Email"
        self.tel.text = UserManager.isArabic ? "تليفون" : "Tel"
        // Do any additional setup after loading the view.
//        setupTabBar.instance.setuptabBar(vc: self)

    }


    @IBAction func call(_ sender: Any) {
        
        if let url = NSURL(string: "tel://24997000"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.openURL(url as URL)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
