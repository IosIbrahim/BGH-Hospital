//
//  InOutPopController.swift
//  CareMate
//
//  Created by Ibrahim on 12/04/2025.
//  Copyright © 2025 khabeer Group. All rights reserved.
//

import UIKit
protocol InOutResultProtocol {
    func openInResult(_ model:LabRadDTO?)
    func openOutResult(_ model:LabRadDTO?)
}

class InOutPopController: UIViewController {

    @IBOutlet weak var lblOutside: UILabel!
    @IBOutlet weak var pickerOutside: RoundUIView!
    @IBOutlet weak var lblInternal: UILabel!
    @IBOutlet weak var pickerInternal: RoundUIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    var data: LabRadDTO?
    var delegade: InOutResultProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnClose.setTitle("", for: .normal)
        if UserManager.isArabic {
            lblTitle.text = "يرجى اختيار نوع الخدمة"
            lblInternal.text = "نتائج المختبر الداخلية"
            lblOutside.text = "نتائج المختبر الخارجية"
        }
        
        let tapIn: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(insideClicked))
        let tapOut: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(outsideClicked))
        tapIn.numberOfTapsRequired = 1
        tapOut.numberOfTapsRequired = 1
        pickerInternal.addGestureRecognizer(tapIn)
        pickerOutside.addGestureRecognizer(tapOut)
        pickerOutside.setShadowLight()
        pickerOutside.cornerRadius = 12
        
        pickerInternal.setShadowLight()
        pickerInternal.cornerRadius = 12
        // Do any additional setup after loading the view.
    }

    @IBAction func closeOnTap(_ sender: Any) {
        mz_dismissFormSheetController(animated: true)
    }
    
    @objc func insideClicked() {
        mz_dismissFormSheetController(animated: true) { _ in
            self.delegade?.openInResult(self.data)
        }

    }
    
    @objc func outsideClicked() {
        mz_dismissFormSheetController(animated: true) { _ in
            self.delegade?.openOutResult(self.data)
        }
    }
    
}
