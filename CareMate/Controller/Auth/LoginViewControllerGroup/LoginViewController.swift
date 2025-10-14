//
//  LoginViewController.swift
//  CareMate
//
//  Created by Eng Nour Hegazy on 11/4/17.
//  Copyright © 2017 khabeer Group. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PopupDialog
import MZFormSheetController
import LocalAuthentication
import CountryPickerView
import JNPhoneNumberView

/// Internal current language key
let LCLCurrentLanguageKey = "LCLCurrentLanguageKey"

/// Default language. English. If English is unavailable defaults to base localization.
let LCLDefaultLanguage = "en"

/// Base bundle as fallback.
let LCLBaseBundle = "Base"

/// Name for language change notification
public let LCLLanguageChangeNotification = "LCLLanguageChangeNotification"

protocol clinicOrEmergency {
    func clinicOrEmergencyfunc(ClinicOrEmergency:String)
}

class LoginViewController: BaseViewController, clinicOrEmergency {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    func clinicOrEmergencyfunc(ClinicOrEmergency: String) {
        print(ClinicOrEmergency)
        
        if ClinicOrEmergency == "C"
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let v1 = BrnachiesViewController()
            v1.fromMedicalRecord = true
            v1.vcType = .fromReservation
            
            UserDefaults.standard.set(false, forKey: "loginOrNO")
            
            
            self.navigationController?.pushViewController(v1, animated: true)
        }
        else if ClinicOrEmergency == "Retrive"
        {
            
            //        delegate?.clinicOrEmergencyfunc(ClinicOrEmergency: "E")
            let retrieveViewController = RetrieveViewController()
            retrieveViewController.vcType = .fromReservation
            retrieveViewController.search = true
            retrieveViewController.fromGuest = true
            self.navigationController?.pushViewController(retrieveViewController, animated: true)
        }
        else
        {
            
            
            let vc: CallerInfoViewController = CallerInfoViewController()
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
  
    
    var branches = [Branch]()
    var selectedBranch: Branch?
    var delegateclinicOrEmergency:clinicOrEmergency?
    @IBOutlet weak var ContineASGuest: UILabel!
    @IBOutlet weak var userNameTx: UITextField!
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var viewSign: UIView!
    @IBOutlet weak var viewForget: UIView!
    @IBOutlet weak var ContinueASGuest: UIView!
    @IBOutlet weak var viewCountrty: CountryPickerView!
    @IBOutlet weak var lblRemeber: UILabel!
    @IBOutlet weak var btnRemember: UIButton!
    @IBOutlet weak var lblSchedule: UILabel!
    @IBOutlet weak var pickerSchedule: UIView!
    @IBOutlet weak var viewContactUs: UIView!
    @IBOutlet weak var labelLogin: uilabelCenter!
    @IBOutlet weak var labelForotPassword: UILabel!
    @IBOutlet weak var labelLoginBtn: UILabel!
    @IBOutlet weak var labelSignUp: UILabel!
    @IBOutlet weak var labelContactUs: UILabel!
    @IBOutlet weak var viewPhoneHolder: UIView!
    @IBOutlet weak var labelHint: UILabel!
    
    var isCardId = false
    var isEmail = false
    var phoneCode = ""
    var isRememberMe:Bool = false
    var selectedCountry: Country?
    let def = UserDefaults.standard
    
    @IBAction func forgetPasswordPressed(_ sender: Any) {
        PresentRetrieveViewController(retrieveType: .password)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        viewLogin.makeShadow(color: .black, alpha: 0.14, radius: 4)
        
        initViews()
        initHeader(isNotifcation: false, isLanguage: true, title:"", hideBack: true)
        //        initBackGround()
        if #available(iOS 11.0, *) {
            userNameTx.smartInsertDeleteType = .no
        }
        userNameTx.autocorrectionType = .yes
        //        mobileNumberTextField.keyboardType = .numberPad
        userNameTx.textContentType = UITextContentType.telephoneNumber
        userNameTx.keyboardType = .asciiCapableNumberPad
        
        
    }
    
    @IBAction func rememberOnTap(_ sender: Any) {
        isRememberMe = !isRememberMe
        setRemember()
    }
    
