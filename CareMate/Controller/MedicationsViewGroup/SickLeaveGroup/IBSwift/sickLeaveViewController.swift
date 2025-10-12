//
//  PatientHistoryViewController.swift
//  CareMate
//
//  Created by MAC on 30/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

class sickLeaveViewController: BaseViewController {

    @IBOutlet weak var table: UITableView!
    
    var patientId = ""
    var branchId = ""
    var ser = ""

    var listOfdiagnosis = [sickLeaveDTO]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isHidden = false

//        setupTabBar.instance.setuptabBar(vc: self)
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "الاجازات المرضية" :  "Sick Leave", hideBack: false)

        setup()
        getdata()
    }

    
    init(patientId: String,branchId:String) {
        super.init(nibName: "sickLeaveViewController", bundle: nil)
        self.patientId = patientId
        self.branchId = branchId
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

  
}


