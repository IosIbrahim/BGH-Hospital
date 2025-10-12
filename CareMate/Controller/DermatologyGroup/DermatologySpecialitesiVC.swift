//
//  DermatologySpecialitesiVC.swift
//  CareMate
//
//  Created by mostafa gabry on 4/28/21.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

class DermatologySpecialitesiVC: BaseViewController {

    @IBOutlet weak var listOfDermenology: UITableView!
    
    var doctorId = ""
    var specilaityId = ""
    var ClinicID = ""
    var branhcId = ""
    
    
    var indexpathin:Int?
    
    var DoctorObject :Doctor?
    var branchObject :Branch?


    var ServiceBigModelObject :ServiceBigModel?

    var delegate:gotToDoctorProfileFromDermenology?
    override func viewDidLoad() {
        super.viewDidLoad()

//        setupTabBar.instance.setuptabBar(vc: self)
//
//        setupTabBar.instance.setuptabBar(vc: self)

        print("askdbskdnksndasndseviceNAme")
//        if UserManager.isArabic
//        {
//            tabBarItem.title = "تخصصات الجلديه"
//
//        }
//        else
//        {
//            tabBarItem.title =  "DermatologySpecialities"
//
//        }
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "تخصصات الجلديه" : "Dermatology Specialities", hideBack: false)
        
        setupUI()
        // Do any additional setup after loading the view.
    }


  

}
