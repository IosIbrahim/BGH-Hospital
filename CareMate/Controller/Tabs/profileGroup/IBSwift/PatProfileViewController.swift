//
//  PatProfileViewController.swift
//  CareMate
//
//  Created by MAC on 07/09/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit
import MOLH

class PatProfileViewController: BaseViewController {

    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var laeblWelcom: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPersonalInfo: UILabel!
    @IBOutlet weak var viewBackgroundData: UIView!
    @IBOutlet weak var labelPhoneTitle: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelAddressTitle: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelEmailTitle: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelFavPersonTitle: UILabel!
    @IBOutlet weak var labelFavPerson: UILabel!
    @IBOutlet weak var labelBirthdayTitle: UILabel!
    @IBOutlet weak var labelBirthday: UILabel!
    @IBOutlet weak var viewEdit: UIView!
    @IBOutlet weak var labelEdit: UILabel!
    @IBOutlet weak var labelRelatives: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintHeightTableView: NSLayoutConstraint!
    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var labelContactTitle: UILabel!
    @IBOutlet weak var labelContact: UILabel!
    @IBOutlet weak var labelMRNTitle: UILabel!
    @IBOutlet weak var labelMRN: UILabel!
    @IBOutlet weak var viewChangeAccount: UIView!
    @IBOutlet weak var labelChangeAccount: UILabel!
    
