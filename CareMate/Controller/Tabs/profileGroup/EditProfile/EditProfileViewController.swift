//
//  EditProfileViewController.swift
//  CareMate
//
//  Created by m3azy on 26/06/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

class EditProfileViewController: BaseViewController {

    @IBOutlet weak var labelPhoneNumber: UILabel!
    @IBOutlet weak var viewPhoneNumber: UIView!
    @IBOutlet weak var viewSave: UIView!

    
    @IBOutlet weak var textFieldPhonenumber: UITextField!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var imageViewEditAddress: UIImageView!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var labelFavContact: UILabel!
    @IBOutlet weak var textFieldFavContact: UITextField!
    @IBOutlet weak var viewFav: UIView!
    @IBOutlet weak var labelChange: UILabel!
    
    var userData = [String: AnyObject]()
    var arrayContact = [ContactMethodModel]()
    var contactMethod = ""
    
    init(userData: [String: AnyObject], arrayContact: [ContactMethodModel]) {
        super.init(nibName: "EditProfileViewController", bundle: nil)
        self.userData = userData
        self.arrayContact = arrayContact
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setData()
        initHeader(isNotifcation: false, isLanguage: false, title: UserManager.isArabic ? "تعديل البيانات" : "Edit data", hideBack: false)
    }
    