    func setRemember() {
        let img = UIImage(named: isRememberMe ? "dignosisSelected":"additinakDataDiagnosisSeleected")
        btnRemember.setImage(img, for: .normal)
        if isRememberMe {
            def.set(userNameTx.text ?? "", forKey: "remember.me")
        }else {
            def.removeObject(forKey: "remember.me")
        }
    }
    
    func initViews(){
        let gesturelogin = UITapGestureRecognizer(target: self, action:  #selector(self.loginCliked))
        self.viewLogin.addGestureRecognizer(gesturelogin)
        
        let gestureSignUp = UITapGestureRecognizer(target: self, action:  #selector(self.signUpCliked))
        self.viewSign.addGestureRecognizer(gestureSignUp)
        
        let gestureForgetPassword = UITapGestureRecognizer(target: self, action:  #selector(self.forgetPasswordCliked))
        
        self.viewForget.addGestureRecognizer(gestureForgetPassword)
        let gestureContactUs = UITapGestureRecognizer(target: self, action:  #selector(self.contactUsCliked))
        self.viewContactUs.addGestureRecognizer(gestureContactUs)
        
        let gesturecontinuAsGuest = UITapGestureRecognizer(target: self, action:  #selector(self.openAsGuest))
        self.ContinueASGuest.addGestureRecognizer(gesturecontinuAsGuest)
        
        let gestureSchedule = UITapGestureRecognizer(target: self, action:  #selector(self.openSchedule))
        self.pickerSchedule.addGestureRecognizer(gestureSchedule)
        ContineASGuest.text = UserManager.isArabic ? "البحث عن طبيب": "Search For a Doctor"
        ContineASGuest.textAlignment = .center
        labelContactUs.textAlignment = .center
        userNameTx.placeholder = UserManager.isArabic ? "الرجاء ادخال رقم الهاتف" : "Enter Mobile Number"
        if UserManager.isArabic {
            labelLogin.text = "تسجيل الدخول"
            labelForotPassword.text = "نسيت كلمة المرور"
            labelLoginBtn.text = "تسجيل الدخول"
            labelSignUp.text = "إنشاء حساب جديد"
            labelContactUs.text = "تواصل معنا"
            labelHint.text = "تنبيه: يجب ان يكون لكل حساب من افراد العائلة كلمة مرور محتلفة."
            lblRemeber.text = "تذكرني"
            lblSchedule.text = "جدولة خدمة"
        }
        else{
            
        }
        viewContactUs.setBorder(color: UIColor(fromRGBHexString: "#E5E5E5"), radius: 12, borderWidth: 1)
        ContinueASGuest.setBorder(color: UIColor(fromRGBHexString: "#E5E5E5"), radius: 12, borderWidth: 1)
        pickerSchedule.setBorder(color: UIColor(fromRGBHexString: "#E5E5E5"), radius: 12, borderWidth: 1)
    }
    
    @objc func contactUsCliked(sender : UITapGestureRecognizer) {
        
        //        let messageEn = "If you are Facing difficulties or you need any assistance contact the Call Center on"
        //        let messageAr = "إذا كنت تواجه أي صعوبات أو كنت بحاجة إلى أي مساعدة ، يمكنك الإتصال بمركز الإتصالات للحصول علي الدعم عن طريق"
        //        let formSheet = MZFormSheetController.init(viewController: slotNot(messageAr: messageAr, MessageEn:  messageEn))
        //        formSheet.shouldDismissOnBackgroundViewTap = true
        //        formSheet.transitionStyle = .slideFromBottom
        //        formSheet.presentedFormSheetSize = CGSize.init(width: UIScreen.main.bounds.width * 0.9, height: 380)
        //        formSheet.shouldCenterVertically = true
        //        formSheet.present(animated: true, completionHandler: nil)
        navigationController?.pushViewController(ContactUsViewController(), animated: true)
    }
    
    
    @objc func forgetPasswordCliked(sender : UITapGestureRecognizer) {
        PresentRetrieveViewController(retrieveType: .password)
    }
    
    
    @objc func signUpCliked(sender : UITapGestureRecognizer) {
        let vc =  RegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginCardId(_ sender: Any) {
        //        isCardId = true
        //        isEmail = false
        //        initCodeHight()
        //        self.userNameTx.placeholder =  "Enter Civil ID Or Mobile Or Email"
        
    }
    
    @IBAction func LoginEmail(_ sender: Any) {
        //        isCardId = false
        //        isEmail = true
        //        initCodeHight()
        //        self.userNameTx.placeholder =  "Enter Civil ID Or Mobile Or Email"
        
    }
    
    @IBAction func loginUserId(_ sender: Any) {
        //        isCardId = false
        //        isEmail = false
        //        initCodeHight()
        //        self.userNameTx.placeholder =  "Enter Civil ID Or Mobile Or Email"
        
        
    }
    
    
    fileprivate func PresentRetrieveViewController(retrieveType: RetrieveType) {
        
        print(retrieveType)
        //    let retrieveViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RetrieveViewController") as! RetrieveViewController
        //    retrieveViewController.retrieveType = retrieveType
        //      retrieveViewController.vcType = .fromRetrive
        //    self.navigationController?.pushViewController(retrieveViewController, animated: true)
        let vc = RetrieveViewController()
        vc.retrieveType = retrieveType
        vc.vcType = .fromRetrive
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        //    let popup = PopupDialog(viewController: retrieveViewController)
        //    self.present(popup, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = UserManager.isArabic ? "الدخول" : "Login"
        userNameTx.text = ""
        //    passwordTx.text = ""
        
        viewCountrty.setCountryByName("Saudi Arabia")
        selectedCountry = viewCountrty.selectedCountry
        phoneCode = viewCountrty.selectedCountry.phoneCode
        //      viewCountrty.flagImageView.isHidden = true
        viewCountrty.delegate = self
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(openAsGuest))
        self.ContinueASGuest.addGestureRecognizer(gesture)
        if UserManager.isArabic {
            viewPhoneHolder.transform = CGAffineTransform(scaleX: -1, y: 1)
            viewCountrty.transform = CGAffineTransform(scaleX: -1, y: 1)
            userNameTx.transform = CGAffineTransform(scaleX: -1, y: 1)
            userNameTx.textAlignment = .left
            viewCountrty.initWithArabic()
        }
        
        if def.string(forKey: "remember.me")?.isEmpty == false {
            isRememberMe = true
            userNameTx.text = def.string(forKey: "remember.me")
            setRemember()
        }
    }
    
    @objc func openAsGuest()
    {
        let vc:DoctorsSearchViewController = DoctorsSearchViewController()
      //  vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func openSchedule()
    {
        let vc:ErmergenyClinicViewController = ErmergenyClinicViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    @objc func loginCliked(sender : UITapGestureRecognizer) {
        var urlString = ""
        guard let medicalId = self.userNameTx.text,
              !medicalId.isEmpty else {
                  Utilities.showAlert(messageToDisplay: "Empty Field")
                  return
              }
        
        let tokeen = UserDefaults.standard.object(forKey: "pushToken") as? String ?? ""
//        phoneCode = ""
        urlString = Constants.APIProvider.Login+"detect_text=\(medicalId)&MOBILEAPP_TYPE=2&MOBILEAPP_KEY=\(tokeen)&detect_type=2"
        print(urlString)
        indicator.sharedInstance.show()
        print(urlString)
        let url = URL(string: urlString)
        let parseUrl = Constants.APIProvider.Login + Constants.getoAuthValue(url: url!, method: "GET")
        print(parseUrl)
        setRemember()
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            var listOfOTher = [listOfTherPatient]()
            indicator.sharedInstance.dismiss()
            
            if error == nil
            {
                
                if let root = ((data as? [String: AnyObject])?["Root"] as? [String:AnyObject])?["OUT_PARMS"] as? [String:AnyObject]
                {
                    
                    if root["OUT_PARMS_ROW"] is [String:AnyObject]
                        
                    {
                        let OUT_PARMS_ROW = root["OUT_PARMS_ROW"] as!  AnyObject
                        
                        let loginStratues =  OUT_PARMS_ROW["LOGIN_STATUS"] as? String
                        
                        if loginStratues == "2"
                        {
                            if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["PAT_DATA"] as? [String:AnyObject]
                            {
                                
                                
                                
                                if root["PAT_DATA_ROW"] is [[String:AnyObject]]
                                {
                                    
                                    let appoins = root["PAT_DATA_ROW"] as! [[String: AnyObject]]
                                    for i in appoins
                                    {
                                        print(i)
                                        listOfOTher.append(listOfTherPatient(JSON: i)!)
                                        
                                        
                                    }
                                }
                                else if root["PAT_DATA_ROW"] is [String:AnyObject]
                                {
                                    listOfOTher.append(listOfTherPatient(JSON:root["PAT_DATA_ROW"] as![String:AnyObject] )!)
                                    
                                    
                                }
                                let  vc = LitsOfPatientLogedBySameMobileNumberViewController(listOfOthers: listOfOTher, VcType: listOfOtherScreenType.fromLogin)
                                vc.primaryPhoneNumber = medicalId
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                                
                            }
                        }
                        else if loginStratues == "1"
                        {
                            
                            if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["PAT_DATA"] as? [String:AnyObject]
                            {
                                let OUT_PARMS_ROW = root["PAT_DATA_ROW"] as!  AnyObject
                                
                                let loginStratues =  OUT_PARMS_ROW["PATIENTID"] as? String
                                
                                print( OUT_PARMS_ROW["PATIENTID"] as? String ?? "")
                                currentPatientIDOrigni =    OUT_PARMS_ROW["PATIENTID"] as? String ?? ""
                                Utilities.sharedInstance.setPatientId(patienId: OUT_PARMS_ROW["PATIENTID"] as? String ?? "")  
                                currentPatientMobile =  OUT_PARMS_ROW["PAT_TEL"] as? String ?? ""
                                UserDefaults.standard.set(OUT_PARMS_ROW["PATIENTID"] as? String ?? "", forKey: "patientIdWithSpaces")
                                UserDefaults.standard.set(OUT_PARMS_ROW["PAT_TEL"] as? String ?? "", forKey: "PAT_TEL")
                                UserDefaults.standard.set(true, forKey: "loginOrNO")
                                
                                let user1 =     LoginedUser(COMPLETEPATNAME_AR: OUT_PARMS_ROW["COMPLETEPATNAME_AR"] as? String ?? "" , COMPLETEPATNAME_EN: OUT_PARMS_ROW["COMPLETEPATNAME_EN"] as? String ?? "", PAT_TEL: OUT_PARMS_ROW["PAT_TEL"] as? String ?? "", PAT_EMAIL: OUT_PARMS_ROW["PAT_EMAIL"] as? String ?? "", PATIENTID: OUT_PARMS_ROW["PATIENTID"] as? String ?? "")
                                let encoder = JSONEncoder()
                                if let encoded = try? encoder.encode(user1) {
                                    let defaults = UserDefaults.standard
                                    defaults.set(encoded, forKey: "SavedPerson")
                                }
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                
                                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "homeNavNav") as! UITabBarController
                                
                                self.navigationController?.pushViewController(nextViewController, animated: true)
                                
                            }
                        }
                        else
                        {
                            if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["MESSAGE"] as? [String:AnyObject]
                            {
                                let MESSAGE_ROW = root["MESSAGE_ROW"] as!  AnyObject
                                
                                if let CODE = MESSAGE_ROW["CODE"] as? String
                                {
                                    if CODE == "6850"
                                    {
                                        self.navigationController?.pushViewController(CompleteLoginWithPasswordViewController(mobile: "\(self.phoneCode)\(medicalId)", patientId: Utilities.sharedInstance.getPatientId(), code: "6850", mobileWithoutCode: medicalId), animated: true)
                                    }
                                    else
                                    {
                                        Utilities.showAlert(messageToDisplay: UserManager.isArabic ? MESSAGE_ROW["NAME_AR"] as? String ?? "" : MESSAGE_ROW["NAME_EN"] as? String ?? "")
                                        
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }

}


struct LoginedUser :Codable{
    
    
    var  COMPLETEPATNAME_AR = ""
    var  COMPLETEPATNAME_EN = ""
    var  PAT_TEL = ""
    var  PAT_EMAIL = ""
    var  PATIENTID = ""
    
    
}

//extension LoginViewController:SpecialityFilterDelegate{
//    func specialityFilter(_ specialityFilter: SpecialityFilter, didSelectSpeciality speciality: Speciality) {
//
//        let doctorsVC = self.storyboard?.instantiateViewController(withIdentifier: "DoctorsViewController") as! DoctorsViewController
//        doctorsVC.branchId = nil
//        doctorsVC.branch = nil
//        doctorsVC.specialityId = speciality.id
//        isReschedule = false
//        self.navigationController?.show(doctorsVC, sender: self)
//    }
//
//
//
//
//}

extension LoginViewController: SpecialityFilterDelegate {
    func specialityFilter(_ specialityFilter: SpecialityFilter, didSelectSpeciality speciality: Speciality) {
        //   specialityFilterPopup?.dismiss()
        
        Branch.getOnlineAppointment() { onlineAppointments, branchesDic  in
            guard let onlineAppointments = onlineAppointments else {
                return
                
            }
            self.branches = onlineAppointments
            self.selectedBranch = self.branches[0]
            
            // Create a custom view controller
            let specialityFilter = SpecialityFilter(nibName: "SpecialityFilter", bundle: nil)
            specialityFilter.delegate = self
            
            
            let doctorsVC = DoctorsViewController()
            doctorsVC.branchId = self.selectedBranch?.id
            doctorsVC.branch = self.selectedBranch!
            
            doctorsVC.specialityId = speciality.id
            doctorsVC.SpecType = speciality.SPEC_TYPE ?? ""
            isReschedule = false
            self.navigationController?.pushViewController(doctorsVC, animated: true)
        }
    }
}
open class Localize: NSObject {
    
    /**
     List available languages
     - Returns: Array of available languages.
     */
    open class func availableLanguages(_ excludeBase: Bool = false) -> [String] {
        var availableLanguages = Bundle.main.localizations
        // If excludeBase = true, don't include "Base" in available languages
        if let indexOfBase = availableLanguages.firstIndex(of: "Base") , excludeBase == true {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }
    
    /**
     Current language
     - Returns: The current language. String.
     */
    open class func currentLanguage() -> String {
        if let currentLanguage = UserDefaults.standard.object(forKey: LCLCurrentLanguageKey) as? String {
            return currentLanguage
        }
        return defaultLanguage()
    }
    
    /**
     Change the current language
     - Parameter language: Desired language.
     */
    open class func setCurrentLanguage(_ language: String) {
        let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage()
        if (selectedLanguage != currentLanguage()){
            UserDefaults.standard.set(selectedLanguage, forKey: LCLCurrentLanguageKey)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
        }
    }
    
    /**
     Default language
     - Returns: The app's default language. String.
     */
    open class func defaultLanguage() -> String {
        var defaultLanguage: String = String()
        guard let preferredLanguage = Bundle.main.preferredLocalizations.first else {
            return LCLDefaultLanguage
        }
        let availableLanguages: [String] = self.availableLanguages()
        if (availableLanguages.contains(preferredLanguage)) {
            defaultLanguage = preferredLanguage
        }
        else {
            defaultLanguage = LCLDefaultLanguage
        }
        return defaultLanguage
    }
    
    /**
     Resets the current language to the default
     */
    open class func resetCurrentLanguageToDefault() {
        setCurrentLanguage(self.defaultLanguage())
    }
    
    /**
     Get the current language's display name for a language.
     - Parameter language: Desired language.
     - Returns: The localized string.
     */
    open class func displayNameForLanguage(_ language: String) -> String {
        let locale : NSLocale = NSLocale(localeIdentifier: currentLanguage())
        if let displayName = locale.displayName(forKey: NSLocale.Key.identifier, value: language) {
            return displayName
        }
        return String()
    }
}

extension LoginViewController :CountryPickerViewDelegate{
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        phoneCode = country.phoneCode
        selectedCountry = country
    }
}
