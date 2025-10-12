//
//  EnterMobileForUpdatemobileNumberViewController.swift
//  CareMate
//
//  Created by Khabber on 16/01/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit
import CountryPickerView

class EnterMobileForUpdatemobileNumberViewController: BaseViewController {

    @IBOutlet weak var textFieldMobileNumber: UITextField!
    
//   var listOfOthers: listOfOTher1
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var labelMobileNumber: UILabel!
    @IBOutlet weak var viewCountrty: CountryPickerView!
    @IBOutlet weak var viewPhoneHolder: UIView!
    
    var phoneCode = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        viewCountrty.setCountryByName("Saudi Arabia")
        phoneCode = viewCountrty.selectedCountry.phoneCode
        viewCountrty.delegate = self
        if UserManager.isArabic {
            textFieldMobileNumber.transform = CGAffineTransform(scaleX: -1, y: 1)
            viewCountrty.transform = CGAffineTransform(scaleX: -1, y: 1)
            viewPhoneHolder.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
//        self.navigationController?.navigationBar.isHidden = false
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "تعديل رقم الهاتف" :"Edit Mobile Number", hideBack: false)
        title = UserManager.isArabic ? "ادخل رقم الهاتف" : "Enter Mobile Number"
        if UserManager.isArabic {
            labelMobileNumber.text = "رقم الهاتف"
            btnSubmit.setTitle("ارسال", for: .normal)
            textFieldMobileNumber.placeholder = "اكتب رقم الهاتف"
        }
        if #available(iOS 11.0, *) {
            textFieldMobileNumber.smartInsertDeleteType = .no
        }
        textFieldMobileNumber.autocorrectionType = .yes
//        mobileNumberTextField.keyboardType = .numberPad
        textFieldMobileNumber.textContentType = UITextContentType.telephoneNumber
        textFieldMobileNumber.keyboardType = .asciiCapableNumberPad
    }
    var oldMobile:String?

//    init(oldMobile: String?) {
//        self.oldMobile = oldMobile
//        super.init(nibName: "EnterMobileForUpdatemobileNumberViewController", bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }


    @IBAction func submit(_ sender: Any) {
        guard let MobileNumber = self.textFieldMobileNumber.text,
            !MobileNumber.isEmpty else {
                Utilities.showAlert(messageToDisplay: "Plz Enter Mobile Number")
                return
        }
        
     
    
        let urlString = Constants.APIProvider.validate_update_mobile_no
        
        let url = URL(string: urlString)
        let parseUrl = Constants.APIProvider.validate_update_mobile_no + "?" + Constants.getoAuthValue(url: url!, method: "POST",parameters: ["mobile":MobileNumber,"patient_id":Utilities.sharedInstance.getPatientId(),"old_mobile":oldMobile ?? "" ,"status":"1", "mobile_countery_code": phoneCode] )
       
        WebserviceMananger.sharedInstance.makeCall(method: .post, url: parseUrl, parameters: ["mobile":MobileNumber,"patient_id":Utilities.sharedInstance.getPatientId(),"old_mobile":oldMobile,"status":"1"] , vc: self) { (data, error) in
            let root = (data as! [String:AnyObject])
            
            print(root)
            print(root["Root"])
            print(type(of: root["CODE"]))
            let Code = root["CODE"] as? Int

            if root["NAME_EN"] as? String ?? "" == "OK" ||  Code == 200 || Code == 1{
                let vc :ValidateMobileNumberViewController =  ValidateMobileNumberViewController(oldMobile: self.oldMobile, newMobile: MobileNumber)
                self.navigationController?.pushViewController(vc, animated: true)
            }
//            if  root["NAME_EN"] as? String ?? "" == "OK" || Code == 200 || Code == 1
//            {
//                let vc :ValidateMobileNumberViewController =  ValidateMobileNumberViewController(oldMobile: self.oldMobile, newMobile: MobileNumber)
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//            
            if root.keys.contains("MESSAGE")
            {
                
                    let loginStatus = (((((data as! [String: Any])["Root"])as! [String: Any])["MESSAGE"] as! [String:Any])["MESSAGE_ROW"] as! [String: Any])["NAME_EN"] as! String
                        Utilities.showAlert(messageToDisplay:loginStatus)

            }
           

        }
        
    }
}
extension EnterMobileForUpdatemobileNumberViewController :CountryPickerViewDelegate{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        phoneCode = country.code
    }
    
    
}
