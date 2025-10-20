//
//  BHGLoginController.swift
//  CareMate
//
//  Created by Ibrahim on 02/10/2025.
//  Copyright © 2025 khabeer Group. All rights reserved.
//

import UIKit

class BHGLoginController: BaseViewController, clinicOrEmergency {
    
    @IBOutlet weak var pickerPassword: RoundUIView!
    @IBOutlet weak var pickerForgot: UIView!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var pickerContact: UIView!
    @IBOutlet weak var lblGuest: UILabel!
    @IBOutlet weak var pickerGuest: UIView!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var lblDont: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgot: UIButton!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var txfID: UITextField!
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var lblLogin: UILabel!
    
    private var code:String = ""
    private var showPassword:Bool = false
    private var user:UserMobileDTO?

    override func viewDidLoad() {
        super.viewDidLoad()
        setlocalization()
        pickerContact.setBorder(color: UIColor(fromRGBHexString: "#E5E5E5"), radius: 12, borderWidth: 1)
        pickerGuest.setBorder(color: UIColor(fromRGBHexString: "#E5E5E5"), radius: 12, borderWidth: 1)
        
        let gestureContactUs = UITapGestureRecognizer(target: self, action:  #selector(self.contactUsCliked))
        self.pickerContact.addGestureRecognizer(gestureContactUs)
        
        let gesturecontinuAsGuest = UITapGestureRecognizer(target: self, action:  #selector(self.openAsGuest))
        self.pickerGuest.addGestureRecognizer(gesturecontinuAsGuest)
      
    //    pickerForgot.setView(hidden: !showPassword)
     //   pickerPassword.setView(hidden: !showPassword)

        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    private func setlocalization() {
        txfID.textAlignment = UserManager.isArabic ? .right:.left
        txfPassword.textAlignment = UserManager.isArabic ? .right:.left
        initHeader(isNotifcation: false, isLanguage: true, title:"", hideBack: true)
        lblLogin.textAlignment = .center
        lblWelcome.textAlignment = .center
        lblGuest.textAlignment = .center
        lblContact.textAlignment = .center
        lblLogin.text = UserManager.isArabic ? "تسجيل الدخول":"Sign In"
        lblWelcome.text = UserManager.isArabic ? "اهلا وسهلا بك":"Welcome"
        txfID.placeholder = UserManager.isArabic ? "رقم الهوية/ رقم ملف طبي / رقم الاقامة":"Civil ID/Medical file ID/Residence ID"
        txfPassword.placeholder = UserManager.isArabic ? "كلمة المرور":"Password"
        btnForgot.setTitle(UserManager.isArabic ? "نسيت كلمة المرور ؟":"Forgot your password ?", for: .normal)
        btnLogin.setTitle(UserManager.isArabic ? "دخول":"Sign In", for: .normal)
        lblDont.text = UserManager.isArabic ? "لا تمتلك حساب ؟":"Don't have account ?"
        btnRegister.setTitle(UserManager.isArabic ? "تسجيل جديد":"Sign Up", for: .normal)
        lblGuest.text = UserManager.isArabic ? "البحث عن طبيب": "Search For a Doctor"
        lblContact.text = UserManager.isArabic ? "تواصل معنا":"Contact Us"

    }

    @IBAction func viewPasswordTap(_ sender: Any) {
        txfPassword.isSecureTextEntry =  txfPassword.isSecureTextEntry ? false:true
    }
    

    @IBAction func forgotTap(_ sender: Any) {
        PresentRetrieveViewController(retrieveType: .password)
    }
    
    
    @IBAction func registerTap(_ sender: Any) {
        navigationController?.pushViewController(BHGRegisterController(), animated: true)
    }
    
    @IBAction func loginTap(_ sender: Any) {
//        if showPassword {
//            loginWithPassword()
//        }else {
//            login()
//        }
        loginWithPassword()
    }
    
    fileprivate func PresentRetrieveViewController(retrieveType: RetrieveType) {
      let vc = RetrieveViewController()
        vc.retrieveType = retrieveType
        vc.vcType = .fromRetrive
        vc.phoneNumber = txfID.text!
      self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @objc func contactUsCliked(sender : UITapGestureRecognizer) {
        navigationController?.pushViewController(ContactUsViewController(), animated: true)
    }
   
    @objc func openAsGuest()
    {
        let vc:DoctorsSearchViewController = DoctorsSearchViewController()
      //  vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
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
    
    private func login() {
        var urlString = ""
        let enter = LanguageManager.isArabic() ? "ادخل ":"Enter "
        guard let medicalId = self.txfID.text,
              !medicalId.isEmpty else {
                Utilities.showAlert(messageToDisplay: enter + txfID.placeholder!)
                  return
              }
        
//        guard let password = self.txfID.text,
//              !password.isEmpty else {
//                  Utilities.showAlert(messageToDisplay: enter + txfPassword.placeholder!)
//                  return
//              }
        
        let tokeen = UserDefaults.standard.object(forKey: "pushToken") as? String ?? ""
        urlString = Constants.APIProvider.Login+"detect_text=\(medicalId)&&MOBILEAPP_TYPE=2&MOBILEAPP_KEY=\(tokeen)&detect_type=2"
        print(urlString)
        indicator.sharedInstance.show()
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
                                        self.code = "6850"
                                        self.showPassword = true
                                        self.txfID.isUserInteractionEnabled = false
                                        self.pickerPassword.setView(hidden: false)
                                        self.pickerForgot.setView(hidden: false)
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
    
    private func loginWithPassword(){
          var urlString = ""
        let enter = LanguageManager.isArabic() ? "ادخل ":"Enter "
        guard let medicalId = self.txfID.text,
              !medicalId.isEmpty else {
                Utilities.showAlert(messageToDisplay: enter + txfID.placeholder!)
                  return
              }
        
          guard  let password = txfPassword.text,
                !password.isEmpty else {
              Utilities.showAlert(messageToDisplay: enter + txfPassword.placeholder!)
                    return
                }
          let tokeen = UserDefaults.standard.object(forKey: "pushToken") as? String ?? ""
      //  let patientId = Utilities.sharedInstance.getPatientId()
        let patientId = medicalId

          urlString = Constants.APIProvider.Login+"detect_text=\(patientId)&PASSWORD=\(password)&MOBILEAPP_TYPE=2&MOBILEAPP_KEY=\(tokeen)&detect_type=5"
        let id = txfID.text!
        if code == "6850" {
            urlString = Constants.APIProvider.Login+"detect_text=\(id)&PASSWORD=\(password)&MOBILEAPP_TYPE=2&MOBILEAPP_KEY=\(tokeen)&detect_type=2"
        }
        UserDefaults.standard.set(patientId, forKey: "patientId")
          print(urlString)
          indicator.sharedInstance.show()
          print(urlString)
          let url = URL(string: urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!)
          let parseUrl = Constants.APIProvider.Login + Constants.getoAuthValue(url: url!, method: "GET")
          print(parseUrl)
          WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
              var listOfOTher = [listOfTherPatient]()
              indicator.sharedInstance.dismiss()
              
              if error == nil {
                  if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["OUT_PARMS"] as? [String:AnyObject] {
                      if root["OUT_PARMS_ROW"] is [String:AnyObject] {
                          let OUT_PARMS_ROW = root["OUT_PARMS_ROW"] as!  AnyObject
                          let loginStratues =  OUT_PARMS_ROW["LOGIN_STATUS"] as? String
                          if loginStratues == "2" {
                              if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["PAT_DATA"] as? [String:AnyObject] {
                                  let patImage = ((root["PAT_DATA_ROW"] as? [String: Any])?["PAT_PIC"] as? [String: Any])?["BLOB_PATH"] as? String ?? ""
                                  UserDefaults.standard.set(patImage, forKey: "patImage")
                                  let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                  
                                  let nextViewController = storyBoard.instantiateViewController(withIdentifier: "homeNavNav") as! UITabBarController
                                  UserDefaults.standard.set(password, forKey: "user_password")
                                  self.user?.saveToUser()
                                  self.navigationController?.pushViewController(nextViewController, animated: true)
                                  
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
                                  UserDefaults.standard.set(Utilities.sharedInstance.getPatientId(), forKey: "Utilities.sharedInstance.getPatientId()")
                                  currentPatientMobile =  OUT_PARMS_ROW["PAT_TEL"] as? String ?? ""
                                  UserDefaults.standard.set(true, forKey: "loginOrNO")
                                  UserDefaults.standard.set(currentPatientMobile, forKey: "PAT_TEL")
                                  
                                  let user1 =     LoginedUser(COMPLETEPATNAME_AR: OUT_PARMS_ROW["COMPLETEPATNAME_AR"] as? String ?? "" , COMPLETEPATNAME_EN: OUT_PARMS_ROW["COMPLETEPATNAME_EN"] as? String ?? "", PAT_TEL: OUT_PARMS_ROW["PAT_TEL"] as? String ?? "", PAT_EMAIL: OUT_PARMS_ROW["PAT_EMAIL"] as? String ?? "", PATIENTID: OUT_PARMS_ROW["PATIENTID"] as? String ?? "")
                                  let encoder = JSONEncoder()
                                  if let encoded = try? encoder.encode(user1) {
                                      let defaults = UserDefaults.standard
                                      defaults.set(encoded, forKey: "SavedPerson")
                                  }
                                  
                                  let patImage = ((OUT_PARMS_ROW["PAT_PIC"] as? [String: Any])?["PAT_PIC_ROW"] as? [String: Any])?["BLOB_PATH"] as? String ?? ""
                                  UserDefaults.standard.set(patImage, forKey: "patImage")
                                  UserDefaults.standard.set(password, forKey: "user_password")
//                                  UserManager.saveUserInfo(user: Utilities.sharedInstance.getPatientId())
                                  //            NotificationCenter.default.post(name: NSNotification.Name("GoToHome"), object: nil)
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
                                  
                                  Utilities.showAlert(messageToDisplay: MESSAGE_ROW[UserManager.isArabic ? "NAME_AR" : "NAME_EN"] as? String ?? "")

                                  if let CODE = MESSAGE_ROW["CODE"] as? String
                                  {
                                      if CODE == "6850"
                                      {
//                                          self.navigationController?.pushViewController(CompleteLoginWithPasswordViewController(), animated: true)
                                      }
                                      else
                                      {
                                          Utilities.showAlert(messageToDisplay: MESSAGE_ROW[UserManager.isArabic ? "NAME_AR" : "NAME_EN"] as? String ?? "")

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


extension UIView {
    func setView(hidden: Bool) {
        UIView.transition(with: self, duration: 0.5, options: .curveEaseInOut, animations: {
            self.isHidden = hidden
        })
    }
}
