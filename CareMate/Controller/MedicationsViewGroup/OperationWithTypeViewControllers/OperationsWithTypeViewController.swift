//
//  OperationsWithTypeViewController.swift
//  CareMate
//
//  Created by Khabber on 23/03/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

class OperationsWithTypeViewController: BaseViewController {

    @IBOutlet weak var uiviewOperation: RoundUIView!
    @IBOutlet weak var uiviewendoscpoies: RoundUIView!
    @IBOutlet weak var uiviewcatheter: RoundUIView!

    @IBOutlet weak var uiImageOperation: UIImageView!
    @IBOutlet weak var uiImageendoscpoies: UIImageView!
    @IBOutlet weak var uiImagecatheter: UIImageView!
    
    @IBOutlet weak var uiLabelOperation: UILabel!
    @IBOutlet weak var uiLabelendoscpoies: UILabel!
    @IBOutlet weak var uiLabelcatheter: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "" : "Operation and  endoscpoies and catheter", hideBack: false)
        
        uiImageOperation.image = UIImage(named: "Operation")
        uiImageendoscpoies.image = UIImage(named: "endoscpoies")
        uiImagecatheter.image = UIImage(named: "catheter")
        
        uiLabelOperation.text = UserManager.isArabic ? "العمليات" : "Operations"
        uiLabelendoscpoies.text = UserManager.isArabic ? "المناظير" : "Endoscopies"
        uiLabelendoscpoies.text = UserManager.isArabic ? "القسطرة" : "Catheter"
        
        let openMedicationOverViewCliked = UITapGestureRecognizer(target: self, action:  #selector(self.openOperation))
        self.uiviewOperation.addGestureRecognizer(openMedicationOverViewCliked)
        
        
        let openMedicationOverViewClikedopenEndoscopies = UITapGestureRecognizer(target: self, action:  #selector(self.openEndoscopies))
        self.uiviewendoscpoies.addGestureRecognizer(openMedicationOverViewClikedopenEndoscopies)
        
        let openMedicationOverViewClikedopenatheter = UITapGestureRecognizer(target: self, action:  #selector(self.openCatheter))
        self.uiviewcatheter.addGestureRecognizer(openMedicationOverViewClikedopenatheter)
        
        
        uiviewOperation.layer.cornerRadius = 20
        uiviewOperation.makeShadow(color: .black, alpha: 0.25, radius: 3)
        
        
        uiviewendoscpoies.layer.cornerRadius = 20
        uiviewendoscpoies.makeShadow(color: .black, alpha: 0.25, radius: 3)
        uiviewcatheter.layer.cornerRadius = 20
        uiviewcatheter.makeShadow(color: .black, alpha: 0.25, radius: 3)
    }

    
    @objc func openOperation()
    {
        let vc:OperationViewController = OperationViewController(patientId: Utilities.sharedInstance.getPatientId(), branchId: "1", Type: "1")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func openEndoscopies()
    {
        let vc:OperationViewController = OperationViewController(patientId: Utilities.sharedInstance.getPatientId(), branchId: "1", Type: "2")
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func openCatheter()
    {
        let vc:OperationViewController = OperationViewController(patientId: Utilities.sharedInstance.getPatientId(), branchId: "1", Type: "3")
        self.navigationController?.pushViewController(vc, animated: true)
    }
     

}