    var userData: [String: AnyObject]?
    var dispatchGroup = DispatchGroup()
    var listOfFamilies = [familtyDTO]()
    var contactMethods = [ContactMethodModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTable()
        viewBackground.layer.cornerRadius = 20
        imgBack.layer.cornerRadius = 20
        viewBackgroundData.setBorder(color: .fromHex(hex: "#EBE8E8", alpha: 1), radius: 10, borderWidth: 1)
        viewEdit.setBorder(color: .fromHex(hex: "#2E4E8E", alpha: 1), radius: 10, borderWidth: 1)
        viewChangeAccount.setBorder(color: .fromHex(hex: "#2E4E8E", alpha: 1), radius: 10, borderWidth: 1)
        viewEdit.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editProfile)))
        viewChangeAccount.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeAccount)))
        if UserManager.isArabic {
            laeblWelcom.text = "اهلا وسهلا بك"
            laeblWelcom.font = UIFont(name: "Tajawal-Regular", size: 17)
            labelName.font = UIFont(name: "Tajawal-Bold", size: 17)
            labelPersonalInfo.text = "البيانات الشخصية"
            labelPersonalInfo.font = UIFont(name: "Tajawal-Bold", size: 17)
            labelPhoneTitle.text = "رقم الهاتف:"
            labelPhoneTitle.font = UIFont(name: "Tajawal-Bold", size: 17)
            labelPhone.font = UIFont(name: "Tajawal-Regular", size: 17)
            labelPhone.textAlignment = .right
            labelAddressTitle.text = "العنوان:"
            labelAddressTitle.font = UIFont(name: "Tajawal-Bold", size: 17)
            labelAddress.font = UIFont(name: "Tajawal-Regular", size: 17)
            labelAddress.textAlignment = .right
            labelEmailTitle.text = "البريد الالكتروني:"
            labelEmailTitle.font = UIFont(name: "Tajawal-Bold", size: 17)
            labelEmail.font = UIFont(name: "Tajawal-Regular", size: 17)
            labelEmail.textAlignment = .right
            labelFavPersonTitle.text = "الشخص المفضل:"
            labelFavPersonTitle.font = UIFont(name: "Tajawal-Bold", size: 17)
            labelFavPerson.font = UIFont(name: "Tajawal-Regular", size: 17)
            labelFavPerson.textAlignment = .right
            labelBirthdayTitle.text = "تاريخ الميلاد:"
            labelBirthdayTitle.font = UIFont(name: "Tajawal-Bold", size: 17)
            labelBirthday.font = UIFont(name: "Tajawal-Regular", size: 17)
            labelBirthday.textAlignment = .right
            labelEdit.text = "تعديل"
            labelEdit.font = UIFont(name: "Tajawal-Bold", size: 17)
            labelRelatives.text = "بيانات الاقارب"
            labelRelatives.font = UIFont(name: "Tajawal-Bold", size: 17)
            labelContactTitle.text = "طريقة الاتصال:"
            labelContactTitle.font = UIFont(name: "Tajawal-Bold", size: 17)
            labelContact.font = UIFont(name: "Tajawal-Regular", size: 17)
            labelContact.textAlignment = .right
            labelMRNTitle.text = "الرقم الطبي:"
            labelMRNTitle.font = UIFont(name: "Tajawal-Bold", size: 17)
            labelMRN.font = UIFont(name: "Tajawal-Regular", size: 17)
            labelMRN.textAlignment = .right
            labelChangeAccount.text = "تغيير الحساب"
            labelChangeAccount.font = UIFont(name: "Tajawal-Bold", size: 17)
        }
        labelContact.text = ""
        labelName.textAlignment = .center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if sucessResrve
        {
            self.tabBarController?.selectedIndex = 0
            sucessResrve = false
            return
        }
        self.navigationController?.navigationBar.isHidden = true
        scrollView.isHidden = true
        showIndicator()
        getUserData()
        getRelativesData()
        let imageUrl = "\(Constants.APIProvider.IMAGE_BASE)/\(UserDefaults.standard.object(forKey: "patImage") as? String ?? "")"
        imageViewUser.loadFromUrl(url: imageUrl, placeHolder: "profileHome")
        dispatchGroup.notify(queue: .main) {
            hideIndicator()
            self.scrollView.isHidden = false
        }
    }
    
    @objc func editProfile() {
        guard let userData = userData else { return }
        navigationController?.pushViewController(EditProfileViewController(userData: userData, arrayContact: contactMethods), animated: true)
    }
    
    @objc func changeAccount() {
        navigationController?.pushViewController(AccountsViewController(), animated: true)
    }
    
    func getUserData() {
        dispatchGroup.enter()
        var urlString = Constants.APIProvider.load_patient_data+"PATIENT_ID=\(Utilities.sharedInstance.getPatientId())"
        urlString = urlString.replacingOccurrences(of: " ", with: "")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self, showIndicator: false) { (data, error) in
            if error == nil {
                self.userData = data as? [String: AnyObject]
                self.setUserData()
            }
            self.dispatchGroup.leave()
        }
    }
    
    func getRelativesData() {
        listOfFamilies.removeAll()
        tableView.reloadData()
        dispatchGroup.enter()
        let urlString = Constants.APIProvider.load_patient_family+"PatientID=\(Utilities.sharedInstance.getPatientId())&branchID=1"
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self, showIndicator: false) { (data, error) in
            if error == nil {
                if let bigRoot = (data as? [String: Any])?["Root"] as? [String: Any] {
                    let wifes = bigRoot["WIFES"] as? [String: Any] ?? [String: Any]()
                    if wifes["WIFES_ROW"] is [[String: AnyObject]] {
                        let appoins = wifes["WIFES_ROW"] as! [[String: Any]]
                        for i in appoins {
                            var  ob = familtyDTO(JSON: i)!
                            ob.wifeSon =  "Wife"
                            self.listOfFamilies.append(ob)
                        }
                    } else if wifes["WIFES_ROW"] is [String: Any] {
                        var  ob = familtyDTO(JSON:wifes["WIFES_ROW"] as![String: Any] )!
                        ob.wifeSon = "Wife"
                        self.listOfFamilies.append(ob)
                    }
                    let sons = bigRoot["SONS"] as? [String:Any] ?? [String: Any]()
                    if sons["SONS_ROW"] is [[String:AnyObject]] {
                        let appoins = sons["SONS_ROW"] as! [[String: AnyObject]]
                        for i in appoins {
                            var  ob = familtyDTO(JSON: i)!
                            ob.wifeSon =  "Son"
                            self.listOfFamilies.append(ob)
                        }
                    } else if sons["SONS_ROW"] is [String:AnyObject] {
                        var  ob = familtyDTO(JSON:sons["SONS_ROW"] as![String:AnyObject] )!
                        ob.wifeSon = "Son"
                        self.listOfFamilies.append(ob)
                    }
                }
                if self.listOfFamilies.count == 0 {
                    self.labelRelatives.isHidden = true
                } else {
                    self.labelRelatives.isHidden = false
                    self.tableView.reloadData()
                }
            } else {
                self.labelRelatives.isHidden = true
            }
            self.constraintHeightTableView.constant = CGFloat(self.listOfFamilies.count * 100)
            self.dispatchGroup.leave()
        }
    }
    
    func setUserData() {
        if let root = userData {
            labelMRN.text = Utilities.sharedInstance.getPatientId()
           if UserManager.isArabic {
//               self.labelName.text =  root["PATIENT"]?["COMPLETEPATNAME"]  as? String
               if UserManager.isArabic {
                   self.labelName.text =  root["PATIENT"]?["COMPLETEPATNAME"]  as? String
               }else {
                   self.labelName.text =  root["PATIENT"]?["COMPLETEPATNAME_EN"]  as? String
               }
               labelPhone.text = root["PATIENT"]?["CONTACT_HOMETEL_1"]  as? String
               labelEmail.text = root["PATIENT"]?["CONTACT_HOMETEL_3"]  as? String
               labelBirthday.text = "".formateDAte(dateString: root["PATIENT"]?["DATEOFBIRTH"]  as? String, formateString: "MM/dd/yyyy")
               labelAddress.text = root["PATIENT"]?["PAT_ADDRESS_AR"]  as? String
           } else {
               self.labelName.text =  root["PATIENT"]?["COMPLETEPATNAME_EN"]  as? String
               labelPhone.text = root["PATIENT"]?["CONTACT_HOMETEL_1"]  as? String
               labelEmail.text = root["PATIENT"]?["CONTACT_HOMETEL_3"]  as? String
               labelBirthday.text = "".formateDAte(dateString: root["PATIENT"]?["DATEOFBIRTH"]  as? String, formateString: "MM/dd/yyyy")
               labelAddress.text = root["PATIENT"]?["PAT_ADDRESS_AR"]  as? String
           }
            let contactId = root["PATIENT"]?["PAT_PREFFER_CONTACT_ID"] as? String ?? ""
            contactMethods.removeAll()
            for item in root["PREFFERED_CONTACTS"] as? [[String: Any]] ?? [[:]]{
                let model = ContactMethodModel()
                model.ID = item["ID"] as? String ?? ""
                model.NAME_AR = item["NAME_AR"] as? String ?? ""
                model.NAME_EN = item["NAME_EN"] as? String ?? ""
                contactMethods.append(model)
                if model.ID == contactId {
                    labelContact.text = UserManager.isArabic ? model.NAME_AR : model.NAME_EN
                }
            }
        }
    }
}

class ContactMethodModel {
    var ID = ""
    var NAME_AR = ""
    var NAME_EN = ""
}
