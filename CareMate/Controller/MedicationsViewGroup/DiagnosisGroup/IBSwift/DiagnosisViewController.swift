//
//  PatientHistoryViewController.swift
//  CareMate
//
//  Created by MAC on 30/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

class DiagnosisViewController: BaseViewController {

    @IBOutlet weak var table: UITableView!
    
    var patientId = ""
    var branchId = ""

    var listOfdiagnosis = [diagnosisModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar.instance.setuptabBar(vc: self)
//        settitle("التشخيصات", "Diagnosis")
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "التشخيص المرضي" : "Diagnosis", hideBack: false)

        setup()
      getdata()
    }

    
    init(patientId: String,branchId:String) {
        super.init(nibName: "DiagnosisViewController", bundle: nil)
        self.patientId = patientId
        self.branchId = branchId
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

  
}

