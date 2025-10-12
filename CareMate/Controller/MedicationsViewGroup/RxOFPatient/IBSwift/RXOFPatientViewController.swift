//
//  RXOFPatientViewController.swift
//  CareMate
//
//  Created by MAC on 28/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

class RXOFPatientViewController: BaseViewController {
    @IBOutlet weak var table: UITableView!

    var listOFRx = [RxModel]()
    var month :Int?
    
    init(month: Int?) {
        super.init(nibName: "RXOFPatientViewController", bundle: nil)
        self.month = month
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar.instance.setuptabBar(vc: self)
//        self.navigationController?.navigationBar.isHidden = false
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "الوصفات الطبية" : "Prescription", hideBack: false)
        
        

     getdata()
        setup()
        // Do any additional setup after loading the view.
    }



}
