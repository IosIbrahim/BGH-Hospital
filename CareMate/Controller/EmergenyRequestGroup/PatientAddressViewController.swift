//
//  PatientAddressViewController.swift
//  CareMate
//
//  Created by MAC on 22/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

class PatientAddressViewController: BaseViewController,UITextFieldDelegate ,ListPopupDelegate{
  
    var submitObject:ErCallCenterrBigModel?
    init(submitrObject: ErCallCenterrBigModel) {
        super.init(nibName: "PatientAddressViewController", bundle: nil)
        self.submitObject = submitrObject
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    @IBOutlet weak var labelDistrictText: UILabel!
    @IBOutlet weak var labelAreaText: UILabel!
    @IBOutlet weak var labelStreetText: UILabel!
    @IBOutlet weak var labelgroupText: UILabel!
    @IBOutlet weak var labelcouponText: UILabel!
    @IBOutlet weak var labelBulidingNumberText: UILabel!
    @IBOutlet weak var labelautoFigureText: UILabel!
    @IBOutlet weak var uitextFieldAddressText: UITextField!
    @IBOutlet weak var viewBlock: UIView!
    
//    @IBOutlet weak var labelCallerInfoText: UILabel!
//
//    @IBOutlet weak var labelPatientAddressText: UILabel!
//    @IBOutlet weak var labelOtherInfoText: UILabel!
//
//    @IBOutlet weak var labelPatientInfoText: UILabel!
    
    @IBOutlet weak var uiviewNext: UIView!
    @IBOutlet weak var uiviewgov: UIView!
    @IBOutlet weak var uiviewCity: UIView!
    @IBOutlet weak var uiviewBulidingNo: UIView!

    @IBOutlet weak var uiviewvillage: UIView!
    @IBOutlet weak var uiLabelgov: UILabel!
    @IBOutlet weak var uiLabelCity: UILabel!
    @IBOutlet weak var uiLabelvillage: UILabel!
    @IBOutlet weak var uiLabelapp: UILabel!
    @IBOutlet weak var viewPersonalInfo: UIView!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var textfieldAutomated: UITextField!
    @IBOutlet weak var textFieldBuilding: UITextField!
    @IBOutlet weak var textFieldGroup: UITextField!
    @IBOutlet weak var textFieldA2sema: UITextField!
    @IBOutlet weak var viewJaddja: UIView!
    @IBOutlet weak var viewApp: UIView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var labelPatientAddress: UILabel!
    @IBOutlet weak var labelDetermineLocation: UILabel!
    @IBOutlet weak var viewChooseMap: UIView!
    @IBOutlet weak var viewChooseAddress: UIView!
    @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var viewGoHolder: UIView!
    @IBOutlet weak var viewAreaHolder: UIView!
    @IBOutlet weak var viewBlockHolder: UIView!
    @IBOutlet weak var viewStreetHolder: UIView!
    @IBOutlet weak var viewBuildingHolder: UIView!
    @IBOutlet weak var viewAddressHolder: UIView!
    @IBOutlet weak var labelSelectmap: UILabel!
    @IBOutlet weak var labelSelecteAddress: UILabel!
    
    var listOfCity = [GOV_RDTO]()
    var listOfGov = [GOV_RDTO]()
    var listOfStreet = [GOV_RDTO]()
    var govText = ""
    var areaText = ""
    var streetText = ""
    var isLabHomeVisit:Bool = false
    var successMSG = ""

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar.instance.setuptabBar(vc: self)
        if UserManager.isArabic {
            labelPatientAddress.text = "عنوان المريض"
            labelDetermineLocation.text = "حدد المكان"
        }
        
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "طلب الاسعاف" : "Book Ambulance" , hideBack: false)
        uitextFieldAddressText.delegate = self
        uitextFieldAddressText.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        textFieldGroup.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        textFieldBuilding.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        uitextFieldAddressText.rightViewMode = .unlessEditing
        setup()
        getdata()
        
        uiviewgov.makeShadow(color: .black, alpha: 0.25, radius: 3)
        uiviewCity.makeShadow(color: .black, alpha: 0.25, radius: 3)
        uiviewvillage.makeShadow(color: .black, alpha: 0.25, radius: 3)
        uiviewvillage.makeShadow(color: .black, alpha: 0.25, radius: 3)
        
