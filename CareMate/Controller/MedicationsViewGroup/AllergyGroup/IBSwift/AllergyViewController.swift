//
//  PatientHistoryViewController.swift
//  CareMate
//
//  Created by MAC on 30/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

class AllergyViewController: BaseViewController {

    @IBOutlet weak var table: UITableView!
    
    var patientId = ""
    var branchId = ""

    var listOfAllergies = [allergyModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar.instance.setuptabBar(vc: self)

        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic  ? "الحساسيه" : "Allergy", hideBack: false)
        setup()
      getdata()
    }

    
    init(patientId: String,branchId:String) {
        super.init(nibName: "AllergyViewController", bundle: nil)
        self.patientId = patientId
        self.branchId = branchId
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

  
}


