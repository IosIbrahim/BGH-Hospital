//
//  RetrieveViewController.swift
//  CareMate
//
//  Created by Mohammed Sami on 10/10/18.
//  Copyright © 2018 khabeer Group. All rights reserved.
//

import UIKit



class forgetPassVC: BaseViewController {
    
  @IBOutlet weak var medicalCodeTextField: UITextField!
    
  var patientID = ""
  var retrieveType: RetrieveType = .password

  override func viewDidLoad() {
    super.viewDidLoad()
    view.removeFromSuperview()
      
      
    if retrieveType == .medicalCode {
      title = "Retrieve Medical Code"
        medicalCodeTextField.placeholder = "Enter ID"

    }
    else
    {
        title = "Update Password"
//        medicalCodeTextField.placeholder = "Enter Patient ID"
    }
  }

  @IBAction func didPressOkButton(sender: Any) {
    
    guard let medicalId = self.medicalCodeTextField.text,
        !medicalId.isEmpty else {
            Utilities.showAlert(messageToDisplay: "Empty Field")
            return
    }
    patientID = medicalId
    if retrieveType == .medicalCode {
        
        indicator.sharedInstance.show()
        
        let pars = ["DETECT_TYPE":"3","DETECT_TEXT":medicalId] as [String : String]
        let urlString = Constants.APIProvider.GETPATIENTID
        let url = URL(string: urlString)
        let parseUrl = Constants.APIProvider.GETPATIENTID + "?" + Constants.getoAuthValue(url: url!, method: "POST",parameters: nil)
        WebserviceMananger.sharedInstance.makeCall(method: .post, url: parseUrl, parameters: pars, vc: self) { (data, error) in
            
            
            
            let loginStatus = (((((data as! [String: Any])["Root"])as! [String: Any])["OUT_PARMS"] as! [String:Any])["OUT_PARMS_ROW"] as! [String: Any])["PATIENT_ID"] as! String
            print(loginStatus)
            self.patientID = loginStatus
            self.sendCode()
        }
    }
    else
    {
        sendCode()
    }
    
  }

    func sendCode()
    {
        
        indicator.sharedInstance.show()
        
        let pars = ["PATIENT_ID":patientID] as [String : String]
        let urlString = Constants.APIProvider.VERIFYPATIENTID
        let url = URL(string: urlString)
        let parseUrl = Constants.APIProvider.VERIFYPATIENTID + "?" + Constants.getoAuthValue(url: url!, method: "POST",parameters: nil)
        WebserviceMananger.sharedInstance.makeCall(method: .post, url: parseUrl, parameters: pars, vc: self) { (data, error) in
            let root = (data as! [String:AnyObject])
            
            print(root)
            print(root["Code"])
            print(type(of: root["Code"]))
            let Code = root["Code"] as? Int
            if Code == 100
            {
                Utilities.showSuccessAlert(self,messageToDisplay: "Code has been sent")
                self.performSegue(withIdentifier: "code", sender: nil)
            }
            else if Code == 108
            {
                Utilities.showAlert(messageToDisplay: root["MessageIs"] as! String )
                
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "code"
        {
            let vc  = segue.destination as! EnterCodeController
            vc.patientID = patientID
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

