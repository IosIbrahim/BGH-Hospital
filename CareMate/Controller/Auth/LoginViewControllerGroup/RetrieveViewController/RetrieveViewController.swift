//
//  RetrieveViewController.swift
//  CareMate
//
//  Created by Mohammed Sami on 10/10/18.
//  Copyright © 2018 khabeer Group. All rights reserved.
//

import UIKit
import PopupDialog
import CountryPickerView
import JNPhoneNumberView

enum reservationOfForget {
    case fromReservation
    case fromRetrive
}

enum RetrieveType: Int {
    case password, medicalCode
}

class RetrieveViewController: BaseViewController, resendCodeDelgate {
    
    @IBOutlet weak var txfID: UITextField!
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var labelHint: UILabel!
    @IBOutlet weak var imageViewPhone: UIImageView!
    @IBOutlet weak var medicalCodeTextField: UITextField!
    @IBOutlet weak var labelMobileNumber: UILabel!
    @IBOutlet weak var viewMobile: UIView!
    @IBOutlet weak var viewCountry: CountryPickerView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var labelPrefix: UILabel!
    
    var titleAr = ""
    var TileEn = ""
    var vcType: reservationOfForget?
    var patientID = ""
    var retrieveType: RetrieveType = .password
    var search = false
    var SSNBool = false
    var medicalIdBool = true
    var passportBool  = false
    var phoneCode  = ""
    var selectedCountry: Country?
    var phoneNumber = ""
    var fromGuest = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        medicalCodeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        viewCountry.setCountryByName("Saudi Arabia")
        selectedCountry = viewCountry.selectedCountry
        phoneCode = viewCountry.selectedCountry.phoneCode
        viewCountry.delegate = self
        viewMobile.setShadowLight()
        if UserManager.isArabic {
            labelMobileNumber.text = "رقم الهاتف النقال"
            btnSubmit.setTitle("ارسال كود التحقيق", for: .normal)
        }
        if search == true{
            imageViewPhone.image = UIImage.init(named: "calendar-svgrepo-com")
            initHeader(isNotifcation: false, isLanguage: false, title: UserManager.isArabic ? "إستعلام عن المواعيد" : "Appointment Inquiry" , hideBack: false)
            labelMobileNumber.text = UserManager.isArabic ? "الرجاء إدخال رقم الهاتف الذي تم تسجيله عند حجز الموعد" : "Please enter the phone number registered when booking the appointment"
        } else {
            initHeader(isNotifcation: false, isLanguage: false, title: UserManager.isArabic ? "استرجاع كلمة المرور" : "Forgot Password" , hideBack: false)
        }
        txfID.placeholder = UserManager.isArabic ? "رقم الهوية/ رقم ملف طبي / رقم الاقامة":"Civil ID/Medical file ID/Residence ID"
        lblID.text = txfID.placeholder
        
