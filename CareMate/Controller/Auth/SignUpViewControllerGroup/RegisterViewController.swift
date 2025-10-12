//
//  RegisterViewController.swift
//  CareMate
//
//  Created by Eng Nour Hegazy on 11/19/17.
//  Copyright © 2017 khabeer Group. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PopupDialog
import MZFormSheetController
import CountryPickerView
import JNPhoneNumberView

class RegisterViewController: BaseViewController {
    @IBOutlet weak var LabelTop: UILabel!
    @IBOutlet weak var termsContion: UILabel!
    @IBOutlet weak var acceptLabel: UILabel!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var nationalId: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var agreegation: UIView!
    @IBOutlet weak var viewRemberme: UIView!
    @IBOutlet weak var viewSignUp: UIView!
    @IBOutlet weak var termsConditionsImage: UIImageView!
    @IBOutlet weak var viewMobileNumber: UIView!
    @IBOutlet weak var viewNationalNumber: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    @IBOutlet weak var labelSNN: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var viewCountry: CountryPickerView!
    @IBOutlet weak var viewPhoneHolder: UIView!
    @IBOutlet weak var labelPrivacy: UILabel!
    @IBOutlet weak var viewPolicy: UIView!
    @IBOutlet weak var imageViewpolicy: UIImageView!
    @IBOutlet weak var labelPloictTitle: UILabel!
    
    var agreeDisAgree =  false
    var phoneCode = ""
    var selectedCountry: Country?
    var policyAccepted = false
    
