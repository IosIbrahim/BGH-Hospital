//
//  ValidateMobileNumberViewController.swift
//  CareMate
//
//  Created by Khabber on 16/01/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit
import SwiftyCodeView
import Alamofire
import SwiftyJSON
class ValidateMobileNumberViewController: BaseViewController {

    
    @IBOutlet weak var viewCode: SwiftyCodeView!
    @IBOutlet weak var sendCode: UIButton!
    @IBOutlet weak var labelEnterVerificationCode: UILabel!
    @IBOutlet weak var labelActiveUser: UILabel!
    @IBOutlet weak var secondLAbel: UILabel!
    @IBOutlet weak var btnResend: UIButton!
    
    var code = ""
    var oldMobile:String?
    var newMobile:String?
    var firstCallORSeconde = false
    var sencond = 59
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendCode.alpha = 0.7
        sendCode.isEnabled = false
        btnResend.isUserInteractionEnabled = false
        viewCode.delegate = self
        // Do any additional setup after loading the view.
        initHeader(isNotifcation: true, isLanguage: true, title: "", hideBack: false)
        if firstCallORSeconde == false{
        labelEnterVerificationCode.text = UserManager.isArabic ? "لقد تم  ارسال كود  التفعيل الي رقم \(oldMobile ?? "")" : "Verification code sent to number \(oldMobile ?? "")"
        }
        else{
            labelEnterVerificationCode.text = UserManager.isArabic ? "لقد تم  ارسال كود  التفعيل الي رقم \(newMobile ?? "")" : "Verification code sent to number \(newMobile ?? "")"
        }
        if UserManager.isArabic {
            labelActiveUser.text = "كود التحقيق"
            btnResend.setTitle("كود التحقيق لم يصل؟ إعادة الارسال", for: .normal)
            sendCode.setTitle("تأكيد", for: .normal)
            viewCode.transform = CGAffineTransform(scaleX: -1, y: 1)
            for item in viewCode.stackView.subviews {
                item.transform = CGAffineTransform(scaleX: -1, y: 1)
            }
        }
        self.timer = Timer.scheduledTimer(timeInterval: 1.0,
           target: self,
           selector: #selector(minsMintue),
           userInfo: nil,
           repeats: true)
        