        if UserManager.isArabic {
            medicalCodeTextField.placeholder = "الرجاء إدخال رقم الهاتف النقال"
            viewMobile.transform = CGAffineTransform(scaleX: -1, y: 1)
            viewCountry.transform = CGAffineTransform(scaleX: -1, y: 1)
            labelPrefix.transform = CGAffineTransform(scaleX: -1, y: 1)
            medicalCodeTextField.transform = CGAffineTransform(scaleX: -1, y: 1)
            medicalCodeTextField.textAlignment = .left
            viewCountry.initWithArabic()
            labelHint.text = " الرجاء إكمال رقم هاتفك المحمول أدناه للحصول على كلمة المرور لمرة واحدة وإكمال عملية التحقق"
            lblID.textAlignment = .right
            txfID.textAlignment = .right
            
        } else {
            medicalCodeTextField.placeholder = "Please enter your Mobile Number"
            labelHint.text = "Please complete your mobile number below to receive the OTP and complete the verification process"
            lblID.textAlignment = .left
            txfID.textAlignment = .left
        }
        if retrieveType == .medicalCode {
            if UserManager.isArabic {
                medicalCodeTextField.placeholder = "الرجاء ادخال رقم الهاتف"
            } else {
                medicalCodeTextField.placeholder = "Please Enter Mobile Number"
            }
        } else {
            if UserManager.isArabic {
                medicalCodeTextField.placeholder = "الرجاء ادخال رقم الهاتف"
            } else {
                medicalCodeTextField.placeholder = "Please Enter Mobile Number"
            }
        }
        if #available(iOS 11.0, *) {
            medicalCodeTextField.smartInsertDeleteType = .no
        }
        medicalCodeTextField.autocorrectionType = .yes
        medicalCodeTextField.textContentType = UITextContentType.telephoneNumber
        medicalCodeTextField.keyboardType = .asciiCapableNumberPad
        if phoneNumber.count > 5 {
            labelPrefix.text = String(phoneNumber.prefix(3))
            var asteriks = ""
            for _ in 0...(phoneNumber.count - 4) {
                asteriks += "* "
            }
            medicalCodeTextField.placeholder = asteriks
        } else {
            labelPrefix.isHidden = true
            labelPrefix.text = ""
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        //FIXed by HAMDIIIIII ....
        let lenth = 8 - (labelPrefix.text?.count ?? 0)
        medicalCodeTextField.text = String(textField.text!.prefix(lenth))
        
    }
    
    func resendCode() {
        indicator.sharedInstance.show()
        let pars = ["PATIENT_ID":patientID] as [String : String]
        let urlString = Constants.APIProvider.VERIFYPATIENTID
        let url = URL(string: urlString)
        let parseUrl = Constants.APIProvider.VERIFYPATIENTID + "?" + Constants.getoAuthValue(url: url!, method: "POST",parameters: nil)
        WebserviceMananger.sharedInstance.makeCall(method: .post, url: parseUrl, parameters: pars, vc: self) { (data, error) in
            let root = (data as! [String:AnyObject])
            print(root)
            print(root["Code"])
            print(type(of: root["Code"]))
            let Code = root["Code"] as? Int
            if Code == 200 {
                let vc:verifcationAddOtherVC = verifcationAddOtherVC(PatientId: self.patientID, patientIdArray: nil,vcType:.fromRetrive)
                vc.mobileNumber = self.phoneNumber
                vc.PATIENT_ID = self.patientID
                vc.fromForget = true
                vc.fromGuest = self.fromGuest
                self.navigationController?.pushViewController(vc, animated: true)
            } else if Code == 108 {
                
            }
            let vc:verifcationAddOtherVC = verifcationAddOtherVC(PatientId: self.patientID, patientIdArray: nil, vcType: .fromRetrive)
            vc.PATIENT_ID = self.patientID
            vc.delegate = self
            vc.fromForget = true
            vc.mobileNumber = self.phoneNumber
            vc.fromGuest = self.fromGuest
            self.navigationController?.pushViewController(vc,animated: true)
            if root.keys.contains("MESSAGE") {
                let loginStatus = (((((data as! [String: Any])["Root"])as! [String: Any])["MESSAGE"] as! [String:Any])["MESSAGE_ROW"] as! [String: Any])["NAME_EN"] as! String
                Utilities.showAlert(messageToDisplay:loginStatus)
            }
        }
    }
    
    func resendCodeLogin(mobileNumber: String) {
    
    }
    
    @objc func SNNCliked(sender : UITapGestureRecognizer) {
        SSNBool = true
        medicalIdBool = false
        passportBool = false
        medicalCodeTextField.placeholder = "Enter CiVil ID "
    }
    
    @objc func medicalIdCliked(sender : UITapGestureRecognizer) {
        SSNBool = false
        medicalIdBool = true
        passportBool = false
        medicalCodeTextField.placeholder = "Enter Medical Record Number"
    }
    
    @objc func passportCliked(sender : UITapGestureRecognizer) {
        SSNBool = false
        medicalIdBool = false
        passportBool = true
        medicalCodeTextField.placeholder = "Enter  Passport"
    }
    
    @IBAction func didPressOkButton(sender: Any) {
        if phoneNumber.count > 5 {
            let phoneNumber = "\(labelPrefix.text ?? "")\(medicalCodeTextField.text ?? "")"
            if phoneNumber != self.phoneNumber {
                OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "الرجاء التأكد من إدخال الرقم الصحيح" : "Please make sure that you enter the correct number")
                return
            }
        } else {
            phoneNumber = medicalCodeTextField.text!
        }
        patientID = phoneNumber
        indicator.sharedInstance.show()
        if vcType == .fromRetrive {
            sendCode()
        } else {
            sendCodeReservation()
        }
    }
    
    func sendCode()
    {
        guard let medicalId = self.medicalCodeTextField.text,
              !medicalId.isEmpty else {
                  Utilities.showAlert(messageToDisplay: UserManager.isArabic ? "من فضلك اكتب رقم الهاتف" : "Please enter phone uumber")
                  return
              }
        let enter = UserManager.isArabic ? "من فضلك ادخل " : "Please enter "
        guard let id = self.txfID.text,
              !id.isEmpty else {
                Utilities.showAlert(messageToDisplay: enter + lblID.text!)
                  return
              }
        indicator.sharedInstance.show()
        
        var pars : [String : String]?
        if retrieveType == .password {
            pars = ["MOBILE":"\(phoneCode)\(phoneNumber)"] as [String : String]
        }else {
            pars = ["MOBILE":"\(phoneNumber)","MOBILE_COUNTERY_CODE": "\(phoneCode)","detect_text":id] as [String : String]

        }
        let urlString = Constants.APIProvider.VERIFYPATIENTID
        print(urlString)
        let url = URL(string: urlString)
        let parseUrl = Constants.APIProvider.VERIFYPATIENTID + "?" + Constants.getoAuthValue(url: url!, method: "POST",parameters: nil)
        WebserviceMananger.sharedInstance.makeCall(method: .post, url: parseUrl, parameters: pars, vc: self) { (data, error) in
            let root = (data as! [String:AnyObject])
            
            print(root)
            print(root["Root"])
            print(type(of: root["Code"]))
            let Code = (((root["Root"] as? [String: AnyObject])?["MESSAGE"] as? [String: AnyObject])?["MESSAGE_ROW"] as? [String: AnyObject])?["CODE"] as? String ?? ""
            if Code == "6849" {
                OPEN_RESERVATION_AND_NO_SLOTS_POPUP(container: self, type: .forgotPassword) {
//                    self.navigationController?.popViewController(animated: true)
                }
                return
            }
            if let patientId = root["PATIENT_ID"]  as? String
            {
                
                let vc:verifcationAddOtherVC = verifcationAddOtherVC(PatientId: patientId, patientIdArray: nil, vcType: .fromRetrive)
                vc.fromForget = true
                vc.mobileNumber = self.phoneNumber
                vc.fromGuest = self.fromGuest
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
            else if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["MESSAGE"] as? [String:AnyObject]
            {
                
                
                if root["MESSAGE_ROW"] is [String:AnyObject]
                    
                {
                    let OUT_PARMS_ROW = root["MESSAGE_ROW"] as!  AnyObject
                    
                    
                    if let NAME_EN = OUT_PARMS_ROW["NAME_EN"] as? String as? String {
                        Utilities.showAlert(messageToDisplay:NAME_EN)
                        
                        
                    }
                    
                }
                
            }
            
            else
            {
                
                if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["OUT_PARMS"] as? [String:AnyObject]
                {
                    
                    
                    
                    if root["OUT_PARMS_ROW"] is [String:AnyObject]
                        
                    {
                        let OUT_PARMS_ROW = root["OUT_PARMS_ROW"] as!  AnyObject
                        
                        if let PATIENT_ID = OUT_PARMS_ROW["PATIENT_ID_ARRAY"] as? String as? String {
                            
                            if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["SELECT_PATIENT"] as? [String:AnyObject]
                            {
                                
                                var listOfOTher1 = [listOfTherPatient]()
                                
                                if root["SELECT_PATIENT_ROW"] is [[String:AnyObject]]
                                {
                                    
                                    let appoins = root["SELECT_PATIENT_ROW"] as! [[String: AnyObject]]
                                    
                                    print(appoins)
                                    for i in appoins
                                    {
                                        print(i)
                                        listOfOTher1.append(listOfTherPatient(JSON: i)!)
                                        
                                        
                                    }
                                }
                                else if root["SELECT_PATIENT_ROW"] is [String:AnyObject]
                                {
                                    listOfOTher1.append(listOfTherPatient(JSON:root["SELECT_PATIENT_ROW"] as![String:AnyObject] )!)
                                    
                                }
                                
                                let vc:LitsOfPatientLogedBySameMobileNumberViewController = LitsOfPatientLogedBySameMobileNumberViewController(listOfOthers: listOfOTher1, VcType: .fromretrive)
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                            }
                        }
                    }
                }
            }
            
            
        }
    }
    
    func sendCodeReservation() {
        guard let medicalId = self.medicalCodeTextField.text,
              !medicalId.isEmpty else {
                  Utilities.showAlert(messageToDisplay: UserManager.isArabic ? "من فضلك اكتب رقم الهاتف" : "Please enter phone uumber")
                  return
              }
        indicator.sharedInstance.show()
        var pars : [String : Any]?
        pars = ["mobile": "\(phoneNumber)", "STATUS":"1","verify_text": nil, "MOBILE_COUNTERY_CODE": "\(phoneCode)"] as [String:Any]
        let urlString = Constants.APIProvider.verifyQuestNumber
        print(urlString)
        let url = URL(string: urlString)
        let parseUrl = Constants.APIProvider.verifyQuestNumber + "?" + Constants.getoAuthValue(url: url!, method: "POST",parameters: nil)
        WebserviceMananger.sharedInstance.makeCall(method: .post, url: parseUrl, parameters: pars, vc: self) { (data, error) in
            let root = (data as! [String:AnyObject])
            print(root)
            print("root[Rootmostafa mostafa mostafa]")
            print( root["CODE"] )
            let Code = root["CODE"] as? Int
            if root["NAME_EN"] as? String ?? "" == "OK" || Code == 1 || Code == 200{
                let vc:verifcationAddOtherVC = verifcationAddOtherVC(PatientId: self.medicalCodeTextField.text ?? "", patientIdArray: nil, vcType: .fromReservation)
                vc.fromForget = true
                vc.mobileNumberReservsation = root["PAT_TEL"] as! String
                vc.phoneNumber = self.phoneNumber
                vc.countryCode = self.phoneCode
                vc.fromGuest = self.fromGuest
                self.navigationController?.pushViewController(vc, animated: true)
            }
            if root.keys.contains("OUT_PARMS") {
                let messageRow = (root["OUT_PARMS"] as! [String: AnyObject])["OUT_PARMS_ROW"] as! [String : AnyObject]
                let vc:verifcationAddOtherVC = verifcationAddOtherVC(PatientId: self.phoneNumber, patientIdArray: nil, vcType: .fromReservation)
                vc.fromForget = true
                self.fromGuest = self.fromGuest
                vc.mobileNumberReservsation =  messageRow["PAT_TEL"] as! String
                self.navigationController?.pushViewController(vc, animated: true)
            }
            if root.keys.contains("MESSAGE") {
                let loginStatus = (((((data as! [String: Any])["Root"])as! [String: Any])["MESSAGE"] as! [String:Any])["MESSAGE_ROW"] as! [String: Any])["NAME_EN"] as! String
                Utilities.showAlert(messageToDisplay:loginStatus)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "code"
        {
            let vc  = segue.destination as! EnterCodeController
            vc.patientID = patientID
        }
    }
    func presentAlertController(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        alertController.view.tintColor = .green
        present(alertController, animated: true, completion: nil)
    }
}
extension RetrieveViewController:fromChangePass
{
    func chnagePassword() {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
}
extension RetrieveViewController:CountryPickerViewDelegate
{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.phoneCode =  country.phoneCode
        selectedCountry = country
    }
    
    
}

