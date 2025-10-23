//
//  CompleteLoginWithPasswordViewController.swift
//  CareMate
//
//  Created by Khabber on 22/01/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

class CompleteLoginWithPasswordViewController: BaseViewController {
    @IBOutlet weak var passwordTx: UITextField!
    @IBOutlet weak var passwordview: UIView!
    @IBOutlet weak var contineView: UIView!
    @IBOutlet weak var labelPassword: UILabel!
    @IBOutlet weak var labelMakeLogin: UILabel!
    @IBOutlet weak var viewForget: UIView!
    @IBOutlet weak var labelForgotPassword: UILabel!
    @IBOutlet weak var labelHint: UILabel!
    

    var mobile = ""
    var patientId = ""
    var code  = ""
    var mobileWithoutCode = ""
    var user:UserMobileDTO?
    var comesFromProfile:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTx.isSecureTextEntry = true
        passwordview.makeShadow(color: .black, alpha: 0.14, radius: 4)
        initHeader(isNotifcation: false, isLanguage: false,title: UserManager.isArabic ? "استكمال الدخول" : "Continue Login",hideBack: false)
        let gestureContinue = UITapGestureRecognizer(target: self, action:  #selector(self.loginCliked))
        self.contineView.addGestureRecognizer(gestureContinue)
        labelPassword.text = UserManager.isArabic ? "كلمه السر" :"Password"
        labelMakeLogin.text = UserManager.isArabic ? "الدخول" :"Login"

        passwordTx.placeholder = UserManager.isArabic ? "برجاء ادخال كلمه السر" :"Please Enter Password"
        labelForgotPassword.text = UserManager.isArabic ? "نسيت كلمة المرور" : "Forgot password"
        let gestureForgetPassword = UITapGestureRecognizer(target: self, action:  #selector(self.forgetPasswordCliked))
        
        self.viewForget.addGestureRecognizer(gestureForgetPassword)
        // Do any additional setup after loading the view.
        passwordTx.keyboardType = .asciiCapable
        if UserManager.isArabic {
            labelHint.text = "تنبيه: يجب ان يكون لكل حساب من افراد العائلة كلمة مرور محتلفة."
        }
    }
    
    @objc func forgetPasswordCliked(sender : UITapGestureRecognizer) {
    PresentRetrieveViewController(retrieveType: .password)
  }
    
    fileprivate func PresentRetrieveViewController(retrieveType: RetrieveType) {
      let vc = RetrieveViewController()
        vc.retrieveType = retrieveType
        vc.vcType = .fromRetrive
        vc.phoneNumber = mobileWithoutCode
      self.navigationController?.pushViewController(vc, animated: true)

        
  //    let popup = PopupDialog(viewController: retrieveViewController)
  //    self.present(popup, animated: true, completion: nil)
    }

    init(mobile:String, patientId: String, code: String = "", mobileWithoutCode: String) {
        self.mobile = mobile
        self.patientId = patientId
        self.code = code
        self.mobileWithoutCode = mobileWithoutCode
        super.init(nibName: "CompleteLoginWithPasswordViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func loginCliked(sender : UITapGestureRecognizer){
          var urlString = ""
          guard  let password = self.passwordTx.text,
                !password.isEmpty else {
                    Utilities.showAlert(messageToDisplay: UserManager.isArabic ? "الحقل فارغ" : "Empty Field")
                    return
                }
          let tokeen = UserDefaults.standard.object(forKey: "pushToken") as? String ?? ""
          urlString = Constants.APIProvider.Login+"detect_text=\(patientId)&PASSWORD=\(password)&MOBILEAPP_TYPE=2&MOBILEAPP_KEY=\(tokeen)&detect_type=5&PATIENT_ID=\(patientId)"
        if code == "6850" {
            urlString = Constants.APIProvider.Login+"detect_text=\(mobile)&PASSWORD=\(password)&MOBILEAPP_TYPE=2&MOBILEAPP_KEY=\(tokeen)&detect_type=2"
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
                                  UserDefaults.standard.set(password, forKey: "user_password")
                                  self.user?.saveToUser()
//                                  let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                                  let nextViewController = storyBoard.instantiateViewController(withIdentifier: "homeNavNav") as! UITabBarController
//                                  self.navigationController?.pushViewController(nextViewController, animated: true)
                                  self.navigationController?.dismiss(animated: true)

                                  
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
                                  if self.comesFromProfile {
                                      self.user?.saveToUser()
                                  }
                                  self.navigationController?.dismiss(animated: true)

//                                  let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                                  
//                                  let nextViewController = storyBoard.instantiateViewController(withIdentifier: "homeNavNav") as! UITabBarController
//                                  
//                                  self.navigationController?.pushViewController(nextViewController, animated: true)
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