    func initViews() {
        viewPhoneNumber.layer.cornerRadius = 10
        viewPhoneNumber.makeShadow(color: .black, alpha: 0.14, radius: 4)
        viewAddress.layer.cornerRadius = 10
        viewAddress.makeShadow(color: .black, alpha: 0.14, radius: 4)
        viewEmail.layer.cornerRadius = 10
        viewEmail.makeShadow(color: .black, alpha: 0.14, radius: 4)
        viewFav.layer.cornerRadius = 10
        viewFav.makeShadow(color: .black, alpha: 0.14, radius: 4)
        viewFav.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseContactMethod)))
        btnSave.layer.cornerRadius = 10
        imageViewEditAddress.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editAddress)))
        viewPhoneNumber.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editPhoneNumber)))
        viewSave.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(saveVisit)))
        labelChange.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editPhoneNumber)))
        if UserManager.isArabic {
            labelEmail.text = "البريد الالكتروني"
            textFieldEmail.placeholder = "البريد الالكتروني"
            labelAddress.text = "العنوان"
            textFieldAddress.placeholder = "العنوان"
            labelPhoneNumber.text = "رقم الهاتف"
            textFieldPhonenumber.placeholder = "رقم الهاتف"
            labelFavContact.text = "جهة الاتصال المفضلة"
            textFieldFavContact.placeholder = "جهة الاتصال"
            btnSave.setTitle("حفظ البيانات", for: .normal)
            labelEmail.font = UIFont(name: "Tajawal-Bold", size: 17)
            textFieldEmail.font = UIFont(name: "Tajawal-Regular", size: 17)
            textFieldFavContact.font = UIFont(name: "Tajawal-Regular", size: 17)
            labelAddress.font = UIFont(name: "Tajawal-Bold", size: 17)
            textFieldAddress.font = UIFont(name: "Tajawal-Regular", size: 17)
            labelPhoneNumber.font = UIFont(name: "Tajawal-Bold", size: 17)
            textFieldPhonenumber.font = UIFont(name: "Tajawal-Regular", size: 17)
            btnSave.titleLabel!.font = UIFont(name: "Tajawal-Bold", size: 17)
            textFieldEmail.textAlignment = .right
            textFieldAddress.textAlignment = .right
            textFieldPhonenumber.textAlignment = .right
            labelChange.text = "تغيير"
            labelChange.font = UIFont(name: "Tajawal-Regular", size: 17)
        }
    }
    
    func setData() {
        if UserManager.isArabic {
            textFieldPhonenumber.text = userData["PATIENT"]?["CONTACT_HOMETEL_1"]  as? String
            textFieldEmail.text = userData["PATIENT"]?["CONTACT_HOMETEL_3"]  as? String
            textFieldAddress.text = userData["PATIENT"]?["PAT_ADDRESS_AR"]  as? String
        } else {
            textFieldPhonenumber.text = userData["PATIENT"]?["CONTACT_HOMETEL_1"]  as? String
            textFieldEmail.text = userData["PATIENT"]?["CONTACT_HOMETEL_3"]  as? String
            textFieldAddress.text = userData["PATIENT"]?["PAT_ADDRESS_AR"]  as? String
        }
        for item in arrayContact {
            if item.ID == userData["PATIENT"]?["PAT_PREFFER_CONTACT_ID"] as? String ?? "" {
                textFieldFavContact.text = UserManager.isArabic ? item.NAME_AR : item.NAME_EN
                contactMethod = item.ID
                break
            }
        }
    }
    
    @objc func editAddress() {
        let vc = AddAddressFromMapViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func editPhoneNumber() {
        let vc  = EnterMobileForUpdatemobileNumberViewController()
        vc.oldMobile = self.textFieldPhonenumber.text ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func save(_ sender: Any) {
        
    }
    @objc func saveVisit(sender : UITapGestureRecognizer) {
        let pars = ["rCP_MASTERINDEX": ["PATIENT_ID": Utilities.sharedInstance.getPatientId(),
                                        "CONTACT_HOMETEL_1": textFieldPhonenumber.text  ?? "",
                                        "PAT_ADDRESS": textFieldAddress.text ?? "",
                                        "PAT_ADDRESS_AR": textFieldAddress.text ?? "",
                                        "HOSP_ID": "1",
                                        "USER_ID": "KHABEER",
                                        "COMPUTER_NAME":"ios",
                                        "CONTACT_HOMETEL_3": textFieldEmail.text ?? "",
                                        "PAT_PREFFER_CONTACT_ID": contactMethod],
                    "_SEC_PARMS": ["PATIENT_ID": Utilities.sharedInstance.getPatientId(),
                                   "CONTACT_HOMETEL_1": textFieldPhonenumber.text  ?? "",
                                   "PAT_ADDRESS": textFieldAddress.text ?? "",
                                   "PAT_ADDRESS_AR": textFieldAddress.text ?? "",
                                   "HOSP_ID": "1",
                                   "USER_ID": "KHABEER",
                                   "CONTACT_HOMETEL_3": textFieldEmail.text ?? "",
                                   "COMPUTER_NAME":"ios"]
        ] as! [String : Any]
        let urlString = Constants.APIProvider.update_patientprofile
        let url = URL(string: urlString)
        //        let parseUrl = Constants.APIProvider.SubmitStepNew + Constants.getoAuthValue(url: url!, method: "POST",parameters: pars)
        print(pars)
        WebserviceMananger.sharedInstance.makeCall(method: .post, url: urlString, parameters: pars, vc: self) { (data, error) in
            
            
            let data = data as? [String:Any] ?? [String: Any]()
            let root = data["Root"] as? [String:Any] ?? [String: Any]()
            let message = root["MESSAGE"] as? [String:Any] ?? [String: Any]()
            let messageRow = message["MESSAGE_ROW"] as? [String:Any] ?? [String: Any]()
            Utilities.showAlert(messageToDisplay: "\(UserManager.isArabic ? messageRow["NAME_AR"] as? String ?? "": messageRow["NAME_EN"] as? String ?? "")")
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    //
    //
    
    @objc func chooseContactMethod() {
        AppPopUpHandler.instance.initListPopup(container: self, arrayNames: arrayContact.map({UserManager.isArabic ? $0.NAME_AR : $0.NAME_EN}), title: "", type: "contact")
    }
    
}

extension EditProfileViewController: popFromMap
{
    func popFromMapFRom(lat: Double, Lng: Double, Street: String) {
        textFieldAddress.text =  Street
        if textFieldAddress.text == "" {
            textFieldAddress.rightViewMode = .always
            textFieldAddress.rightView?.isHidden = false
        } else {
            textFieldAddress.rightViewMode = .never
            textFieldAddress.rightView?.isHidden = true
        }
    }
}

extension EditProfileViewController: ListPopupDelegate {
    
    func listPopupDidSelect(index: Int, type: String) {
        if type == "contact" {
            contactMethod = arrayContact[index].ID
            textFieldFavContact.text = UserManager.isArabic ? arrayContact[index].NAME_AR : arrayContact[index].NAME_EN
        }
    }
}
