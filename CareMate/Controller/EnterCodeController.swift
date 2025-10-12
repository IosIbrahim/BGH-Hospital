//
//  EnterCodeController.swift
//  CareMate
//
//  Created by Yo7ia on 2/26/19.
//  Copyright © 2019 khabeer Group. All rights reserved.
//


import UIKit
import PinCodeTextField
import SwiftyJSON

class EnterCodeController: BaseViewController ,PinCodeTextFieldDelegate{
    @IBOutlet weak var CodeTextField: PinCodeTextField!
    
        var patientID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        CodeTextField.delegate = self
//        setupTabBar.instance.setuptabBar(vc: self)

    }
    
    @IBAction func didResendButton(sender: Any) {
        indicator.sharedInstance.show()
        
        let pars = ["PATIENT_ID":patientID] as [String : String]
        let urlString = Constants.APIProvider.VERIFYPATIENTID
        let url = URL(string: urlString)
        let parseUrl = Constants.APIProvider.VERIFYPATIENTID + "?" + Constants.getoAuthValue(url: url!, method: "POST",parameters: nil)
        WebserviceMananger.sharedInstance.makeCall(method: .post, url: parseUrl, parameters: pars, vc: self) { (data, error) in
            let root = (data as! [String:AnyObject])
            let Code = root["Code"] as! String
            if Code == "100"
            {
                Utilities.showSuccessAlert(self,messageToDisplay: "Code has been sent")
            }
            else if Code == "108"
            {
                Utilities.showAlert(messageToDisplay: root["MessageIs"] as! String )
                
            }
        }
    }
    @IBAction func didPressOkButton(sender: Any) {
        guard let medicalId = self.CodeTextField.text,
            !medicalId.isEmpty else {
                Utilities.showAlert(messageToDisplay: "Empty Field")
                return
        }
        indicator.sharedInstance.show()
        
        let pars = ["VERIFY_TEXT":medicalId,"PATIENT_ID":patientID] as [String : String]
        let urlString = Constants.APIProvider.VALIDATECODE
        let url = URL(string: urlString)
        let parseUrl = Constants.APIProvider.VALIDATECODE + "?" + Constants.getoAuthValue(url: url!, method: "POST",parameters: pars)
        WebserviceMananger.sharedInstance.makeCall(method: .post, url: parseUrl, parameters: pars, vc: self) { (data, error) in

             let loginStatus = (((((data as! [String: Any])["Root"])as! [String: Any])["OUT_PARMS"] as! [String:Any])["OUT_PARMS_ROW"] as! [String: Any])["STATUS"] as! String
                print(loginStatus)
                if loginStatus == "1"
                {
                    Utilities.showSuccessAlert(self, messageToDisplay: "Code Success , you can now reset your password , Patient ID : \(self.patientID)")
                    self.performSegue(withIdentifier: "password", sender: nil)
                }
                else if loginStatus == "2"
                {
                    Utilities.showAlert(messageToDisplay: "Invalid Code")
                }
                else if loginStatus == "3"
                {
                    Utilities.showAlert(messageToDisplay: "Expired Code , resend a new one")

                }
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "password"
        {
         let vc = segue.destination as! ChangePasswordController
            vc.patientID = self.patientID
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
