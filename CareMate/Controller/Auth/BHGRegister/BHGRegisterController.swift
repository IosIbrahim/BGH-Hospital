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

class BHGRegisterController: BaseViewController {
    
    @IBOutlet weak var pickerPhone: RoundUIView!
    @IBOutlet weak var pickerID: RoundUIView!
    @IBOutlet weak var PickerEmail: RoundUIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var txfConfirmPassword: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var stkPassword: UIStackView!
    @IBOutlet weak var txfMobile: UITextField!
    @IBOutlet weak var pickerCode: CountryPickerView!
    @IBOutlet weak var txfID: UITextField!
    
    private var showEmail:Bool = false
    private var showPassordPicker:Bool = false
    private var phoneCode:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        pickerCode.setCountryByName("Saudi Arabia")
        phoneCode = pickerCode.selectedCountry.phoneCode
        stkPassword.setView(hidden: true)
        PickerEmail.setView(hidden: true)

        // Do any additional setup after loading the view.
    }
    
    private func setLocalization() {
        txfID.textAlignment =  UserManager.isArabic ? .right:.left
        txfMobile.textAlignment =  UserManager.isArabic ? .right:.left
        txfEmail.textAlignment =  UserManager.isArabic ? .right:.left
        txfPassword.textAlignment =  UserManager.isArabic ? .right:.left
        txfConfirmPassword.textAlignment =  UserManager.isArabic ? .right:.left
        let img = UIImage(named:  UserManager.isArabic ? "ic-backR":"ic-back")
        btnBack.setImage(img, for: .normal)
        btnSignIn.setTitle(UserManager.isArabic ? "إنشاء حساب جديد" : "Signup", for: .normal)
        txfConfirmPassword.placeholder = UserManager.isArabic ? "تآكيد كلمة المرور" : "Confirm Password"
        txfPassword.placeholder = UserManager.isArabic ?  "كلمة المرور" : "Password"
        txfEmail.placeholder = UserManager.isArabic ? "البريد الاليكتروني" : "Email"
        txfMobile.placeholder = UserManager.isArabic ? "رقم الجوال" : "Mobile Number"
        txfID.placeholder =  UserManager.isArabic ? "رقم الهوية/ رقم ملف طبي / رقم الاقامة":"Civil ID/Medical file ID/Residence ID"
        
        if UserManager.isArabic {
//            pickerPhone.transform = CGAffineTransform(scaleX: -1, y: 1)
//            pickerCode.transform = CGAffineTransform(scaleX: -1, y: 1)
//            pickerCode.initWithArabic()
            
            pickerPhone.transform = CGAffineTransform(scaleX: -1, y: 1)
            pickerCode.transform = CGAffineTransform(scaleX: -1, y: 1)
            txfMobile.transform = CGAffineTransform(scaleX: -1, y: 1)
            txfMobile.textAlignment = .left
            pickerCode.initWithArabic()
        }
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
            showPassordPicker = false
            PickerEmail.setView(hidden: false)
        }else if showEmail {
            stkPassword.setView(hidden: true)
            PickerEmail.setView(hidden: true)
            pickerID.setView(hidden: false)
            pickerPhone.setView(hidden: false)
            txfID.isUserInteractionEnabled = true
            txfMobile.isUserInteractionEnabled = true
            showEmail = false
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func signTapped(_ sender: Any) {
        if showPassordPicker {
            sendPassword()
        }else if showEmail {
            showEmail = false
            sendEmail()
        } else {
            sendIDPhone()
        }
    }
    
    func setdataFound() {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("dataFound"), object: nil)
    }
    
    func sendIDPhone() {
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
            WebserviceMananger.sharedInstance.makeCall(method: .post, url: urlString, parameters: pars, vc: self) { (data, error) in
                if let root = ((data as? [String: AnyObject] ?? [String: AnyObject]())["CODE"] as? [String:AnyObject]) {
                    print(root)
                }
                let json = data as! [String:Any]
                if let code = json["CODE"] as? Int {
                     if code == 200 || code == 5 {
                        if (data as! [String: AnyObject])["ALREADY_REGISTERED_FLAG"] as! String == "1" {
                            OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "لديك ملف بالفعل في سجلات المستشفي لدينا, يمكنك الانتقال الي تسجيل الدخول, لمزيد من المعلومات يرجي الاتصال بنا" : "You have already registered on our hospital records, You can navigate to login, For more information please contact us")
                            self.setdataFound()
                            return
                        }else {
                            if code  != 5 {
                                let json = data as? [String:AnyObject]
                                let id = json?["PATIENT_ID"] as? String ?? ""
                                print(id)
                                currentPatientIDOrigni =  id
                                Utilities.sharedInstance.setPatientId(patienId: id)
                                currentPatientMobile =  json?["PAT_TEL"] as? String ?? ""
                                UserDefaults.standard.set(id, forKey: "patientIdWithSpaces")
                                UserDefaults.standard.set(json?["PAT_TEL"] as? String ?? "", forKey: "PAT_TEL")
                                self.PickerEmail.setView(hidden: false)
                                self.pickerID.setView(hidden: true)
                                self.pickerPhone.setView(hidden: true)
                            }else {
                                currentPatientMobile = "\(self.phoneCode)\(mobile)"
                            }
                           
                            self.showEmail = true
                            self.txfID.isUserInteractionEnabled = false
                            self.txfMobile.isUserInteractionEnabled = false
                        }
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
    
    func sendEmail() {
        
        let enter = LanguageManager.isArabic() ? "ادخل ":"Enter "
        guard let email = self.txfEmail.text,
              !email.isEmpty else {
            Utilities.showAlert(messageToDisplay: enter + txfEmail.placeholder!)
            return
        }
        guard let mobile = self.txfMobile.text,
              !mobile.isEmpty else {
                  return
              }
        
        sendEmailSession(email.replacingOccurrences(of: "@", with: "%40"), mobile: currentPatientMobile.replacingOccurrences(of: "+", with: "%2B"))
        return
        let pars = ["email_address":email,
                    "mobile": currentPatientMobile,
                    "init":"0"]
        let urlString = Constants.APIProvider.SignupSecond
        WebserviceMananger.sharedInstance.makeCall(method: .post, url: urlString, parameters: pars, vc: self,showIndicator: !showEmail) { (data, error) in
            self.setdataFound()
            if let root = ((data as? [String: AnyObject] ?? [String: AnyObject]())["CODE"] as? [String:AnyObject]) {
                print(root)
            }
            let json = data as! [String:Any]
            if let code = json["CODE"] {
                 if code as? Int == 200 {
                    if (data as! [String: AnyObject])["ALREADY_REGISTERED_FLAG"] as! String == "1" {
                        OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "لديك ملف بالفعل في سجلات المستشفي لدينا, يمكنك الانتقال الي تسجيل الدخول, لمزيد من المعلومات يرجي الاتصال بنا" : "You have already registered on our hospital records, You can navigate to login, For more information please contact us")
                        return
                    }else {
                        if self.showEmail {
                            print("Code Resended Again")
                        }else {
                            self.showEmail = true
                            let vc = verifcationAddOtherVC(PatientId: json["PATIENT_ID"] as? String, patientIdArray: nil, vcType: .fromRetrive)
                            vc.mobileNumberReservsation = email
                            vc.delegate = self
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                       
                    }
                    
                }
            }else {
                
            }
        }
    }
    
    func sendEmailSession(_ email:String,mobile:String) {
        let parameters = "init=0&email_address=\(email)&mobile=\(mobile)"
        let postData =  parameters.data(using: .utf8)
        let urlString = Constants.APIProvider.SignupSecond
        var request = URLRequest(url: URL(string: urlString)!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData
        if !showEmail {
            indicator.sharedInstance.show()
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async() {
                indicator.sharedInstance.dismiss()
            }
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary ?? .init()
            if let code = json?["CODE"] {
                 if code as? Int == 200 {
                    if json?["ALREADY_REGISTERED_FLAG"] as? String == "1" {
                        DispatchQueue.main.async() {
                            OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "لديك ملف بالفعل في سجلات المستشفي لدينا, يمكنك الانتقال الي تسجيل الدخول, لمزيد من المعلومات يرجي الاتصال بنا" : "You have already registered on our hospital records, You can navigate to login, For more information please contact us")
                        }
                        return
                    }else {
                        if self.showEmail {
                            print("Code Resended Again")
                        }else {
                            DispatchQueue.main.async() {
                                self.showEmail = true
                                let vc = verifcationAddOtherVC(PatientId: json?["PATIENT_ID"] as? String, patientIdArray: nil, vcType: .fromRetrive)
                                vc.mobileNumberReservsation = email
                                vc.delegate = self
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                       
                    }
                    
                 }else {
                     DispatchQueue.main.async() {
                         let formSheet = MZFormSheetController.init(viewController: slotNot(messageAr: " عذرًا ، البيانات المدخلة لا تتطابق مع سجلاتنا ، لمزيد من المعلومات يرجى الاتصال بنا او مراسلاتنا بالبريد الإلكتروني", MessageEn:  "Sorry, the Entered data does not match our records, for more information please contact us By Calling on "))
                         formSheet.shouldDismissOnBackgroundViewTap = true
                         formSheet.transitionStyle = .slideFromBottom
                         formSheet.presentedFormSheetSize = CGSize.init(width: UIScreen.main.bounds.width * 0.9, height: 380)
                         formSheet.shouldCenterVertically = true
                         formSheet.present(animated: true, completionHandler: nil)
                         Utilities.showAlert(messageToDisplay:"\(ConstantsData.mobile) - \(ConstantsData.mobile1) OR By Email: \(ConstantsData.email)")
                     }
                 }
            }
            self.showEmail = true
        }

        task.resume()

    }
    
    func sendPassword() {
        
        let enter = LanguageManager.isArabic() ? "ادخل ":"Enter "
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
    
        let tokeen = UserDefaults.standard.object(forKey: "pushToken") as? String ?? ""
        let pars = ["PASSWORD": password,
                    "MOBILEAPP_KEY":tokeen,
                    "MOBILEAPP_TYPE":"2",
                    "detect_text":Utilities.sharedInstance.getPatientId(),
                    "init":"0"]
        let urlString = Constants.APIProvider.SignupSecond
        let url = URL(string: urlString)
        WebserviceMananger.sharedInstance.makeCall(method: .post, url: urlString, parameters: pars, vc: self) { (data, error) in
            self.setdataFound()
            var listOfOTher1 = [listOfTherPatient]()
            if let root = ((data as? [String: AnyObject] ?? [String: AnyObject]())["CODE"] as? [String:AnyObject]) {
                print(root)
            }
            let json = data as! [String:Any]
            if let code = json["CODE"] {
                 if code as? Int == 200 {
                    if (data as! [String: AnyObject])["ALREADY_REGISTERED_FLAG"] as! String == "1" {
                        OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "لديك ملف بالفعل في سجلات المستشفي لدينا, يمكنك الانتقال الي تسجيل الدخول, لمزيد من المعلومات يرجي الاتصال بنا" : "You have already registered on our hospital records, You can navigate to login, For more information please contact us")
                        return
                    }else {
                        OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "لديك ملف بالفعل في سجلات المستشفي لدينا, يمكنك الانتقال الي تسجيل الدخول, لمزيد من المعلومات يرجي الاتصال بنا" : "You have already registered on our hospital records, You can navigate to login, For more information please contact us")
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

extension BHGRegisterController : resendCodeDelgate {
    func resendCode() {
        sendEmail()
    }
    
    func resendCodeLogin(mobileNumber:String){
        
    }
}
