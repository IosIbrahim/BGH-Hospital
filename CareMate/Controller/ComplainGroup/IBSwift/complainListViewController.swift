//
//  PatientHistoryViewController.swift
//  CareMate
//
//  Created by MAC on 30/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

class complainListViewController: BaseViewController {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var viewSave: UIView!
    @IBOutlet weak var labelHint: UILabel!
    
    var patientId = ""
    var branchId = ""

    var listOfComplains = [ComplainsDTO]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar.instance.setuptabBar(vc: self)

//        self.navigationController?.navigationBar.isHidden = false
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic  ? "الشكاوى والاقتراحات" :"Complaints & Suggestions", hideBack: false)
        let gestureViewSave = UITapGestureRecognizer(target: self, action:  #selector(self.openSave))
        self.viewSave.addGestureRecognizer(gestureViewSave)
        setup()
        if UserManager.isArabic {
            labelHint.text = "إضافة شكوي/إقتراح"
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listOfComplains.removeAll()
        table.reloadData()
        getdata()
    }

    
    init(patientId: String,branchId:String) {
        super.init(nibName: "complainListViewController", bundle: nil)
        self.patientId = patientId
        self.branchId = branchId
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func openSave(sender : UITapGestureRecognizer) {
        let vc1:SaveCompliansViewController = SaveCompliansViewController(VisitId: "nil")
        self.navigationController?.pushViewController(vc1, animated: true)
    }
  
}




