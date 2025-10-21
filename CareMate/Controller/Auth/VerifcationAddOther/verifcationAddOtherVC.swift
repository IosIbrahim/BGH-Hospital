//
//  verifcationAddOtherVC.swift
//  careMatePatient
//
//  Created by khabeer on 8/28/20.
//  Copyright © 2020 khabeer. All rights reserved.
//

import UIKit
import SwiftyCodeView
import Alamofire
import SwiftyJSON
import PopupDialog
protocol resendCodeDelgate {
    func resendCode()
    func resendCodeLogin(mobileNumber:String)
}

class verifcationAddOtherVC: BaseViewController {
    
    @IBOutlet weak var lblResendHint: UILabel!
    @IBOutlet weak var lblHint: UILabel!
    @IBOutlet weak var viewCode: SwiftyCodeView!
    @IBOutlet weak var sendCode: UIButton!
    @IBOutlet weak var resend: UILabel!
    @IBOutlet weak var secondLAbel: UILabel!
    
    var fromForget = false
    var code = ""
    var sencond = 59
    var fromLogin = false
    var mobileNumber = ""

    var socialId = ""
    var fromLAb = false
    var param = [String:Any]()
    var timer = Timer()
    var delegate:resendCodeDelgate?
    var delegeteChangw:fromChangePass?
    var PATIENT_ID:String?
    var patientIdArray:String?
    var listOfOTher = [listOfTherPatient]()
    var vcType:reservationOfForget?
    var mobileNumberReservsation = ""
    var phoneNumber = ""
    var countryCode = ""
    var fromGuest = false
    var fromEmail = false
    
