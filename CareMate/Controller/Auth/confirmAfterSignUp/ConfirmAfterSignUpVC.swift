//
//  ConfirmAfterSignUpVC.swift
//  CareMate
//
//  Created by mostafa gabry on 3/22/21.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol fromChangePass {
    func chnagePassword()
}
class ConfirmAfterSignUpVC: BaseViewController {

    @IBOutlet weak var repeatPasswordField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var labelEnterPassword: UILabel!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var labelhint: UILabel!
    
    var delegete:fromChangePass?
    var patientId = ""
    var patientName = ""
    
    override func viewDidLoad() {
        initHeader(isNotifcation: false, isLanguage: false, title: "", hideBack: false)
        super.viewDidLoad()
        if UserManager.isArabic {
            labelEnterPassword.text = "تغيير كلمة المرور"
            passwordTextField.placeholder = "كلمة المرور الجديدة"
            repeatPasswordField.placeholder = "تأكيد كلمة المرور الجديدة"
            btnOk.setTitle("تأكيد", for: .normal)
            labelhint.text = "تنبيه: يجب ان يكون لكل حساب من افراد العائلة كلمة مرور محتلفة."
        }
        labelEnterPassword.font = UIFont(name: "Tajawal-Regular", size: 17)
        if !patientName.isEmpty {
            let welcome = UserManager.isArabic ? "مرحبا \(patientName)":"Welcome \(patientName)"
            let msg = "\(labelEnterPassword.text!)\n\(welcome)"
        }
    }

    @IBAction func confirmChangePassword(_ sender: Any) {
        if passwordTextField.text?.count ?? 0 < 6 {
            Utilities.showAlert(messageToDisplay: UserManager.isArabic ? "كلمة المرور يجب الا تقل عن 6 عناصر" : "The password shouldn't be less than 6 digits.")
            return
        } else if passwordTextField.text != repeatPasswordField.text {
            Utilities.showAlert(messageToDisplay: UserManager.isArabic ? "كلمتا المرور يجب ان يكونا متطابقتين" : "THe passwords should be identical")
            return
        }
        if (!(repeatPasswordField.text?.isEmpty ?? true) && !(passwordTextField.text?.isEmpty ?? true)) {
            let pars = ["PASSWORD": passwordTextField.text!,
                        "PATIENT_ID": patientId]
            let urlString = Constants.APIProvider.submit_patient_password
            let url = URL(string: urlString)
            let parseUrl = Constants.APIProvider.submit_patient_password + Constants.getoAuthValue(url: url!, method: "POST")
            indicator.sharedInstance.show()
            view.isUserInteractionEnabled = false
        AF.request(parseUrl , method: .post, parameters: pars , encoding: JSONEncoding.default, headers: nil).responseData { [unowned self] respons in
                indicator.sharedInstance.dismiss()
                self.view.isUserInteractionEnabled = true
                guard let data = respons.value, let json = try? JSON(data: data) else { return }
                print(json)
                if let code = json["Root"]["MESSAGE"]["MESSAGE_ROW"]["CODE"].string { if code == "500" {
//                    self.view.showToast(toastMessage: UserManager.isArabic ? "يوجد خطأ في الرسائل" : "There Is An Error in Messages", duration: 2)
                        Utilities.showAlert(messageToDisplay: UserManager.isArabic ? "يوجد خطأ في الرسائل" : "There Is An Error in Messages")
                } else if code == "1" {
                    Utilities.showAlert(messageToDisplay: UserManager.isArabic ? "تم الحفظ بنجاح" : "Save sucess")
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: BHGLoginController.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                } else {
                    Utilities.showAlert(messageToDisplay: UserManager.isArabic ?  json["Root"]["MESSAGE"]["MESSAGE_ROW"]["NAME_AR"].string ?? "" : json["Root"]["MESSAGE"]["MESSAGE_ROW"]["NAME_EN"].string ?? "")
                    }
                }
            }
        } else {
            Utilities.showAlert(messageToDisplay: UserManager.isArabic ? "من فضلك اكمل البيانات" : "Empty Field")
//            self.view.showToast(toastMessage: UserManager.isArabic ? "من فضلك اكمل البيانات" : "Empty Field", duration: 2)
        }
    }
}