        uiviewBulidingNo.makeShadow(color: .black, alpha: 0.25, radius: 3)
        viewBlock.makeShadow(color: .black, alpha: 0.25, radius: 3)
        viewJaddja.makeShadow(color: .black, alpha: 0.25, radius: 3)
        viewApp.makeShadow(color: .black, alpha: 0.25, radius: 3)
        viewAddress.makeShadow(color: .black, alpha: 0.25, radius: 3)
        viewChooseMap.makeShadow(color: .black, alpha: 0.25, radius: 3)
        viewChooseAddress.makeShadow(color: .black, alpha: 0.25, radius: 3)
        viewChooseMap.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseMap)))
        viewChooseAddress.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseAddress)))
        chooseAddress()
        if UserManager.isArabic
        {
//            labelCallerInfoText.text = "بيانات المتصل"
//            labelPatientInfoText.text = "بيانات المريض"
//            labelPatientAddressText.text = "عنوان المريض"
//            labelOtherInfoText.text = "بيانات اخري"
            labelDistrictText.text = "المحافظة"
            labelAreaText.text = "المنطقة"
            labelStreetText.text = "الشارع"
            labelgroupText.text = "القطعة"
            labelcouponText.text = "القسيمة"
            labelBulidingNumberText.text = "منزل / مبني / طابق / شقة"
            labelautoFigureText.text = "العنوان"
            labelAddress.text = "العنوان"
            uiLabelapp.text = "الرقم الالي"
            labelSelectmap.text = "الخريطة"
            labelSelecteAddress.text = "العنوان"

        }
        else
        {
//            labelCallerInfoText.text = "Caller Info"
//            labelPatientInfoText.text = "Patient Info"
//            labelPatientAddressText.text = "Patient Address"
//            labelOtherInfoText.text = "Other Info"
            labelDistrictText.text = "Government"
            labelAreaText.text = "Area"
            labelStreetText.text = "Street"
            labelgroupText.text = "Block"
            labelcouponText.text = "Jaddha"
            labelBulidingNumberText.text = "House/Budling/Floor/Apartment"
            labelautoFigureText.text = "Address"
            labelAddress.text = "Address"
            uiLabelapp.text = "App"
        }
        
        textFieldGroup.keyboardType = .asciiCapableNumberPad
       // textFieldBuilding.keyboardType = .asciiCapableNumberPad
        textfieldAutomated.keyboardType = .asciiCapableNumberPad
    }
    
    @objc func chooseMap() {
        viewChooseMap.backgroundColor = .fromHex(hex: "208882", alpha: 1)
        viewChooseAddress.backgroundColor = .white
        labelSelecteAddress.textColor = .black
        labelSelectmap.textColor = .white
        viewLocation.isHidden = false
//        viewAddressHolder.isHidden = false
        viewGoHolder.isHidden = true
        viewAreaHolder.isHidden = true
        viewBlockHolder.isHidden = true
        viewStreetHolder.isHidden = true
        viewBuildingHolder.isHidden = true
    }
    
    @objc func chooseAddress() {
        viewChooseMap.backgroundColor = .white
        labelSelecteAddress.textColor = .white
        labelSelectmap.textColor = .black
        viewChooseAddress.backgroundColor = .fromHex(hex: "208882", alpha: 1)
        viewLocation.isHidden = true
//        viewAddressHolder.isHidden = true
        viewGoHolder.isHidden = false
        viewAreaHolder.isHidden = false
        viewBlockHolder.isHidden = false
        viewStreetHolder.isHidden = false
        viewBuildingHolder.isHidden = false
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text == ""
        {
            textField.rightViewMode = .always
            textField.rightView?.isHidden = false
        }
        else
        {
            textField.rightViewMode = .never
            textField.rightView?.isHidden = true

        }
        setTextInAutomatedTextField()
    }

    func setTextInAutomatedTextField() {
        var text = ""
        if govText != "" {
            text = govText
        }
        if areaText != "" {
            text += " - \(areaText)"
        }
        if textFieldGroup.text != "" {
            text += " - \(textFieldGroup.text!)"
        }
        if streetText != "" {
            text += " - \(streetText)"
        }
        if textFieldBuilding.text != "" {
            text += " - \(textFieldBuilding.text!)"
        }
        textfieldAutomated.text = text
    }

    @IBAction func chosseLocation(_ sender: Any) {
        let vc :  AddAddressFromMapViewController = AddAddressFromMapViewController()
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true
        
        )
    }
    
    func setup()  {
        let gestureuiviewNext = UITapGestureRecognizer(target: self, action:  #selector(self.nextCliked))
        self.uiviewNext.addGestureRecognizer(gestureuiviewNext)
        let gestureUiGovNext = UITapGestureRecognizer(target: self, action:  #selector(self.govCliked))
        self.uiviewgov.addGestureRecognizer(gestureUiGovNext)
        
        let gestureUiCityNext = UITapGestureRecognizer(target: self, action:  #selector(self.cityCliked))
        self.uiviewCity.addGestureRecognizer(gestureUiCityNext)
        
        let gestureuiviewvillageNext = UITapGestureRecognizer(target: self, action:  #selector(self.streetCliked))
        self.uiviewvillage.addGestureRecognizer(gestureuiviewvillageNext)
        
        textFieldGroup.delegate = self
        textfieldAutomated.delegate = self
        textFieldA2sema.delegate = self
        textFieldBuilding.delegate = self
        
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: "SavedPerson") as? Data {
            let decoder = JSONDecoder()
            if let _ = try? decoder.decode(LoginedUser.self, from: savedPerson) {

              
                }
//            LABELPATIENTINFO.isHidden = true
            viewPersonalInfo.isHidden = true
        }
           


        else
        {
            viewPersonalInfo.isHidden = false
        }
        
        var msg =  UserManager.isArabic ? "عملينا العزيز ، سيتم التواصل معك من قبل موظف مركز التواصل ليتم تأكيد طلبك ، في حال التقديم على الطلب بعد الساعة 11 مساءا سيتم التواصل معكم في اليوم التالي." : "Dear Customer , we will contact you shortly to confirm your request. If you are booking after 11 pm, we will contact you the next day."
        if self.isLabHomeVisit {
            msg =  UserManager.isArabic ? "عملينا العزيز ، سيتم التواصل معك من قبل موظف مركز التواصل ليتم تأكيد طلبك ، في حال التقديم على الطلب بعد الساعة 2 مساءا سيتم التواصل معكم في اليوم التالي." : "Dear Customer , we will contact you shortly to confirm your request. If you are booking after 2 pm, we will contact you the next day."
        }
        successMSG = msg
    }
    
    
    
    @objc func cityCliked()
    {
        AppPopUpHandler.instance.initListPopup(container: self, arrayNames: UserManager.isArabic ? listOfCity.map{$0.NAME_AR} :listOfCity.map{$0.NAME_EN} , title: "Choose city", type: "city")
    }
    @objc func streetCliked()
    {
        AppPopUpHandler.instance.initListPopup(container: self, arrayNames: UserManager.isArabic ? listOfStreet.map{$0.NAME_AR} :listOfStreet.map{$0.NAME_EN} , title: "Choose street", type: "street")
    }
    
    @objc func govCliked()
    {
        AppPopUpHandler.instance.initListPopup(container: self, arrayNames: UserManager.isArabic ? listOfGov.map{$0.NAME_AR} :listOfGov.map{$0.NAME_EN} , title: "Choose Gov", type: "gov")
    }
    @objc func nextCliked()
    {
        
        
        if   submitObject?.erCallCenterr?[0].govID  != nil
        {
            confirmClicked()
        }
        else
        {
            Utilities.showAlert(messageToDisplay:UserManager.isArabic ? "من فضلك ادخل اسم المحافظه" : "Plz Enter Gov Name")
        }
        
      
    }
    @objc func confirmClicked() {
        if submitObject?.erCallCenterr?[0].govID == nil || submitObject?.erCallCenterr?[0].govID == "" {
            OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "من فضلك اختر المحافطة" : "Please choose governorate")
            return
        } else if submitObject?.erCallCenterr?[0].cityID == nil || submitObject?.erCallCenterr?[0].cityID == "" {
            OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "من فضلك اختر المدينة" : "Please choose city")
            return
        }
        submitObject?.erCallCenterr?[0].A2sima = uiLabelvillage.text
        if submitObject?.erCallCenterr?[0].callPatType == "3" {
            
            let object = submitObject?.erCallCenterr?[0]
            let birth = object?.DATE_OF_BIRTH?.ConvertToDate
            var years = Calendar.current.dateComponents([.month], from: birth ?? .init(), to: Date()).year
            years = object?.years
            var frm = object?.DATE_OF_BIRTH?.replacingOccurrences(of: "/", with: "-")
            frm = object?.DATE_OF_BIRTH_STR_FORMATED
            var erParams = ["BRANCH_ID": submitObject?.erParms?.branchID ?? "",
                            "PROCESS_ID": submitObject?.erParms?.processID ?? "",
                            "USER_ID": submitObject?.erParms?.userID ?? "",
                            "COMPUTER_NAME": submitObject?.erParms?.computerName ?? "",
                            "IN_OUT_CITY": submitObject?.erParms?.inOutCity ?? ""]
            erParams.updateValue(submitObject?.erParms?.branchID ?? "", forKey: "Hosp_id")
            let erCallCenterr1 = ["BUFFER_STATUS": "1",
                                  "CALLAR_NAME": object?.callarName ?? "",
                                  "HOME_PHONE": object?.homePhone ?? "",
                                  "GOV_ID": object?.govID ?? "",
                                  "CITY_ID": object?.cityID ?? ""]
            let erCallCenterr2 = ["VILLAGE_CODE": object?.villageCode ?? "",
                                  "STREETNAME": object?.villageCode ?? "",
                                  "BUILDING_NO": object?.bulidingNumber ?? "",
                                //  "DATE_OF_BIRTH_STR_FORMATED": "01-01-1990 00:00:00",
                                 // "DATE_OF_BIRTH": "01/01/1990 00:00:00"
                                  "DATE_OF_BIRTH_STR_FORMATED": frm ?? "",
                                  "DATE_OF_BIRTH": object?.DATE_OF_BIRTH ?? ""
            ]
            let erCallCenterr3 = ["ADDRESS": textfieldAutomated.text ?? "",
                                  "NEW_REMARKS": object?.newRemarks ?? "",
                                  "CALL_TYPE": object?.callType ?? "",
                                  "AMBULANCE_DOC_NEED": "0",
                                  "AMBULANCE_NURSE_NEED": "0",
                                  "HOME_VISIT_DOC_NEED": "0",
                                  "HOME_VISIT_NURSE_NEED": "1",
                                  "FROM_MOBILE_APP": "1"]
            let erCallCenterr4 = ["AMBULANCE_CAR_TYPE": object?.ambulanceCarType ?? "",
                                  "CALL_PAT_TYPE":object?.callPatType ?? "",
                                  "F_NAME_EN":object?.F_NAME ?? "",
                                  "S_NAME_EN":object?.S_NAME ?? "",
                                  "T_NAME_EN":object?.T_NAME ?? ""]
            let erCallCenterr5 = ["L_NAME_EN":object?.L_NAME ?? "",
                                  "F_NAME":object?.F_NAME ?? "",
                                  "S_NAME":object?.S_NAME ?? "",
                                  "T_NAME":object?.T_NAME ?? "",
                                  "L_NAME":object?.L_NAME ?? ""]
            let erCallCenterr6 = ["GENDER":object?.GENDER ?? "",
                                  "PAT_AGE":"\(years ?? 0)",
                                  "BUILDING_COMPUTER_SERIAL":object?.AumotedNumber ?? "",
                                  "HOME_VISIT_CAR_TYPE":"1",
                                  "Hosp_id": submitObject?.erParms?.branchID ?? ""]
            var erCallCenterr = erCallCenterr1.merging(erCallCenterr2) { $1 }
            erCallCenterr = erCallCenterr.merging(erCallCenterr3) { $1 }
            erCallCenterr = erCallCenterr.merging(erCallCenterr4) { $1 }
            erCallCenterr = erCallCenterr.merging(erCallCenterr5) { $1 }
            erCallCenterr = erCallCenterr.merging(erCallCenterr6) { $1 }
            let pars = ["_ER_PARMS": erParams,
                        "_ER_CALL_CENTERR": [erCallCenterr]] as [String : Any]
            print(pars)
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
                        Utilities.showAlert(messageToDisplay:self.successMSG)
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        if let nav = appDelegate.window!.rootViewController as? UINavigationController {
                            nav.popToViewController(nav.viewControllers[nav.viewControllers.count - 4], animated: true)
                        }
                    }else {
                        Utilities.showAlert(messageToDisplay: UserManager.isArabic ? ar ?? "UnKnown Error": en ?? "UnKnown Error")
                    }
                }
                if let code = root?["code"] as? Int {
                    if code == 1 {
                        Utilities.showAlert(messageToDisplay: self.successMSG)
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        if let nav = appDelegate.window!.rootViewController as? UINavigationController {
                            nav.popToViewController(nav.viewControllers[nav.viewControllers.count - 4], animated: true)
                        }
                    }else {
                        Utilities.showAlert(messageToDisplay: root?["message"] as? String ??  "UnKnown Error")
                    }
                }
               
            }
        }
        else
        {
            let birth = submitObject?.erCallCenterr?[0].DATE_OF_BIRTH?.ConvertToDate
            var years = Calendar.current.dateComponents([.month], from: birth ?? .init(), to: Date()).year
            years = submitObject?.erCallCenterr?[0].years
            var frm = submitObject?.erCallCenterr?[0].DATE_OF_BIRTH?.replacingOccurrences(of: "/", with: "-")
            frm = submitObject?.erCallCenterr?[0].DATE_OF_BIRTH_STR_FORMATED

            var pars = ["_ER_PARMS": ["BRANCH_ID":submitObject?.erParms?.branchID,"PROCESS_ID":submitObject?.erParms?.processID,"USER_ID":submitObject?.erParms?.userID,"COMPUTER_NAME":submitObject?.erParms?.computerName,"IN_OUT_CITY":submitObject?.erParms?.inOutCity],
                        "_ER_CALL_CENTERR":[["PAT_AGE":years,
                                            // "DATE_OF_BIRTH_STR_FORMATED":"01-01-1990 00:00:00",
                                             "DATE_OF_BIRTH_STR_FORMATED":frm,
                                           //  "DATE_OF_BIRTH":"01/01/1990 00:00:00",
                                             "DATE_OF_BIRTH":submitObject?.erCallCenterr?[0].DATE_OF_BIRTH,
                                             "BUILDING_COMPUTER_SERIAL":submitObject?.erCallCenterr?[0].AumotedNumber,"ADDRESS_BLOCK_DESC":submitObject?.erCallCenterr?[0].group,"BUILDING_NO":submitObject?.erCallCenterr?[0].bulidingNumber,"STREETNAME":submitObject?.erCallCenterr?[0].villageCode,"BUFFER_STATUS":submitObject?.erCallCenterr?[0].bufferStatus,"CALLAR_NAME":submitObject?.erCallCenterr?[0].callarName,"HOME_PHONE":submitObject?.erCallCenterr?[0].homePhone,"GOV_ID":submitObject?.erCallCenterr?[0].govID,"CITY_ID":submitObject?.erCallCenterr?[0].cityID,"VILLAGE_CODE":submitObject?.erCallCenterr?[0].villageCode,"ADDRESS":textfieldAutomated.text!,"NEW_REMARKS":submitObject?.erCallCenterr?[0].newRemarks,"CALL_TYPE":submitObject?.erCallCenterr?[0].callType,"HOME_VISIT_DOC_NEED": "0","AMBULANCE_DOC_NEED":"0","HOME_VISIT_NURSE_NEED": "1","AMBULANCE_NURSE_NEED":"0","AMBULANCE_CAR_TYPE":submitObject?.erCallCenterr?[0].ambulanceCarType,"CALL_PAT_TYPE":submitObject?.erCallCenterr?[0].callPatType,"PATIENT_ID":submitObject?.erCallCenterr?[0].patientID,"F_NAME_EN":submitObject?.erCallCenterr?[0].F_NAME,"S_NAME_EN":submitObject?.erCallCenterr?[0].S_NAME,"T_NAME_EN":submitObject?.erCallCenterr?[0].T_NAME,"L_NAME_EN":submitObject?.erCallCenterr?[0].L_NAME,"F_NAME":submitObject?.erCallCenterr?[0].F_NAME,"S_NAME":submitObject?.erCallCenterr?[0].S_NAME,"T_NAME":submitObject?.erCallCenterr?[0].T_NAME,"L_NAME":submitObject?.erCallCenterr?[0].L_NAME,"GENDER":submitObject?.erCallCenterr?[0].GENDER,"HOME_VISIT_CAR_TYPE":"1",
                                             "HOSP_ID": "1",]]


                      
            ] as [String : Any]
            print(pars)
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
                        Utilities.showAlert(messageToDisplay: self.successMSG)
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        if let nav = appDelegate.window!.rootViewController as? UINavigationController {
                            nav.popToViewController(nav.viewControllers[nav.viewControllers.count - 4], animated: true)
                        }
                    }else {
                        Utilities.showAlert(messageToDisplay: UserManager.isArabic ? ar ?? "UnKnown Error": en ?? "UnKnown Error")
                    }
                }
                if let code = root?["code"] as? Int {
                    if code == 1 {
                        Utilities.showAlert(messageToDisplay: self.successMSG)
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        if let nav = appDelegate.window!.rootViewController as? UINavigationController {
                            nav.popToViewController(nav.viewControllers[nav.viewControllers.count - 4], animated: true)
                        }
                    }else {
                        Utilities.showAlert(messageToDisplay: root?["message"] as? String ??  "UnKnown Error")
                    }
                }
            }
        }
       