    init(PatientId: String?,patientIdArray:String?,vcType:reservationOfForget?) {
        self.PATIENT_ID = PatientId
        self.patientIdArray = patientIdArray
        self.vcType = vcType
        
        
        super.init(nibName: "verifcationAddOtherVC", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHeader(isNotifcation: false, isLanguage: true, title: UserManager.isArabic ? "" : "", hideBack: false)
        
        //        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        viewCode.delegate = self
        sendCode.alpha = 0.7
        sendCode.isEnabled = false
        resend.alpha = 0.7
        resend.isUserInteractionEnabled = false
        self.timer = Timer.scheduledTimer(timeInterval: 1.0,
                                          target: self,
                                          selector: #selector(minsMintue),
                                          userInfo: nil,
                                          repeats: true)
        
        if UserManager.isArabic {
            lblResendHint.text = "لم استلم الكود"
            lblHint.text = "ارسال كود التاكيد"
            resend.text = "ارسال الكود"
            sendCode.setTitle("تأكيد", for: .normal)
            viewCode.transform = CGAffineTransform(scaleX: -1, y: 1)
            for item in viewCode.stackView.subviews {
                item.transform = CGAffineTransform(scaleX: -1, y: 1)
            }
        }else {
            lblResendHint.text = "Don't Recieve Code"
        }
        sendCode.titleLabel!.font = UIFont(name: "Tajawal-Regular", size: 17)
        resend.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resendCode)))
    }
    override func viewWillDisappear(_ animated: Bool) {
        //        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        
    }
    
    @objc  func minsMintue()
    {
        
        
        sencond -= 1
        secondLAbel.text  = "00:\(sencond)"
        
        if sencond == 0
        {
            resend.alpha = 1
            resend.isUserInteractionEnabled = true
            self.timer.invalidate()
        }
        if sencond < 10 {
            secondLAbel.text  = "00:0\(sencond)"
        }
    }
    @objc func playTimer()
    {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0,
                                          target: self,
                                          selector: #selector(minsMintue),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    @objc func resendCode() {
        sencond = 59
        resend.alpha = 0.8
        resend.isUserInteractionEnabled = false
        playTimer()
        if fromLogin == true {
            delegate?.resendCodeLogin( mobileNumber: mobileNumber)
        } else{
            self.navigationController?.popViewController(animated: true)
            delegate?.resendCode()
        }
    }
    @IBAction func confirmAddOther(_ sender: Any) {
        if vcType == .fromRetrive {
            verify()
        } else {
            verifyReservation()
        }
    }
    
    func verifyReservation() {
        var pars : [String:Any]?
        var urlString = Constants.APIProvider.validateCode

        if PATIENT_ID != nil {
            pars = ["mobile": PATIENT_ID,"VERIFY_TEXT":self.code,"MOBILE_COUNTERY_CODE":self.countryCode,"STATUS":1] as! [String:Any]
            if fromGuest {
                pars = ["mobile": PATIENT_ID,"verify_text":self.code, "MOBILE_COUNTERY_CODE":self.countryCode,"STATUS":2] as! [String:Any]
            }
        }
        if patientIdArray != nil {
            pars = ["PATIENT_ID": patientIdArray,"VERIFY_TEXT":self.code, "MOBILE_COUNTERY_CODE":self.countryCode,"STATUS":1] as! [String:Any]
            print(pars)
            if fromGuest {
                pars = ["mobile": patientIdArray,"verify_text":self.code, "MOBILE_COUNTERY_CODE":self.countryCode,"STATUS":2] as! [String:Any]
            }
        }
        if fromGuest  {
            urlString = Constants.APIProvider.verifyQuestNumber
            
        }
        if fromForget == true {
            let url = URL(string: urlString)
            let parseUrl = Constants.APIProvider.validateCode + Constants.getoAuthValue(url: url!, method: "POST")
            indicator.sharedInstance.show()
            print("Parameters:\(pars ?? .init())")
            print("Url:\(urlString))")
            AF.request(fromGuest ? urlString: parseUrl , method: .post, parameters: pars , encoding: fromGuest ? .default: JSONEncoding.default, headers: nil).responseData { [unowned self] respons in
                indicator.sharedInstance.dismiss()
                guard let data = respons.value, let json = try? JSON(data: data) else { return }
                print(json)
                if  json["Root"]["OUT_PARMS"]["OUT_PARMS_ROW"]["STATUS"].string == "1" {
                    if listOfOTher.count > 0 {
                        let  vc = LitsOfPatientLogedBySameMobileNumberViewController(listOfOthers: listOfOTher, VcType: listOfOtherScreenType.fromRegister)
                        vc.delegate = self
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let vc:ConfirmAfterSignUpVC =   ConfirmAfterSignUpVC()
                        vc.patientId = self.PATIENT_ID ?? ""
                        vc.delegete = self
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    if self.fromGuest {
                        if json["STATUS"].string != "1" {
                            var msg = json["NAME_EN"].string
                           if LanguageManager.isArabic() {
                               msg = json["NAME_AR"].string
                           }
                            Utilities.showAlert(messageToDisplay: msg ?? "")
                        }else {
                            let vc :MyAppoimentViewController = MyAppoimentViewController()
                            vc.vcType = .fromReservation
                            vc.mobileNumber = mobileNumberReservsation
                            vc.phoneNumber = self.phoneNumber
                            vc.countryCode = self.countryCode
                            vc.fromGuest = self.fromGuest
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                   else if json["Root"]["MESSAGE"]["MESSAGE_ROW"]["CODE"].string != "1" {
                        var msg = json["Root"]["MESSAGE"]["MESSAGE_ROW"]["NAME_EN"].string
                       if LanguageManager.isArabic() {
                           msg = json["Root"]["MESSAGE"]["MESSAGE_ROW"]["NAME_AR"].string
                       }
                       Utilities.showAlert(messageToDisplay: msg ?? "")
                   }else {
                       let v1 :MyAppoimentViewController = MyAppoimentViewController()
                       v1.vcType = .fromReservation
                       v1.mobileNumber = mobileNumberReservsation
                       v1.phoneNumber = self.phoneNumber
                       v1.countryCode = self.countryCode
                       self.navigationController?.pushViewController(v1, animated: true)
                   }
                  
                }
            }
        } else {
            let urlString = Constants.APIProvider.signupvalidateCode
            let url = URL(string: urlString)
            if PATIENT_ID != nil {
                pars = ["PATIENT_ID": PATIENT_ID,"VERIFY_TEXT":self.code] as! [String:Any]
            }
            if patientIdArray != nil {
                pars = ["PATIENT_ID": patientIdArray,"VERIFY_TEXT":self.code] as! [String:Any]
                print(pars)
            }
            let parseUrl = Constants.APIProvider.signupvalidateCode + Constants.getoAuthValue(url: url!, method: "POST")
            indicator.sharedInstance.show()
            
            AF.request(parseUrl , method: .post, parameters: pars , encoding: JSONEncoding.default, headers: nil).responseData { [unowned self] respons in
                indicator.sharedInstance.dismiss()
                guard let data = respons.value, let json = try? JSON(data: data) else { return }
                print(json)
                if  json["Root"]["OUT_PARMS"]["OUT_PARMS_ROW"]["STATUS"].string == "1" {
                    if  json["Root"]["OUT_PARMS"]["OUT_PARMS_ROW"]["STATUS"].string == "1" {
                        if listOfOTher.count > 0 {
                            let  vc = LitsOfPatientLogedBySameMobileNumberViewController(listOfOthers: listOfOTher, VcType: listOfOtherScreenType.fromRegister)
                            vc.delegate = self
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            let vc:ConfirmAfterSignUpVC =   ConfirmAfterSignUpVC()
                            vc.patientId = self.PATIENT_ID ?? ""
                            vc.delegete = self
//                            let popup = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .zoomIn,  gestureDismissal: true)
//                            self.present(popup, animated: true, completion: nil)
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    } else {
                        Utilities.showAlert(messageToDisplay: "Plz Enter Vaild code")
                    }
                } else {
                    Utilities.showAlert(messageToDisplay: "Plz Enter Vaild code")
                }
            }
        }
    }
    
    func verify() {
        var pars : [String:Any]?
        if PATIENT_ID != nil {
            pars = ["PATIENT_ID": PATIENT_ID,"VERIFY_TEXT":self.code] as! [String:Any]
        }
        if patientIdArray != nil {
            pars = ["PATIENT_ID": patientIdArray,"VERIFY_TEXT":self.code] as! [String:Any]
            print(pars)
        }
        if fromForget == true {
            let urlString = Constants.APIProvider.validateCode
            let url = URL(string: urlString)
            let parseUrl = Constants.APIProvider.validateCode + Constants.getoAuthValue(url: url!, method: "POST")
            indicator.sharedInstance.show()
            AF.request(parseUrl , method: .post, parameters: pars , encoding: JSONEncoding.default, headers: nil).responseData { [unowned self] respons in
                indicator.sharedInstance.dismiss()
                guard let data = respons.value, let json = try? JSON(data: data) else { return }
                print(json)
                if json["Root"]["OUT_PARMS"]["OUT_PARMS_ROW"]["STATUS"].string == "1" {
                    if patientIdArray != nil {
                        let  vc = LitsOfPatientLogedBySameMobileNumberViewController(listOfOthers: listOfOTher, VcType: listOfOtherScreenType.fromRegister)
                        vc.delegate = self
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let vc:ConfirmAfterSignUpVC =   ConfirmAfterSignUpVC()
                        vc.patientId = self.PATIENT_ID ?? ""
                        vc.delegete = self
//                        let popup = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .zoomIn,  gestureDismissal: true)
//                        self.present(popup, animated: true, completion: nil)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    //                    Utilities.showAlert(messageToDisplay: "Plz Enter Vaild code")
                }
            }
        } else {
            let urlString = Constants.APIProvider.signupvalidateCode
            let url = URL(string: urlString)
            let parseUrl = Constants.APIProvider.signupvalidateCode + Constants.getoAuthValue(url: url!, method: "POST")
            indicator.sharedInstance.show()
            
            AF.request(parseUrl , method: .post, parameters: pars , encoding: JSONEncoding.default, headers: nil).responseData { [unowned self] respons in
                indicator.sharedInstance.dismiss()
                guard let data = respons.value, let json = try? JSON(data: data) else { return }
                print(json)
                if  json["Root"]["OUT_PARMS"]["OUT_PARMS_ROW"]["STATUS"].string == "1" {
                    if  json["Root"]["OUT_PARMS"]["OUT_PARMS_ROW"]["STATUS"].string == "1" {
                        if patientIdArray != nil {
                            let  vc = LitsOfPatientLogedBySameMobileNumberViewController(listOfOthers: listOfOTher, VcType: listOfOtherScreenType.fromRegister)
                            vc.delegate = self
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            let vc:ConfirmAfterSignUpVC = ConfirmAfterSignUpVC()
                            vc.patientId = self.PATIENT_ID ?? ""
                            vc.delegete = self
//                            let popup = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .zoomIn,  gestureDismissal: true)
//                            self.present(popup, animated: true, completion: nil)
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    } else {
                        Utilities.showAlert(messageToDisplay: "Plz Enter Vaild code")
                    }
                } else {
                    Utilities.showAlert(messageToDisplay: "Plz Enter Vaild code")
                }
            }
        }
    }
}


extension verifcationAddOtherVC: SwiftyCodeViewDelegate {
    
    func codeView(sender: SwiftyCodeView, didFinishInput code: String) -> Bool {
        self.code = code.replacingOccurrences(of: "١", with: "1" ).replacingOccurrences(of: "٢", with: "2" )
            .replacingOccurrences(of: "٠", with: "0" ).replacingOccurrences(of: "٣", with: "3" ).replacingOccurrences(of: "٤", with: "4" ).replacingOccurrences(of: "٥", with: "5" ).replacingOccurrences(of: "٦", with: "6" ).replacingOccurrences(of: "٧", with: "7" ).replacingOccurrences(of: "٨", with: "8" ).replacingOccurrences(of: "٩", with: "9" )
        
        print( self.code)
        sendCode.alpha = 1
        sendCode.isEnabled = true
        return true
    }
}


extension verifcationAddOtherVC:fromChangePass
{
    func chnagePassword() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: BHGLoginController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
}
extension UINavigationController {
    
    func removeViewController(_ controller: UIViewController.Type) {
        if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
            viewController.removeFromParentViewController()
        }
    }
}

extension UILabel {
    func setSpecificAttributes(texts: [String], fonts: [UIFont]?, colors: [UIColor]?) {
        var main = ""
        var ranges = [NSRange]()
        for sub in texts {
            main += sub
            ranges.append((main as NSString).range(of: sub))
        }
        let attribute = NSMutableAttributedString.init(string: main)
        
        if fonts != nil {
            for (i, font) in fonts!.enumerated() {
                attribute.addAttribute(NSAttributedString.Key.font, value: font, range: ranges[i])
            }
        }
        
        if colors != nil {
            for (i, color) in colors!.enumerated() {
                attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: ranges[i])
            }
        }
        self.attributedText = attribute
    }
}