    override func viewDidLoad() {
      super.viewDidLoad()
        initHeader(isNotifcation: false, isLanguage: true, title: UserManager.isArabic ? "إنشاء حساب جديد" : "Sign Up ", hideBack: false)
        if #available(iOS 11.0, *) {
            mobileTextField.smartInsertDeleteType = .no
        }
        mobileTextField.autocorrectionType = .yes
//        mobileNumberTextField.keyboardType = .numberPad
        mobileTextField.textContentType = UITextContentType.telephoneNumber
        mobileTextField.keyboardType = .asciiCapableNumberPad
        self.title = UserManager.isArabic ? "إنشاء حساب جديد" : "Signup"
        if UserManager.isArabic {
            labelPhoneNumber.text = "رقم الجوال"
            labelSNN.text = "الرقم المدني"
            labelEmail.text = "البريد الالكتروني"
            signUpLabel.text = "إنشاء حساب جديد"
        }
        let gestureRemberMe = UITapGestureRecognizer(target: self, action:  #selector(self.remberMeCliked))
        self.viewRemberme.addGestureRecognizer(gestureRemberMe)
        
        let gestureviewSignUp = UITapGestureRecognizer(target: self, action:  #selector(self.signUpCliked))
        self.viewSignUp.addGestureRecognizer(gestureviewSignUp)
        
        let gestureviewagreegation = UITapGestureRecognizer(target: self, action:  #selector(self.agreegationCliked))
        self.termsContion.addGestureRecognizer(gestureviewagreegation)
        labelPrivacy.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(agreeOnPrivacy)))
        viewPolicy.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(acceptPolicy)))
        viewMobileNumber.makeShadow(color: .black, alpha: 0.14, radius: 4)
        viewNationalNumber.makeShadow(color: .black, alpha: 0.14, radius: 4)
        viewEmail.makeShadow(color: .black, alpha: 0.14, radius: 4)
        mobileTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

        
        if UserManager.isArabic {
            email.textAlignment = .right
            mobileTextField.textAlignment = .right
            nationalId.textAlignment = .right
            LabelTop.text = "إذا كان لديك بالفعل ملف فى مستشفى السلام الدولي ، فقم بالتسجيل هنا"
            termsContion.text = " على الشروط والأحكام"
            labelPrivacy.text = "سياسة الخصوصية"
            acceptLabel.text = "انا اوفق"
            labelPloictTitle.text = "انا اوفق"
        } else {
            email.textAlignment = .left
            mobileTextField.textAlignment = .left
            nationalId.textAlignment = .left
            LabelTop.text = "If you already have a file in Al-Salam Hospitals register here"
            termsContion.text = "the Terms and Conditions"
            acceptLabel.text = "I Accept"
            labelPrivacy.text = "the Privacy Policy"
            labelPloictTitle.text = "I Accept"
        }
        nationalId.text = ""
        email.text = ""
        mobileTextField.text = ""
        viewCountry.setCountryByName("Saudi Arabia")
        phoneCode = viewCountry.selectedCountry.phoneCode
        selectedCountry = viewCountry.selectedCountry
        viewCountry.delegate = self
        if UserManager.isArabic {
            mobileTextField.transform = CGAffineTransform(scaleX: -1, y: 1)
            viewCountry.transform = CGAffineTransform(scaleX: -1, y: 1)
            viewPhoneHolder.transform = CGAffineTransform(scaleX: -1, y: 1)
            mobileTextField.textAlignment = .left
            viewCountry.initWithArabic()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initViews()
    }
    
    func initViews(){
        UIView.appearance().semanticContentAttribute = !UserManager.isArabic ? .forceLeftToRight : .forceRightToLeft
        nationalId.placeholder = UserManager.isArabic ? " الرقم المدني (اختياري) " : "Civil ID (Optional)"
        email.placeholder = UserManager.isArabic ? " البريد الإلكتروني (اختياري)" : "Email (Optional)"
        mobileTextField.placeholder = UserManager.isArabic ? "رقم الجوال" : "mobile number"
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == mobileTextField {
            if textField.text?.count ?? 0 > 8 {
                mobileTextField.text = textField.text?.prefix(8).lowercased()
            }
        }
    }
    
    func checkTextFields() {
        if !checkMobileValidate(mobileTextField.text ?? "")  {
            Utilities.showAlert(messageToDisplay:UserManager.isArabic ? "من فضلك ادخل رقم هاتف صحيحا" : "Please Enter Valid Mobile Number")
            return
        }
        if (!(mobileTextField.text?.isEmpty ?? true )) {
//            phoneCode = ""
            let pars = ["Mobile": "\(phoneCode)\(mobileTextField.text!)"]
            let urlString = Constants.APIProvider.Signup
            let url = URL(string: urlString)
            let parseUrl = Constants.APIProvider.Signup + Constants.getoAuthValue(url: url!, method: "POST")
            if agreeDisAgree == false {
                Utilities.showAlert(messageToDisplay: UserManager.isArabic ? "الرجاء الموافقة علي الشروط والاحكام" : "Please accept the Terms and Conditions")
                return
            }
            if !policyAccepted {
                Utilities.showAlert(messageToDisplay: UserManager.isArabic ? "الرجاء الموافقة علي سياسة الخصوصية" : "Please accept the Privacy Policy")
                return
            }
            
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
                            vc1.mobileNumberReservsation = self.mobileTextField.text!
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
//                                        UserManager.saveUserInfo(user: currentPatientID)
                                        self.navigationController?.popToRootViewController(animated: true)
                                    } else{
                                        if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["MESSAGE"] as? [String:AnyObject] {
                                            let MESSAGE_ROW = root["MESSAGE_ROW"] as!  AnyObject
                                            Utilities.showAlert(messageToDisplay: MESSAGE_ROW[UserManager.isArabic ? "NAME_AR" : "NAME_EN"] as? String ?? "")
                                        }
                                    }
                                }
                            }
                            let vc = verifcationAddOtherVC(PatientId: json["PATIENT_ID"] as? String, patientIdArray: nil, vcType: .fromRetrive)
                            vc.mobileNumberReservsation = self.mobileTextField.text!
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
        } else {
            Utilities.showAlert(messageToDisplay: "Empty Field")
        }
    }
    
    @objc func remberMeCliked(sender : UITapGestureRecognizer) {
        if agreeDisAgree == false {
            agreeDisAgree =  true
            termsConditionsImage.image = UIImage(named: "dignosisSelected.png")
        } else {
            agreeDisAgree =  false
            termsConditionsImage.image = UIImage(named: "additinakDataDiagnosisSeleected.png")
        }
    }
    
    @objc func signUpCliked(sender : UITapGestureRecognizer) {
        checkTextFields()
    }
    
    @objc func agreegationCliked(sender : UITapGestureRecognizer) {
        let vc = termsAndConditionVC()
        vc.typePrivacyPolicy = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func agreeOnPrivacy() {
        let vc = termsAndConditionVC()
        vc.typePrivacyPolicy = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func acceptPolicy() {
        if policyAccepted == false {
            policyAccepted =  true
            imageViewpolicy.image = UIImage(named: "dignosisSelected.png")
        } else {
            policyAccepted =  false
            imageViewpolicy.image = UIImage(named: "additinakDataDiagnosisSeleected.png")
        }
    }
}

extension RegisterViewController :CountryPickerViewDelegate{
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        phoneCode = country.phoneCode
        selectedCountry = country
    }
}