//
//        }
       
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        if textField == textFieldBuilding
        {
            submitObject?.erCallCenterr?[0].bulidingNumber = textFieldBuilding.text ?? ""
        }
        
        if textField == textfieldAutomated
        {
            submitObject?.erCallCenterr?[0].AumotedNumber = textfieldAutomated.text ?? ""
        }
        if textField == textFieldA2sema
        {
            submitObject?.erCallCenterr?[0].A2sima = textFieldA2sema.text ?? ""
        }
        if textField == textFieldGroup
        {
            submitObject?.erCallCenterr?[0].group = textFieldGroup.text ?? ""
        }
        
    }
    
    
    func getdata() {
        listOfGov.removeAll()
        let urlString = Constants.APIProvider.get_govs_by_country+"SearchText=\("")&IndexTo=1000&IndexFrom=1"
        let url = URL(string: urlString)
//        let parseUrl = Constants.APIProvider.PatInvoices + Constants.getoAuthValue(url: url!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            
            if error == nil
            {
                 if let root = ((data as? [String: AnyObject])?["Root"] as? [String:AnyObject])?["GOV"] as? [String:AnyObject]
                {
                    
               
                    
                    if root["GOV_R"] is [[String:AnyObject]]
                    {
                    
                    let appoins = root["GOV_R"] as! [[String: AnyObject]]
                    for i in appoins
                    {
                        print(i)
                        self.listOfGov.append(GOV_RDTO(JSON: i)!)
                      
                        
                    }
                    }
                    else if root["GOV_R"] is [String:AnyObject]
                    {
                        self.listOfGov.append(GOV_RDTO(JSON:root["GOV_R"] as![String:AnyObject] )!)
                     
                        
                    }
                    
//                    self.uiLabelgov.text = UserManager.isArabic ? self.listOfGov[0].NAME_AR : self.listOfGov[0].NAME_EN
//                    print(self.listOfGov[0].NAME_EN)
//                    self.getdataCity(Id: self.listOfGov[0].ID)
//                    self.submitObject?.erCallCenterr?[0].govID = self.listOfGov[0].ID
//                     self.textfieldAutomated.text = "\(self.uiLabelgov.text ?? "") - "
                }
                else
                 {
                }
            }
  
            self.nc.post(name: Notification.Name("dataFound"), object: nil)
           
        }
        
    }

    func getdataCity(Id:String) {
        listOfCity.removeAll()

        let urlString = Constants.APIProvider.get_cities+"government=\(Id)&SearchText=\("")&IndexTo=1000&IndexFrom=1"
        let url = URL(string: urlString)
//        let parseUrl = Constants.APIProvider.PatInvoices + Constants.getoAuthValue(url: url!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            
            if error == nil
            {
                 if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["CITY"] as? [String:AnyObject]
                {
                    
               
                    
                    if root["CITY_R"] is [[String:AnyObject]]
                    {
                    
                    let appoins = root["CITY_R"] as! [[String: AnyObject]]
                    for i in appoins
                    {
                        print(i)
                        self.listOfCity.append(GOV_RDTO(JSON: i)!)
                      
                        
                    }
                    }
                    else if root["CITY_R"] is [String:AnyObject]
                    {
                        self.listOfCity.append(GOV_RDTO(JSON:root["CITY_R"] as![String:AnyObject] )!)
                     
                        
                    }
//                    self.uiLabelCity.text = UserManager.isArabic ? self.listOfCity[0].NAME_AR : self.listOfCity[0].NAME_EN
//                    self.getdataStreet(Id: self.listOfCity[0].ID)
//                    self.submitObject?.erCallCenterr?[0].cityID = self.listOfCity[0].ID
//                     self.textfieldAutomated.text! += "\(self.uiLabelCity.text ?? "") - "
                }
                else
                 {
                    self.uiLabelCity.text = UserManager.isArabic ? "No City Found" : "No City Found" 
                }
            }
            self.nc.post(name: Notification.Name("dataFound"), object: nil)

           
        }
    }
    
    func getdataStreet(Id:String) {
        listOfStreet.removeAll()

        let urlString = Constants.APIProvider.get_villages+"city=\(Id)&SearchText=\("")&IndexTo=1000&IndexFrom=1"
        let url = URL(string: urlString)
//        let parseUrl = Constants.APIProvider.PatInvoices + Constants.getoAuthValue(url: url!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            
            if error == nil
            {
                 if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["VILAGE"] as? [String:AnyObject]
                {
                    
               
                    
                    if root["VILAGE_R"] is [[String:AnyObject]]
                    {
                    
                    let appoins = root["VILAGE_R"] as! [[String: AnyObject]]
                    for i in appoins
                    {
                        print(i)
                        self.listOfStreet.append(GOV_RDTO(JSON: i)!)
                      
                        
                    }
                    }
                    else if root["VILAGE_R"] is [String:AnyObject]
                    {
                        self.listOfStreet.append(GOV_RDTO(JSON:root["VILAGE_R"] as![String:AnyObject] )!)
                     
                        
                    }
                    if self.listOfStreet.count > 0 {
                        
                        self.submitObject?.erCallCenterr?[0].address = self.listOfGov[0].NAME_EN + "" + self.listOfCity[0].NAME_EN + "" + self.listOfStreet[0].NAME_EN
                    self.uiLabelvillage.text = UserManager.isArabic ? self.listOfStreet[0].NAME_AR : self.listOfStreet[0].NAME_EN
                        
                        self.submitObject?.erCallCenterr?[0].villageCode = self.listOfStreet[0].ID
//                        self.textfieldAutomated.text! += "\(self.uiLabelvillage.text ?? "")"
                    }
                    else{
                        self.uiLabelvillage.text = UserManager.isArabic ? "No Street Found"  : "No Street Found"
                    }
                    
                }
                else
                 {
                    self.uiLabelvillage.text = UserManager.isArabic ? "No Street Found"  : "No Street Found"
                }
            }

           
        }
    

    }
}
extension PatientAddressViewController
{
    func listPopupDidSelect(index: Int, type: String) {
        if type == "gov"
        {
            uiLabelgov.text = UserManager.isArabic ? listOfGov[index].NAME_AR : listOfGov[index].NAME_EN
            print(listOfGov[index].NAME_EN)
            getdataCity(Id: listOfGov[index].ID)
            submitObject?.erCallCenterr?[0].govID = self.listOfGov[index].ID
            govText = UserManager.isArabic ? listOfGov[index].NAME_AR : listOfGov[index].NAME_EN
//            textfieldAutomated.text = "\(uiLabelgov.text ?? "") - "
            setTextInAutomatedTextField()
        }
        if type == "city"
        {
            print(listOfCity[index].NAME_EN)
            uiLabelCity.text = UserManager.isArabic ? listOfCity[index].NAME_AR : listOfCity[index].NAME_EN
            getdataStreet(Id:listOfCity[index].ID)
            submitObject?.erCallCenterr?[0].cityID = self.listOfCity[index].ID
//            textfieldAutomated.text! += "\(uiLabelCity.text ?? "") - "
            areaText = UserManager.isArabic ? listOfCity[index].NAME_AR : listOfCity[index].NAME_EN
            setTextInAutomatedTextField()
            
        }
        if type == "street"
        {
          
            uiLabelvillage.text = UserManager.isArabic ? listOfStreet[index].NAME_AR : listOfStreet[index].NAME_EN
            submitObject?.erCallCenterr?[0].villageCode = self.listOfStreet[index].ID
//            textfieldAutomated.text! += "\(uiLabelvillage.text ?? "")"
            streetText = UserManager.isArabic ? listOfStreet[index].NAME_AR : listOfStreet[index].NAME_EN
            setTextInAutomatedTextField()
        }
        
    }
}

extension PatientAddressViewController:popFromMap
{
    func popFromMapFRom(lat: Double, Lng: Double, Street: String) {
//        uitextFieldAddressText.text =  Street
        if lat != 0 && Lng != 0 {
            uitextFieldAddressText.rightViewMode = .never
            uitextFieldAddressText.rightView?.isHidden = true
        }
//        textfieldAutomated.text =  Street
    }
    
    
}
