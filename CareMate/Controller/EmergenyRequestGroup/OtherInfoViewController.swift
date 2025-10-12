//
//  OtherInfoViewController.swift
//  CareMate
//
//  Created by MAC on 22/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

class OtherInfoViewController: BaseViewController {
    
    @IBOutlet weak var labelSendNurseText: UILabel!

    @IBOutlet weak var labelSendDoctorText: UILabel!
    @IBOutlet weak var labelSendpersonalCarText: UILabel!
    @IBOutlet weak var labelSendHospitalCarText: UILabel!
    
    
    @IBOutlet weak var labelCallerInfoText: UILabel!

    @IBOutlet weak var labelPatientAddressText: UILabel!
    @IBOutlet weak var labelOtherInfoText: UILabel!

    @IBOutlet weak var labelPatientInfoText: UILabel!
    
    @IBOutlet weak var labelnextText: UILabel!

    
    @IBOutlet weak var labelHospitalAm: UILabel!
    @IBOutlet weak var labelDoctorPrice: UILabel!
    @IBOutlet weak var labelNursePrice: UILabel!
    @IBOutlet weak var labelTotal: UILabel!
    @IBOutlet weak var viewPersonalInfo: UIView!

    @IBOutlet weak var UiViewTotal: UIView!
    @IBOutlet weak var UiViewDoctorPrice: UIView!
    @IBOutlet weak var UiviewNursePrice: UIView!
    @IBOutlet weak var doctorPriceHeigthConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var personalCheaked: UIImageView!
    @IBOutlet weak var hospitalCheaked: UIImageView!
    @IBOutlet weak var doctorCheackImage: UIImageView!
    @IBOutlet weak var nurseCheakedImage: UIImageView!
    @IBOutlet weak var nurseViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var hospitalCarHeightCosstant: NSLayoutConstraint!
    @IBOutlet weak var NurseView: UIView!
    @IBOutlet weak var submit: UIView!
    @IBOutlet weak var LABELPATIENTINFO: UILabel!

    @IBOutlet weak var viewHospitalCar: UIView!
    @IBOutlet weak var personalHospitalHeight: NSLayoutConstraint!
    @IBOutlet weak var personalHospitalStack: UIStackView!
    var  nursePriceCheakedUnCheaked = false
    var  HospitalPriceCheakedUnCheaked = false
    var  PersonalPriceCheakedUnCheaked = false
    
    var nursePrice = "0"
    var DoctorPrice = "0"
    var ambulancePrice = "0"
    var total = 0
    var listOfSpecailties = [SpecialityOfOtherInfo]()


    var  doctorPriceCheakedUnCheaked = false
    var submitObject:ErCallCenterrBigModel?
    let group = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar.instance.setuptabBar(vc: self)
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "طلب الاسعاف" : "Book Ambulance" , hideBack: false)

        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: "SavedPerson") as? Data {
            let decoder = JSONDecoder()
            if let _ = try? decoder.decode(LoginedUser.self, from: savedPerson) {
            }
              
            viewPersonalInfo.isHidden = true
            LABELPATIENTINFO.isHidden = true
        }
           


        else
        {
            viewPersonalInfo.isHidden = false
            LABELPATIENTINFO.isHidden = false

        }
        
        if UserManager.isArabic
        {
            labelCallerInfoText.text = "بيانات المتصل"
            labelPatientAddressText.text = "عنوان المريض"
            labelOtherInfoText.text = "بيانات اخري"
            
            labelSendNurseText.text = "ارسال ممرضه"
            labelSendDoctorText.text = "ارسال طبيب"
            labelSendpersonalCarText.text = "ارسال سياره شخصيه"
            labelSendHospitalCarText.text = "ارسال سياره المستشفي"
            labelnextText.text = "التالي"

        }
        else{
            
            labelCallerInfoText.text = "Caller Info"
            labelPatientAddressText.text = "Patient Address"
            labelOtherInfoText.text = "Other Info"
            
            labelSendNurseText.text = "Send Nurse"
            labelSendDoctorText.text = "Send Doctor"
            labelSendpersonalCarText.text = "Send Personal Car"
            labelSendHospitalCarText.text = "Send Hospitl Car"
            labelnextText.text = "Next"
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setup()
    }
    
    init(submitrObject: ErCallCenterrBigModel) {
        super.init(nibName: "OtherInfoViewController", bundle: nil)
        self.submitObject = submitrObject
        
      print(submitrObject)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func sendDoctor(_ sender: Any) {
        if doctorPriceCheakedUnCheaked == false
        {
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.doctorPriceHeigthConstraint.constant = 90
                self.view.layoutIfNeeded()
            })
            self.doctorPriceCheakedUnCheaked = true
            UiViewDoctorPrice.isHidden = false
            doctorCheackImage.image = UIImage(named: "iconCh.png")
            
            total += Int(DoctorPrice)!
            self.labelTotal.text = String(total)
            AppPopUpHandler.instance.initListPopup(container: self, arrayNames: listOfSpecailties.map{$0.NAME_EN}, title: "Choose Specaility", type: "Chosse")

        }
        else
        {
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.doctorPriceHeigthConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
            doctorPriceCheakedUnCheaked = false
            UiViewDoctorPrice.isHidden = true
            doctorCheackImage.image = UIImage(named: "cheacked.png")
            total -= Int(DoctorPrice)!
            self.labelTotal.text = String(total)

        }
        
