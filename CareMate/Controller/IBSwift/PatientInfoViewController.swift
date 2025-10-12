//
//  PatientInfoViewController.swift
//  CareMate
//
//  Created by MAC on 21/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

class PatientInfoViewController: BaseViewController,ListPopupDelegate {
    func listPopupDidSelect(index: Int, type: String) {
        UilabelpatientType.text = UserManager.isArabic ? homeVisitAm[index].nameAr : homeVisitAm[index].nameEn
        submitObject?.erCallCenterr?[0].callPatType = homeVisitAm[index].id
        registeredOrNotId = homeVisitAm[index].id
    }
    
    @IBOutlet weak var labelCallerInfoText: UILabel!

    @IBOutlet weak var labelPatientAddressText: UILabel!
    @IBOutlet weak var labelOtherInfoText: UILabel!

    @IBOutlet weak var labelPatientInfoText: UILabel!
    
    @IBOutlet weak var viewPersonalInfo: UIView!

    @IBOutlet weak var uiviewNext: UIView!
    @IBOutlet weak var UiviewPatientType: UIView!
    @IBOutlet weak var UilabelpatientType: UILabel!
    @IBOutlet weak var labelPTIENTINFO: UILabel!

    var submitObject:ErCallCenterrBigModel?
    var homeVisitAm = [homeVisitAmbulance]()

    var registeredOrNotId = ""
    init(submitrObject: ErCallCenterrBigModel) {
        super.init(nibName: "PatientInfoViewController", bundle: nil)
        self.submitObject = submitrObject
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar.instance.setuptabBar(vc: self)
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "طلب الاسعاف" : "Book Ambulance" , hideBack: false)
        let gestureuiviewNext = UITapGestureRecognizer(target: self, action:  #selector(self.nextCliked))
        self.uiviewNext.addGestureRecognizer(gestureuiviewNext)
        let gestureUiviewPatientType = UITapGestureRecognizer(target: self, action:  #selector(self.openPatientType))
        self.UiviewPatientType.addGestureRecognizer(gestureUiviewPatientType)
        setup()
     
        
        
        if UserManager.isArabic
        {
            labelCallerInfoText.text = "بيانات المتصل"
            labelPatientInfoText.text = "بيانات المريض"
            labelPatientAddressText.text = "عنوان المريض"
            
            labelOtherInfoText.text = "بيانات اخري"

            

        }
        else
        {
            labelCallerInfoText.text = "Caller Info"
            labelPatientInfoText.text = "Patient Info"
            labelPatientAddressText.text = "Patient Address"
            labelOtherInfoText.text = "Other Info"


        }
     
    }


    func setup()  {
        homeVisitAm.append(contentsOf: [homeVisitAmbulance(nameEn: "Register", nameAr: "مسجل", id: "4"),homeVisitAmbulance(nameEn: "Not Register", nameAr: "غير مسجل", id: "3")])
        
        
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: "SavedPerson") as? Data {
            let decoder = JSONDecoder()
            if let _ = try? decoder.decode(LoginedUser.self, from: savedPerson) {

              
                }
              
            viewPersonalInfo.isHidden = true
            
        }
           


        else
        {
            viewPersonalInfo.isHidden = false

            

        }
    }
    
   
    @objc func nextCliked()
    {
        
        if submitObject?.erCallCenterr?[0].callPatType == "1"
        {
            Utilities.showAlert(messageToDisplay:UserManager.isArabic ? "من فضلك ادخل جميع البيانات" : "Plz Enter All Data")
        }
        else
        {
            
            if submitObject?.erCallCenterr?[0].callPatType == "4"
            {
                let vc:PatientAddressViewController = PatientAddressViewController(submitrObject: self.submitObject!)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let vc:PatientInfoSecondViewController = PatientInfoSecondViewController(submitrObject: self.submitObject!)
                self.navigationController?.pushViewController(vc, animated: true)
            }
          
        }
     
    }
    
    @objc func openPatientType()
    {
        AppPopUpHandler.instance.initListPopup(container: self, arrayNames: UserManager.isArabic ? homeVisitAm.map{$0.nameAr} : homeVisitAm.map{$0.nameEn}, title: "Choose call Type", type: "gov")
    }

}
