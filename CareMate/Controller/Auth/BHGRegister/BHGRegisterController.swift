//
//  BHGRegisterController.swift
//  CareMate
//
//  Created by Ibrahim on 02/10/2025.
//  Copyright © 2025 khabeer Group. All rights reserved.
//

import UIKit
import CountryPickerView
import MZFormSheetController

class BHGRegisterController: UIViewController {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var txfConfirmPassword: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var txfConfirmEmail: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var stkPassword: UIStackView!
    @IBOutlet weak var txfMobile: UITextField!
    @IBOutlet weak var pickerCode: CountryPickerView!
    @IBOutlet weak var txfID: UITextField!
    
    private var showPassordPicker:Bool = false
    private var phoneCode:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        pickerCode.setCountryByName("Saudi Arabia")
        phoneCode = pickerCode.selectedCountry.phoneCode
        stkPassword.setView(hidden: true)
        // Do any additional setup after loading the view.
    }
    
    private func setLocalization() {
        txfID.textAlignment =  UserManager.isArabic ? .right:.left
        txfMobile.textAlignment =  UserManager.isArabic ? .right:.left
        txfEmail.textAlignment =  UserManager.isArabic ? .right:.left
        txfConfirmEmail.textAlignment =  UserManager.isArabic ? .right:.left
        txfPassword.textAlignment =  UserManager.isArabic ? .right:.left
        txfConfirmPassword.textAlignment =  UserManager.isArabic ? .right:.left
        let img = UIImage(named:  UserManager.isArabic ? "ic-backR":"ic-back")
        btnBack.setImage(img, for: .normal)
        btnSignIn.setTitle(UserManager.isArabic ? "إنشاء حساب جديد" : "Signup", for: .normal)
        txfConfirmPassword.placeholder = UserManager.isArabic ? "تآكيد كلمة المرور" : "Confirm Password"
        txfPassword.placeholder = UserManager.isArabic ?  "كلمة المرور" : "Password"
        txfConfirmEmail.placeholder = UserManager.isArabic ? "تآكيد البريد الالكتروني" : "Confirm Email"
        txfConfirmEmail.placeholder = UserManager.isArabic ? "البريد الالكتروني" : "Email"
        txfMobile.placeholder = UserManager.isArabic ? "رقم الجوال" : "Mobile Number"
        txfID.placeholder =  UserManager.isArabic ? "رقم الهوية/ رقم ملف طبي / رقم الاقامة":"Civil ID/Medical file ID/Residence ID"
    }

    @IBAction func passwordTapped(_ sender: Any) {
        txfPassword.isSecureTextEntry =  txfPassword.isSecureTextEntry ? false:true

    }
    
    @IBAction func confirmPasswordTapped(_ sender: Any) {
        txfConfirmPassword.isSecureTextEntry =  txfConfirmPassword.isSecureTextEntry ? false:true
    }
    
    @IBAction func backTapped(_ sender: Any) {
        if showPassordPicker {
            stkPassword.setView(hidden: true)
            txfID.isUserInteractionEnabled = true
            txfMobile.isUserInteractionEnabled = true
            showPassordPicker = false
        }else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func signTapped(_ sender: Any) {
        if showPassordPicker {
            secondRegister()
        }else {
           firstRegister()
        }
    }
    
    func firstRegister() {
        if !checkMobileValidate(txfMobile.text ?? "")  {
            Utilities.showAlert(messageToDisplay:UserManager.isArabic ? "من فضلك ادخل رقم هاتف صحيحا" : "Please Enter Valid Mobile Number")
            return
        }
        
        let enter = LanguageManager.isArabic() ? "ادخل ":"Enter "
        guard let id = self.txfID.text,
              !id.isEmpty else {
                Utilities.showAlert(messageToDisplay: enter + txfID.placeholder!)
                  return
              }
        
        guard let mobile = self.txfMobile.text,
              !mobile.isEmpty else {
                Utilities.showAlert(messageToDisplay: enter + txfMobile.placeholder!)
                  return
              }
            let pars = ["Mobile": "\(phoneCode)\(mobile)","detect_text":id,"init":"1"]
            let urlString = Constants.APIProvider.SignupFirst
            let url = URL(string: urlString)
            let parseUrl = Constants.APIProvider.Signup + Constants.getoAuthValue(url: url!, method: "POST")
            WebserviceMananger.sharedInstance.makeCall(method: .post, url: urlString, parameters: pars, vc: self) { (data, error) in
                var listOfOTher1 = [listOfTherPatient]()
                if let root = ((data as? [String: AnyObject] ?? [String: AnyObject]())["CODE"] as? [String:AnyObject]) {
                    print(root)
                }
                let json = data as! [String:Any]
                if let code = json["CODE"] {
                    if code as? String == "7431" {
                        OPEN_RESERVATION_AND_NO_SLOTS_POPUP(container: self, type: .register) {
        //                    self.navigationController?.popViewController(animated: true)
                        }
                    } else if code as? Int == 200 {
                        if (data as! [String: AnyObject])["ALREADY_REGISTERED_FLAG"] as! String == "1" {
                            OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "لديك ملف بالفعل في سجلات المستشفي لدينا, يمكنك الانتقال الي تسجيل الدخول, لمزيد من المعلومات يرجي الاتصال بنا" : "You have already registered on our hospital records, You can navigate to login, For more information please contact us")
                            return
                        }
                        if  json["MORE_THAN_ONE_PATIENT"] as! String == "1" {
                            if let root = ((data as! [String: AnyObject])["patients"] as! [String: AnyObject])["SELECT_PATIENT"] as? [String: AnyObject] {
                                if root["SELECT_PATIENT_ROW"] is [[String: AnyObject]] {
                                    let appoins = root["SELECT_PATIENT_ROW"] as! [[String: AnyObject]]
                                    for i in appoins {
                                        print(i)
                                        listOfOTher1.append(listOfTherPatient(JSON: i)!)
                                    }
                                } else if root["SELECT_PATIENT_ROW"] is [String:AnyObject] {
                                    listOfOTher1.append(listOfTherPatient(JSON:root["SELECT_PATIENT_ROW"] as![String:AnyObject] )!)
                                }
                            }
                            let vc1:verifcationAddOtherVC = verifcationAddOtherVC(PatientId: json["PATIENT_ID"] as? String, patientIdArray: nil, vcType: .fromReservation)
                            vc1.listOfOTher = listOfOTher1
                            vc1.mobileNumberReservsation = mobile
                            vc1.countryCode = self.phoneCode
                            self.navigationController?.pushViewController(vc1, animated: true)
                        } else {
                            if let root = ((data as? [String: AnyObject])?["Root"] as? [String: AnyObject])?["OUT_PARMS"] as? [String: AnyObject] {
                                if root["OUT_PARMS_ROW"] is [String: AnyObject] {
                                    let OUT_PARMS_ROW = root["OUT_PARMS_ROW"] as!  AnyObject
                                    if let PATIENT_ID = OUT_PARMS_ROW["PATIENT_ID"] as? String as? String {
                                        UserDefaults.standard.set(PATIENT_ID, forKey: "patienId")
                                        Utilities.sharedInstance.setPatientId(patienId: PATIENT_ID)
                                        if let PAT_TEL = OUT_PARMS_ROW["PAT_TEL"] as? String as? String {
                                            currentPatientMobile = PAT_TEL
                                        }
                                        self.stkPassword.setView(hidden: false)
                                        self.showPassordPicker = true
                                        self.txfID.isUserInteractionEnabled = false
                                        self.txfEmail.isUserInteractionEnabled = false
                                        
                                    } else{
                                        if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["MESSAGE"] as? [String:AnyObject] {
                                            let MESSAGE_ROW = root["MESSAGE_ROW"] as!  AnyObject
                                            Utilities.showAlert(messageToDisplay: MESSAGE_ROW[UserManager.isArabic ? "NAME_AR" : "NAME_EN"] as? String ?? "")
                                        }
                                    }
                                }
                            }
                            let vc = verifcationAddOtherVC(PatientId: json["PATIENT_ID"] as? String, patientIdArray: nil, vcType: .fromRetrive)
                            vc.mobileNumberReservsation = mobile
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    } else {
                        Utilities.showAlert(messageToDisplay: json[UserManager.isArabic ? "NAME_AR" : "NAME_EN"] as! String)
                    }
                } else {
                    let formSheet = MZFormSheetController.init(viewController: slotNot(messageAr: " عذرًا ، البيانات المدخلة لا تتطابق مع سجلاتنا ، لمزيد من المعلومات يرجى الاتصال بنا او مراسلاتنا بالبريد الإلكتروني", MessageEn:  "Sorry, the Entered data does not match our records, for more information please contact us By Calling on "))
                    formSheet.shouldDismissOnBackgroundViewTap = true
                    formSheet.transitionStyle = .slideFromBottom
                    formSheet.presentedFormSheetSize = CGSize.init(width: UIScreen.main.bounds.width * 0.9, height: 380)
                    formSheet.shouldCenterVertically = true
                    formSheet.present(animated: true, completionHandler: nil)
                    Utilities.showAlert(messageToDisplay:"  24997000 OR By Email: \(ConstantsData.email)")
                }
            }
    }
    
    func secondRegister() {
        
        let enter = LanguageManager.isArabic() ? "ادخل ":"Enter "
        guard let email = self.txfEmail.text,
              !email.isEmpty else {
            Utilities.showAlert(messageToDisplay: enter + txfEmail.placeholder!)
            return
        }
        
        guard let confirmEmail = self.txfConfirmEmail.text,
              !confirmEmail.isEmpty else {
            Utilities.showAlert(messageToDisplay: enter + txfConfirmEmail.placeholder!)
            return
        }
        
        guard let password = self.txfPassword.text,
              !password.isEmpty else {
            Utilities.showAlert(messageToDisplay: enter + txfPassword.placeholder!)
            return
        }
        
        guard let confirmPassword = self.txfConfirmPassword.text,
              !confirmPassword.isEmpty else {
            Utilities.showAlert(messageToDisplay: enter + txfConfirmPassword.placeholder!)
            return
        }
        
        if password != confirmPassword {
            let msg = LanguageManager.isArabic()  ? "كلمة المرور غير متطابقة":"Password isn't match"
            Utilities.showAlert(messageToDisplay: msg)
            return
        }
        if email != confirmEmail {
            let msg = LanguageManager.isArabic()  ? "البريد الالكتروني غير متطابق":"Email isn't match"
            Utilities.showAlert(messageToDisplay: enter + txfConfirmPassword.placeholder!)
            return
        }
        let tokeen = UserDefaults.standard.object(forKey: "pushToken") as? String ?? ""
        let pars = ["PASSWORD": password,
                    "email_address":email,
                    "MOBILEAPP_KEY":tokeen,
                    "MOBILEAPP_TYPE":"2",
                    "detect_text":Utilities.sharedInstance.getPatientId(),
                    "init":"0"]
        let urlString = Constants.APIProvider.SignupSecond
        let url = URL(string: urlString)
        let parseUrl = Constants.APIProvider.Signup + Constants.getoAuthValue(url: url!, method: "POST")
        WebserviceMananger.sharedInstance.makeCall(method: .post, url: urlString, parameters: pars, vc: self) { (data, error) in
            var listOfOTher1 = [listOfTherPatient]()
            if let root = ((data as? [String: AnyObject] ?? [String: AnyObject]())["CODE"] as? [String:AnyObject]) {
                print(root)
            }
            let json = data as! [String:Any]
            if let code = json["CODE"] {
                if code as? String == "7431" {
                    OPEN_RESERVATION_AND_NO_SLOTS_POPUP(container: self, type: .register) {
                    }
                } else if code as? Int == 200 {
                    if (data as! [String: AnyObject])["ALREADY_REGISTERED_FLAG"] as! String == "1" {
                        OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "لديك ملف بالفعل في سجلات المستشفي لدينا, يمكنك الانتقال الي تسجيل الدخول, لمزيد من المعلومات يرجي الاتصال بنا" : "You have already registered on our hospital records, You can navigate to login, For more information please contact us")
                        return
                    }else {
                        let vc = verifcationAddOtherVC(PatientId: json["PATIENT_ID"] as? String, patientIdArray: nil, vcType: .fromRetrive)
                        vc.mobileNumberReservsation = email
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                } else {
                    let formSheet = MZFormSheetController.init(viewController: slotNot(messageAr: " عذرًا ، البيانات المدخلة لا تتطابق مع سجلاتنا ، لمزيد من المعلومات يرجى الاتصال بنا او مراسلاتنا بالبريد الإلكتروني", MessageEn:  "Sorry, the Entered data does not match our records, for more information please contact us By Calling on "))
                    formSheet.shouldDismissOnBackgroundViewTap = true
                    formSheet.transitionStyle = .slideFromBottom
                    formSheet.presentedFormSheetSize = CGSize.init(width: UIScreen.main.bounds.width * 0.9, height: 380)
                    formSheet.shouldCenterVertically = true
                    formSheet.present(animated: true, completionHandler: nil)
                    Utilities.showAlert(messageToDisplay:"  24997000 OR By Email: \(ConstantsData.email)")
                }
            }
        }
    }


    
}
