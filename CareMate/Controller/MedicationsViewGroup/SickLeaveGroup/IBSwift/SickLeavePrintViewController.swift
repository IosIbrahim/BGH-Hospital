//
//  SickLeavePrintViewController.swift
//  CareMate
//
//  Created by MAC on 04/09/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

class SickLeavePrintViewController: BaseViewController {

    @IBOutlet weak var labelMdeicalNumberText: UILabel!
    @IBOutlet weak var labelPatientNameText: UILabel!
    @IBOutlet weak var labelgenderText: UILabel!
    @IBOutlet weak var labelNationalityText: UILabel!
    @IBOutlet weak var labelBirthOfDateText: UILabel!
    @IBOutlet weak var labelSSnText: UILabel!
    @IBOutlet weak var labelDateOfEnteranceText: UILabel!
    @IBOutlet weak var labelDateOfEndingText: UILabel!
    @IBOutlet weak var labelPatientHistotyDAteText: UILabel!

    @IBOutlet weak var labelDurationText: UILabel!
    @IBOutlet weak var labelDiagonsisText: UILabel!

    
    
    
    
    @IBOutlet weak var labelDiagnosis: UILabel!
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var labelSickLeaveDate: UILabel!
    @IBOutlet weak var labelFateEXit: UILabel!
    @IBOutlet weak var labelDateEntrance: UILabel!
    @IBOutlet weak var inpatientImage: UIImageView!
    @IBOutlet weak var outPattientImage: UIImageView!
    @IBOutlet weak var LAbelSSN: UILabel!
    @IBOutlet weak var LableBirhtOfDate: UILabel!
    @IBOutlet weak var NotKuwtainImage: UIImageView!
    @IBOutlet weak var kuwtianImage: UIImageView!
    @IBOutlet weak var femaleImage: UIImageView!
    @IBOutlet weak var maleImage: UIImageView!
    @IBOutlet weak var patientName: UILabel!
    
    @IBOutlet weak var medicalNumer: UILabel!
    @IBOutlet weak var seriesNumber: UILabel!
    @IBOutlet weak var DateReview: UILabel!
    
    
    var listOfOneObject = [sickLeavePrintDTO]()
    var ser = ""
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar.instance.setuptabBar(vc: self)

        getdata()
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1346794665, green: 0.5977677703, blue: 0.5819112062, alpha: 1)

        if UserManager.isArabic
        {
            labelMdeicalNumberText.text = "الرقم الطبي"
            labelPatientNameText.text = "اسم المريض"
            labelgenderText.text = "الجنس"
            labelNationalityText.text = "الجنسيه"

            labelNationalityText.text = "تاريخ الميلاد"
            labelSSnText.text = "الرقم المدني"
            labelDateOfEnteranceText.text = "تاريخ الدخول"
            labelDateOfEndingText.text = "تاريخ الانتهاء"
            labelDiagonsisText.text = "تاريخ التشخيض"
            labelDurationText.text = "Duration"
            labelDiagonsisText.text = "Diagnosis"

        }
        else
        {
            labelMdeicalNumberText.text = "Medical Number"
            labelPatientNameText.text = "Patient Name"
            labelgenderText.text = "Gender"
            labelNationalityText.text = "Nationality"
            labelNationalityText.text = "Birht Od Date"
            labelSSnText.text = "SSN"
            labelDateOfEnteranceText.text = "Enterance Date"
            labelDateOfEndingText.text = "End Date"
            labelDiagonsisText.text = "Sick Leave Date"
            labelDurationText.text = "المده"
            labelDiagonsisText.text = "التشخيص"


        }
        
    }


    func getdata() {
        
        let urlString = Constants.APIProvider.printSickLeave+"patient_id=\(Utilities.sharedInstance.getPatientId())&branch_id=1&user_id=Khabeer&p_reportflag=1&ser=\(ser)"
        let url = URL(string: urlString)
//        let parseUrl = Constants.APIProvider.PatInvoices + Constants.getoAuthValue(url: url!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            
            if error == nil
            {
                 if let root = data as? [AnyObject]
                {
                     if root != nil
                     {
                         
                         self.listOfOneObject.append(sickLeavePrintDTO(JSON: root[0] as! [String : Any])!)
                         self.LAbelSSN.text = self.listOfOneObject[0].patSsn
                         
                         
                         self.labelDuration.text = self.listOfOneObject[0].DUITY_DURATION ?? ""
                         self.medicalNumer.text = self.listOfOneObject[0].patientid ?? ""
                         self.patientName.text =  UserManager.isArabic ? self.listOfOneObject[0].patNameAr ?? "" : self.listOfOneObject[0].patNameEn ?? ""
                     
                         if self.listOfOneObject[0].gendercode == "M"
                         {
                             self.maleImage.image = UIImage(named: "dignosisSelected")
                         }
                         else
                         {
                             self.femaleImage.image = UIImage(named: "dignosisSelected")

                         }
                         
                         if self.listOfOneObject[0].NATIONALITY_LOCAL_FLAG == 1.0
                             {
                                 self.kuwtianImage.image = UIImage(named: "dignosisSelected")
                             }
                             else
                             {
                                 self.kuwtianImage.image = UIImage(named: "dignosisSelected")
                             }
                         self.LableBirhtOfDate.text = self.listOfOneObject[0].dateofbirth
                         
                         if self.listOfOneObject[0].INPAT_FLAG == 1.0
                         {
                             self.inpatientImage.image = UIImage(named: "dignosisSelected")
                         }
                         else
                         {
                             self.outPattientImage.image = UIImage(named: "dignosisSelected")
                         }
                         
                         self.labelDateEntrance.text = self.listOfOneObject[0].visitStartDate
                         
                         self.labelFateEXit.text = self.listOfOneObject[0].visitEndDate
                         self.labelSickLeaveDate.text = self.listOfOneObject[0].sickLeaveEnd
                         self.labelDiagnosis.text = self.listOfOneObject[0].SICK_LEAVE_REASON

                     }
                }
                else
                 {
                    
                    
                }
            }

           
        }
    }
    

}
