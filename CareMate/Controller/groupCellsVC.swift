//
//  groupCellsVC.swift
//  CareMate
//
//  Created by mostafa gabry on 3/15/21.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

class groupCellsVC: BaseViewController {

    @IBOutlet weak var medicalRecordBtn: UIButton!
    @IBOutlet weak var radBTn: UIButton!
    @IBOutlet weak var labBtn: UIButton!
    @IBOutlet weak var medicationBtn: UIButton!
    
    @IBOutlet weak var allergies: UIButton!
    @IBOutlet weak var diagnosis: UIButton!
    @IBOutlet weak var history: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("kaskaskaskaskaskaskaskaskaskaskaskaskaskaskaskaskaskas2022")
        if var textAttributes = navigationController?.navigationBar.titleTextAttributes {
            textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.red
            navigationController?.navigationBar.titleTextAttributes = textAttributes
        }
        if UserManager.isArabic == true
        {
            medicationBtn.setTitle("الأدوية", for: .normal)
            labBtn.setTitle("المعمل", for: .normal)
            radBTn.setTitle("الاشعه", for: .normal)
            medicalRecordBtn.setTitle("التقارير الطبية", for: .normal)
      
        }
        else
        {
            medicationBtn.setTitle("Medications", for: .normal)
            labBtn.setTitle("Lab", for: .normal)
            radBTn.setTitle("Rad", for: .normal)
            medicalRecordBtn.setTitle("Medical Record", for: .normal)
        }
        
    
         
    }
    
    @IBAction func OpenOperation(_ sender: Any) {
        let vc:OperationViewController = OperationViewController(patientId: Utilities.sharedInstance.getPatientId(), branchId: "1", Type: "1")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func OpenEndoscopes(_ sender: Any) {
        let vc:OperationViewController = OperationViewController(patientId: Utilities.sharedInstance.getPatientId(), branchId: "1", Type: "2")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

    @IBAction func OpenCatheters(_ sender: Any) {
        let vc:OperationViewController = OperationViewController(patientId: Utilities.sharedInstance.getPatientId(), branchId: "1", Type: "3")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func patientHistoryCliked(_ sender: Any) {
        let vc:PatientHistoryViewController = PatientHistoryViewController(patientId: Utilities.sharedInstance.getPatientId(), branchId: "1")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func patientDiagnosusCliked(_ sender: Any) {
        let vc:DiagnosisViewController = DiagnosisViewController(patientId: Utilities.sharedInstance.getPatientId(), branchId: "1")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func allergyCliked(_ sender: Any) {
        let vc:AllergyViewController = AllergyViewController(patientId: Utilities.sharedInstance.getPatientId(), branchId: "1")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
