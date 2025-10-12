//
//  ChangePasswordController.swift
//  CareMate
//
//  Created by Yo7ia on 2/27/19.
//  Copyright © 2019 khabeer Group. All rights reserved.
//




import UIKit
class ChangePasswordController:UITableViewController {
    
    @IBOutlet weak var passwordFld: UITextField!
    
    @IBOutlet weak var confpasswordFld: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    var patientID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar.instance.setuptabBar(vc: self)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Change Password"
        //        loginBtn.applyGradient(colours: AppHelper.gradientColors)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.title = ""
    }
    
    
    @IBAction func loginClicked()
    {
        var isValid = true
        guard let password = self.passwordFld.text,
            !password.isEmpty else {
                Utilities.showAlert(messageToDisplay: "Empty Field")
                return
        }
        guard let confpassword = self.confpasswordFld.text,
            !confpassword.isEmpty else {
                Utilities.showAlert(messageToDisplay: "Empty Field")
                return
        }
            // call api to reset password
        indicator.sharedInstance.show()
        
        let pars = ["PATIENT_ID":patientID,"PASSWORD":password] as [String : String]
        let urlString = Constants.APIProvider.CHANGEPASSWORD
        let url = URL(string: urlString)
        let parseUrl = Constants.APIProvider.CHANGEPASSWORD + "?" + Constants.getoAuthValue(url: url!, method: "POST",parameters: nil)
        WebserviceMananger.sharedInstance.makeCall(method: .post, url: parseUrl, parameters: pars, vc: self) { (data, error) in
            let loginStatus = (((((data as! [String: Any])["Root"])as! [String: Any])["MESSAGE"] as! [String:Any])["MESSAGE_ROW"] as! [String: Any])["NAME_EN"] as! String
            Utilities.showSuccessAlert(self, messageToDisplay: loginStatus)
            self.navigationController?.popToRootViewController(animated: true)
        }
            
    }
    
    
    
}