        labelEnterVerificationCode.font = UIFont(name: "Tajawal-Regular", size: 17)
        labelActiveUser.font = UIFont(name: "Tajawal-Bold", size: 17)
        btnResend.titleLabel!.font = UIFont(name: "Tajawal-Regular", size: 17)
        sendCode.titleLabel!.font = UIFont(name: "Tajawal-Regular", size: 17)
    }
    init(oldMobile:String?,newMobile:String?) {
        self.oldMobile = oldMobile
        self.newMobile = newMobile
        super.init(nibName: "ValidateMobileNumberViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc  func minsMintue()
    {
        
       sencond -= 1
        secondLAbel.text  = "00:\(sencond)"
        
        if sencond == 0
        {
            sendCode.alpha = 1
            sendCode.isEnabled = true
            btnResend.isUserInteractionEnabled = true
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
  
    @IBAction func valitedCliked(_ sender: Any) {
        
      
        
        var pars : [String : String]?
        
        if firstCallORSeconde == false
        {
            pars = ["mobile":newMobile,"patient_id":Utilities.sharedInstance.getPatientId(),"old_mobile":oldMobile,"status":"2","VERIFY_TEXT":self.code] as? [String : String]
        }
        else
        {
            pars = ["mobile":newMobile,"patient_id":Utilities.sharedInstance.getPatientId(),"old_mobile":oldMobile,"status":"3","VERIFY_TEXT":self.code] as? [String : String]
        }
       
      

        let urlString = Constants.APIProvider.validate_update_mobile_no
        print(urlString)
        let url = URL(string: urlString)
        let parseUrl = Constants.APIProvider.validate_update_mobile_no + "?" + Constants.getoAuthValue(url: url!, method: "POST",parameters: nil)
        WebserviceMananger.sharedInstance.makeCall(method: .post, url: parseUrl, parameters: pars, vc: self) { (data, error) in
            let root = (data as! [String:AnyObject])
            print("Root Updated")
            print(root)
            print(root["Root"])
            print(type(of: root["CODE"]))
            let Code = root["CODE"] as? String

            if Code == "4759"
            {
                Utilities.showAlert(messageToDisplay:root["NAME_EN"] as! String)

            }
           
            let Codeint = root["CODE"] as? Int

          
            print("Codeint")

            print(Codeint)
            print("firstCallORSeconde")

            print(self.firstCallORSeconde)

          if    self.firstCallORSeconde == true
            {
              Utilities.showAlert(messageToDisplay:"Mobile Number Updated Suceesfully")
         
              
              var index = 0
              for (i, controller) in self.navigationController!.viewControllers.enumerated() {
                  if controller is MedicalRecordVC {
                      index = i
                      break
                  }
              }
              self.navigationController?.popToViewController(self.navigationController?.viewControllers[index+1] ?? PatProfileViewController(), animated: true)


            }

            if Codeint == 200 || Codeint == 1
            {
                
                if self.firstCallORSeconde == false{
                self.viewCode.code = ""

                    self.firstCallORSeconde = true

//                Utilities.showAlert(messageToDisplay:"Plz Enter The Code that send To New Mobile Number")
                    let vc = ValidateMobileNumberViewController(oldMobile: self.oldMobile,newMobile:  self.newMobile)
                    vc.firstCallORSeconde = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }

            }

        }

        
    }
    
    @IBAction func resend(_ sender: Any) {
        
        let urlString = Constants.APIProvider.validate_update_mobile_no
        
        let url = URL(string: urlString)
        let parseUrl = Constants.APIProvider.validate_update_mobile_no + "?" + Constants.getoAuthValue(url: url!, method: "POST",parameters: ["mobile":newMobile ?? "","patient_id":Utilities.sharedInstance.getPatientId(),"old_mobile":oldMobile ?? "" ,"status":"1"] )
       
        WebserviceMananger.sharedInstance.makeCall(method: .post, url: parseUrl, parameters: ["mobile":newMobile,"patient_id":Utilities.sharedInstance.getPatientId(),"old_mobile":oldMobile,"status":"1"] , vc: self) { (data, error) in
            let root = (data as! [String:AnyObject])
            
            print(root)
            print(root["Root"])
            print(type(of: root["CODE"]))
            let Code = root["CODE"] as? Int

            if root["NAME_EN"] as? String ?? "" == "OK"{
                self.sencond = 59
                self.sendCode.alpha = 0.8
                self.sendCode.isEnabled = false
                self.playTimer()
                self.btnResend.isUserInteractionEnabled = false
            }
            if Code == 1
            {
                self.sencond = 59
                self.sendCode.alpha = 0.8
                self.sendCode.isEnabled = false
                self.playTimer()
                self.btnResend.isUserInteractionEnabled = false
            }
            
            if root.keys.contains("MESSAGE")
            {
                
                    let loginStatus = (((((data as! [String: Any])["Root"])as! [String: Any])["MESSAGE"] as! [String:Any])["MESSAGE_ROW"] as! [String: Any])["NAME_EN"] as! String
                        Utilities.showAlert(messageToDisplay:loginStatus)

            }
           

        }
    }
}
extension ValidateMobileNumberViewController: SwiftyCodeViewDelegate {
    
    func codeView(sender: SwiftyCodeView, didFinishInput code: String) -> Bool {
        self.code = code.replacingOccurrences(of: "١", with: "1" ).replacingOccurrences(of: "٢", with: "2" )
            .replacingOccurrences(of: "٠", with: "0" ).replacingOccurrences(of: "٣", with: "3" ).replacingOccurrences(of: "٤", with: "4" ).replacingOccurrences(of: "٥", with: "5" ).replacingOccurrences(of: "٦", with: "6" ).replacingOccurrences(of: "٧", with: "7" ).replacingOccurrences(of: "٨", with: "8" ).replacingOccurrences(of: "٩", with: "9" )
        
      
        sendCode.alpha = 1
        sendCode.isEnabled = true
        return true
    }
}
