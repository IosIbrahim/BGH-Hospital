//
//  HospitalViewsHomeViewController.swift
//  CareMate
//
//  Created by MAC on 14/09/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

class HospitalViewsHomeViewController: BaseViewController {

    var list = [medicalViewModel]()
    @IBOutlet weak var collection: UICollectionView!
    var f = "جوله إفتراضيه ٣٦٥"
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isHidden = false
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? f : "365 SIH Virtual Tour", hideBack: false)

        setup()
        // Do any additional setup after loading the view.
    }

    
  

}