//        if doctorPriceCheakedUnCheaked == false && nursePriceCheakedUnCheaked == false
//        {
//            UIView.animate(withDuration: 0.2, animations: { () -> Void in
//                self.totalHeightConstraint.constant = 128
//                self.view.layoutIfNeeded()
//            })
//            UiViewTotal.isHidden = false
//        }
//        else
//        {
//            UIView.animate(withDuration: 0.2, animations: { () -> Void in
//                self.totalHeightConstraint.constant = 0
//                self.view.layoutIfNeeded()
//            })
//            UiViewTotal.isHidden = true
//
//        }
    }
    
    @IBAction func sendNurse(_ sender: Any) {
        if nursePriceCheakedUnCheaked == false
        {
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
               self.nurseViewHeight.constant = 90
               self.view.layoutIfNeeded()
           })
            UiviewNursePrice.isHidden = false
            nursePriceCheakedUnCheaked = true
            nurseCheakedImage.image = UIImage(named: "iconCh.png")
            total += Int(nursePrice)!
            self.labelTotal.text = String(total)

        }
        else
        {
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.nurseViewHeight.constant = 0
            self.view.layoutIfNeeded()

        })
            total -= Int(nursePrice)!
            self.labelTotal.text = String(total)

            UiviewNursePrice.isHidden = true
            nursePriceCheakedUnCheaked = false
            nurseCheakedImage.image = UIImage(named: "cheacked.png")

        }

    }
    @objc func confirmClicked() {
        
        
        if doctorPriceCheakedUnCheaked == true
        {
            submitObject?.erCallCenterr?[0].ambulanceDocNeed = "1"
        }
        else
        {
            submitObject?.erCallCenterr?[0].ambulanceDocNeed = "0"

        }
        if nursePriceCheakedUnCheaked == true
        {
            submitObject?.erCallCenterr?[0].ambulanceNurseNeed = "1"
        }
        else
        {
            submitObject?.erCallCenterr?[0].ambulanceNurseNeed = "0"

        }
        let mdl = submitObject?.erCallCenterr?[0]

        if mdl?.callPatType == "3"
        {
            let birth = mdl?.DATE_OF_BIRTH?.ConvertToDate
            var years = Calendar.current.dateComponents([.month], from: birth ?? .init(), to: Date()).year
            years = mdl?.years
            
            var pars = ["_ER_PARMS": ["BRANCH_ID":submitObject?.erParms?.branchID,
                                      "PROCESS_ID":submitObject?.erParms?.processID,
                                      "USER_ID":submitObject?.erParms?.userID,
                                      "COMPUTER_NAME":submitObject?.erParms?.computerName,
                                      "IN_OUT_CITY":submitObject?.erParms?.inOutCity],
                        "_ER_CALL_CENTERR":[["BUFFER_STATUS":1,
                                             "CALLAR_NAME":mdl?.callarName,
                                             "HOME_PHONE":mdl?.homePhone,
                                             "GOV_ID":mdl?.govID,
                                             "CITY_ID":mdl?.cityID,
                                             "VILLAGE_CODE":mdl?.villageCode,
                                             "STREETNAME":mdl?.A2sima,
                                             "BUILDING_NO":mdl?.bulidingNumber,
                                          //   "DATE_OF_BIRTH_STR_FORMATED":"01-01-1990 00:00:00",
                                         //    "DATE_OF_BIRTH":"01/01/1990 00:00:00",
                                             "DATE_OF_BIRTH_STR_FORMATED":mdl?.DATE_OF_BIRTH_STR_FORMATED,
                                             "DATE_OF_BIRTH":mdl?.DATE_OF_BIRTH,
                                             "ADDRESS":mdl?.address,
                                             "NEW_REMARKS":mdl?.newRemarks,
                                             "CALL_TYPE":mdl?.callType,
                                             "AMBULANCE_DOC_NEED":mdl?.ambulanceDocNeed,
                                             "AMBULANCE_NURSE_NEED":mdl?.ambulanceNurseNeed,
                                             "AMBULANCE_CAR_TYPE":mdl?.ambulanceCarType,
                                             "CALL_PAT_TYPE":mdl?.callPatType,
                                             "F_NAME_EN":mdl?.F_NAME,
                                             "S_NAME_EN":mdl?.S_NAME,
                                             "T_NAME_EN":mdl?.T_NAME,
                                             "L_NAME_EN":mdl?.L_NAME,
                                             "F_NAME":mdl?.F_NAME,
                                             "S_NAME":mdl?.S_NAME,
                                             "T_NAME":mdl?.T_NAME,
                                             "L_NAME":mdl?.L_NAME,
                                             "GENDER":mdl?.GENDER,
                                             "PAT_AGE":years ,
                                             "BUILDING_COMPUTER_SERIAL":mdl?.AumotedNumber,
                                             "HOME_VISIT_CAR_TYPE":mdl?.HOME_VISIT_CAR_TYPE]
                                           ]


                      
            ] as [String : Any]
            let urlString = Constants.APIProvider.SubmitStepNew
            let url = URL(string: urlString)
    //        let parseUrl = Constants.APIProvider.SubmitStepNew + Constants.getoAuthValue(url: url!, method: "POST",parameters: pars)
            WebserviceMananger.sharedInstance.makeCall(method: .post, url: urlString, parameters: pars, vc: self) { (data, error) in


                let root = data as? [String:Any]
                print(root ?? .init())
                if let message = root?["MESSAGE"] as? [String:Any] {
                    let row = message["MESSAGE_ROW"] as? [String:Any]
                    let en = row?["NAME_EN"] as? String
                    let ar = row?["NAME_AR"] as? String
                    let code = row?["CODE"] as? Int
                    if code == 1 {
                        Utilities.showAlert(messageToDisplay: UserManager.isArabic ? "سيتم التواصل معك قريبا بتفاصيل الحجز" : "You will be contacted soon with the details of your request")
                    }else {
                        Utilities.showAlert(messageToDisplay: UserManager.isArabic ? ar ?? "UnKnown Error": en ?? "UnKnown Error")
                    }
                }
                if let code = root?["code"] as? Int {
                    if code == 1 {
                        Utilities.showAlert(messageToDisplay: UserManager.isArabic ? "سيتم التواصل معك قريبا بتفاصيل الحجز" : "You will be contacted soon with the details of your request")
                    }else {
                        Utilities.showAlert(messageToDisplay: root?["message"] as? String ??  "UnKnown Error")
                    }
                }

               
              //  Utilities.showAlert(messageToDisplay: UserManager.isArabic ? "سيتم التواصل معك قريبا بتفاصيل الحجز" : "You will be contacted soon with the details of your request")
              
            }
        }
        else
        {
            let birth = mdl?.DATE_OF_BIRTH?.ConvertToDate
            var years = Calendar.current.dateComponents([.month], from: birth ?? .init(), to: Date()).year
            years = mdl?.years
            
            var pars = ["_ER_PARMS": ["BRANCH_ID":submitObject?.erParms?.branchID,
                                      "PROCESS_ID":submitObject?.erParms?.processID,
                                      "USER_ID":submitObject?.erParms?.userID,
                                      "COMPUTER_NAME":submitObject?.erParms?.computerName,
                                      "IN_OUT_CITY":submitObject?.erParms?.inOutCity],
                        "_ER_CALL_CENTERR":[["PAT_AGE":years,
                                         //    "DATE_OF_BIRTH_STR_FORMATED":"01-01-1990 00:00:00",
                                           //  "DATE_OF_BIRTH":"01/01/1990 00:00:00",
                                             "DATE_OF_BIRTH_STR_FORMATED":mdl?.DATE_OF_BIRTH_STR_FORMATED,
                                             "DATE_OF_BIRTH":mdl?.DATE_OF_BIRTH,
                                             "BUILDING_COMPUTER_SERIAL":mdl?.AumotedNumber,
                                             "ADDRESS_BLOCK_DESC":mdl?.group,
                                             "BUILDING_NO":mdl?.bulidingNumber,
                                             "STREETNAME":mdl?.A2sima,
                                             "BUFFER_STATUS":mdl?.bufferStatus,
                                             "CALLAR_NAME":mdl?.callarName,
                                             "HOME_PHONE":mdl?.homePhone,
                                             "GOV_ID":mdl?.govID,
                                             "CITY_ID":mdl?.cityID,
                                             "VILLAGE_CODE":mdl?.villageCode,
                                             "ADDRESS":mdl?.address,
                                             "NEW_REMARKS":mdl?.newRemarks,
                                             "CALL_TYPE":mdl?.callType,
                                             "AMBULANCE_DOC_NEED":mdl?.ambulanceDocNeed,
                                             "AMBULANCE_NURSE_NEED":mdl?.ambulanceNurseNeed,
                                             "AMBULANCE_CAR_TYPE":mdl?.ambulanceCarType,
                                             "CALL_PAT_TYPE":mdl?.callPatType,
                                             "PATIENT_ID":mdl?.patientID,
                                             "F_NAME_EN":mdl?.F_NAME,
                                             "S_NAME_EN":mdl?.S_NAME,
                                             "T_NAME_EN":mdl?.T_NAME,
                                             "L_NAME_EN":mdl?.L_NAME,
                                             "F_NAME":mdl?.F_NAME,
                                             "S_NAME":mdl?.S_NAME,
                                             "T_NAME":mdl?.T_NAME,
                                             "L_NAME":mdl?.L_NAME,
                                             "GENDER":mdl?.GENDER,
                                             "HOME_VISIT_CAR_TYPE":mdl?.HOME_VISIT_CAR_TYPE]
                                           ]


                      
            ] as [String : Any]
            let urlString = Constants.APIProvider.SubmitStepNew
            let url = URL(string: urlString)
    //        let parseUrl = Constants.APIProvider.SubmitStepNew + Constants.getoAuthValue(url: url!, method: "POST",parameters: pars)
            WebserviceMananger.sharedInstance.makeCall(method: .post, url: urlString, parameters: pars, vc: self) { (data, error) in
                let root = data as? [String:Any]
                print(root ?? .init())
                if let message = root?["MESSAGE"] as? [String:Any] {
                    let row = message["MESSAGE_ROW"] as? [String:Any]
                    let en = row?["NAME_EN"] as? String
                    let ar = row?["NAME_AR"] as? String
                    let code = row?["CODE"] as? Int
                    if code == 1 {
                        Utilities.showAlert(messageToDisplay: UserManager.isArabic ? "سيتم التواصل معك قريبا بتفاصيل الحجز" : "You will be contacted soon with the details of your request")
                    }else {
                        Utilities.showAlert(messageToDisplay: UserManager.isArabic ? ar ?? "UnKnown Error": en ?? "UnKnown Error")
                    }
                }
                if let code = root?["code"] as? Int {
                    if code == 1 {
                        Utilities.showAlert(messageToDisplay: UserManager.isArabic ? "سيتم التواصل معك قريبا بتفاصيل الحجز" : "You will be contacted soon with the details of your request")
                    }else {
                        Utilities.showAlert(messageToDisplay: root?["message"] as? String ??  "UnKnown Error")
                    }
                }
              
            }
        }
       

//
//        }
       
    }

    @IBAction func useHospitalCarCliked(_ sender: Any) {
        
        if HospitalPriceCheakedUnCheaked == false
        {
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
               self.hospitalCarHeightCosstant.constant = 90
               self.view.layoutIfNeeded()
           })
            viewHospitalCar.isHidden = false
            HospitalPriceCheakedUnCheaked = true
            hospitalCheaked.image = UIImage(named: "iconCh.png")
            total += Int(ambulancePrice)!
            
            self.labelTotal.text = String(total)

            personalHospitalHeight.constant = 238
            submitObject?.erCallCenterr?[0].HOME_VISIT_CAR_TYPE = "1"

        }
        else
        {
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.hospitalCarHeightCosstant.constant = 0
            self.view.layoutIfNeeded()
                self.personalHospitalHeight.constant = 210 - 108

        })
            total -= Int(ambulancePrice)!
            self.labelTotal.text = String(total)

            viewHospitalCar.isHidden = true
            HospitalPriceCheakedUnCheaked = false
            hospitalCheaked.image = UIImage(named: "cheacked.png")
            submitObject?.erCallCenterr?[0].HOME_VISIT_CAR_TYPE = ""

        }

        
    }
    
    @IBAction func usePersonalCarCliked(_ sender: Any) {
        if PersonalPriceCheakedUnCheaked == false
        {
            personalCheaked.image = UIImage(named: "iconCh.png")
            PersonalPriceCheakedUnCheaked = true
            submitObject?.erCallCenterr?[0].HOME_VISIT_CAR_TYPE = "1"

        }
        else
        {
            submitObject?.erCallCenterr?[0].HOME_VISIT_CAR_TYPE = ""

            personalCheaked.image = UIImage(named: "cheacked.png")
            PersonalPriceCheakedUnCheaked = false

        }
        

    }
    func getAmbuNurseServicePrice() {
        
//        group.enter()
        let urlString = Constants.APIProvider.getAmbuNurseServicePrice
        let url = URL(string: urlString)
//        let parseUrl = Constants.APIProvider.PatInvoices + Constants.getoAuthValue(url: url!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
                    
            let root = (data as! [String:AnyObject])["Root"] as! [String: AnyObject]
            
            if error == nil
            {
                if root.keys.contains("OUT_PARMS")
                {
                    let messageRow = (root["OUT_PARMS"] as! [String: AnyObject])["OUT_PARMS_ROW"] as! [String : AnyObject]
                
                    self.nursePrice =  messageRow["PRICE"] as! String


                    self.labelNursePrice.text = messageRow["PRICE"] as! String

                }
            }
//            self.group.leave()

           
        }
    }
    func getAmbuDocServicePrice() {
        
//        group.enter()
        let urlString = Constants.APIProvider.getAmbuDocServicePrice
        let url = URL(string: urlString)
//        let parseUrl = Constants.APIProvider.PatInvoices + Constants.getoAuthValue(url: url!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
                    
            let root = (data as! [String:AnyObject])["Root"] as! [String: AnyObject]
            
            if error == nil
            {
                if root.keys.contains("OUT_PARMS")
                {
                    let messageRow = (root["OUT_PARMS"] as! [String: AnyObject])["OUT_PARMS_ROW"] as! [String : AnyObject]
                
                   
                    self.DoctorPrice =  messageRow["PRICE"] as! String
                    self.labelDoctorPrice.text = messageRow["PRICE"] as! String

                }
            }
//            self.group.leave()

           
        }
    }
    func gethvhcServicePrice() {
        
//        group.enter()
        let urlString = Constants.APIProvider.gethvhcServicePrice
        let url = URL(string: urlString)
//        let parseUrl = Constants.APIProvider.PatInvoices + Constants.getoAuthValue(url: url!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
                    
            let root = (data as! [String:AnyObject])["Root"] as! [String: AnyObject]
            
            if error == nil
            {
                if root.keys.contains("OUT_PARMS")
                {
                    let messageRow = (root["OUT_PARMS"] as! [String: AnyObject])["OUT_PARMS_ROW"] as! [String : AnyObject]
                
                    self.labelHospitalAm.text = messageRow["PRICE"] as! String
                    
                    self.ambulancePrice =  messageRow["PRICE"] as! String

                }
            }
//            self.group.leave()

           
        }
    }
    
    
    func LoadERCALLCENTER() {
        
        let urlString = Constants.APIProvider.LoadERCALLCENTER+"branch_id=1"
        let url = URL(string: urlString)
//        let parseUrl = Constants.APIProvider.PatInvoices + Constants.getoAuthValue(url: url!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            
            if error == nil
            {
                 if let root = ((data as! [String: AnyObject])["SPECIALITY"] as! [String:AnyObject])["SPECIALITY_ROW"] as? [[String:AnyObject]]
                {
                    
               for i in root
               {
                
                self.listOfSpecailties.append(SpecialityOfOtherInfo(JSON: i)!)
               }
                    
                   print(root)
                    
                }
                else
                 {
                }
            }
//            self.group.leave()

           
        }

    }
    func setup()  {
        indicator.sharedInstance.show()
        gethvhcServicePrice()
        getAmbuNurseServicePrice()
        getAmbuDocServicePrice()
        LoadERCALLCENTER()
        nurseViewHeight.constant = 0.0
        doctorPriceHeigthConstraint.constant = 0.0
        hospitalCarHeightCosstant.constant = 0.0
//        totalHeightConstraint.constant = 0.0
        UiviewNursePrice.isHidden = true
        UiViewDoctorPrice.isHidden = true
        viewHospitalCar.isHidden = true

        if submitObject?.erCallCenterr![0].callType == "2"
        {
            personalHospitalStack.isHidden = false
            personalHospitalHeight.constant = 210 - 108

        }
        else
        {
            personalHospitalStack.isHidden = true
            personalHospitalHeight.constant = 0

        }
        
        group.notify(queue: .main) {
          
            indicator.sharedInstance.dismiss()

        }
        

        let gestureuiviewvillageNext = UITapGestureRecognizer(target: self, action:  #selector(self.confirmClicked))
        self.submit.addGestureRecognizer(gestureuiviewvillageNext)
    }
}
