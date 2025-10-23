//
//  AccountsViewController.swift
//  CareMate
//
//  Created by Mohamed Elmaazy on 28/07/2024.
//  Copyright © 2024 khabeer Group. All rights reserved.
//

import UIKit

class AccountsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var listOfUsers = [UserMobileDTO]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHeader(isNotifcation: false, isLanguage: false, title: UserManager.isArabic ? "تغيير الحساب" : "Change Account", hideBack: false)
        getData()
        initTableView()
    }
    
    func getData() {
        let urlString = Constants.APIProvider.load_patient_accounts+"PATIENT_ID=\(Utilities.sharedInstance.getPatientId())&MOBILE=\(UserDefaults.standard.object(forKey: "PAT_TEL") as? String ?? "")"
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            if error == nil {
                if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["PAT_DATA"] as? [String:AnyObject] {
                    if root["PAT_DATA_ROW"] is [[String:AnyObject]] {
                        let users = root["PAT_DATA_ROW"] as! [[String: AnyObject]]
                        for i in users {
                            var model = UserMobileDTO()
                            model.PATIENTID = i["PATIENTID"] as? String ?? ""
                            model.COMPLETEPATNAME_EN = i["COMPLETEPATNAME_EN"] as? String ?? ""
                            model.COMPLETEPATNAME_AR = i["COMPLETEPATNAME_AR"] as? String ?? ""

                            model.PAT_TEL = i["PAT_TEL"] as? String ?? ""
                            model.years = i["PAT_AGE_YEARS"] as? String ?? ""
                            model.months = i["PAT_AGE_MONTHS"] as? String ?? ""
                            model.days = i["PAT_AGE_DAYS"] as? String ?? ""
                            model.email = i["PAT_EMAIL"] as? String ?? ""
                            if let pic = i["PAT_PIC"] as? [String: AnyObject] {
                                if let picInside = pic["PAT_PIC_ROW"] as? [String: AnyObject] {
                                    model.PAT_PIC = picInside["BLOB_PATH"] as? String ?? ""
                                }
                            }
                            self.listOfUsers.append(model)
                        }
                    } else if root["PAT_DATA_ROW"] is [String: AnyObject] {
                        let i = root["PAT_DATA_ROW"] as![String:AnyObject]
                        var model = UserMobileDTO()
                        model.PATIENTID = i["PATIENTID"] as? String ?? ""
                        model.COMPLETEPATNAME_EN = i["COMPLETEPATNAME_EN"] as? String ?? ""
                        model.COMPLETEPATNAME_AR = i["COMPLETEPATNAME_AR"] as? String ?? ""
                        model.PAT_TEL = i["PAT_TEL"] as? String ?? ""
                        model.years = i["PAT_AGE_YEARS"] as? String ?? ""
                        model.months = i["PAT_AGE_MONTHS"] as? String ?? ""
                        model.days = i["PAT_AGE_DAYS"] as? String ?? ""
                        model.email = i["PAT_EMAIL"] as? String ?? ""
                        if let pic = i["PAT_PIC"] as? [String: AnyObject] {
                            if let picInside = pic["PAT_PIC_ROW"] as? [String: AnyObject] {
                                model.PAT_PIC = picInside["BLOB_PATH"] as? String ?? ""
                            }
                        }
                        self.listOfUsers.append(model)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension AccountsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func initTableView()  {
        let cellNib = UINib(nibName: "AccoutMobileTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "AccoutMobileTableViewCell")
        tableView.rowHeight = 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfUsers.count
        
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccoutMobileTableViewCell", for: indexPath) as! AccoutMobileTableViewCell
        cell.setData(listOfUsers[indexPath.row])
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = listOfUsers[indexPath.row]
        var phoneWithoutCode = ""
        if model.PAT_TEL?.count ?? 0 > 4 {
            phoneWithoutCode = model.PAT_TEL ?? "1234"
            phoneWithoutCode.removeFirst(4)
        }
        // new change
//        if model.isUnderAgepatient() {
//            underAge(patientId: model.PATIENTID ?? "", mobile: model.PAT_TEL ?? "",user: model)
//        }else {
//            let vc = CompleteLoginWithPasswordViewController(mobile: model.PAT_TEL ?? "", patientId: model.PATIENTID ?? "", code: "6850", mobileWithoutCode: phoneWithoutCode)
//            vc.user = model
//            vc.comesFromProfile = true
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        setSelectUser(model)
        
    }
    
    func setSelectUser(_ user:UserMobileDTO) {
        currentPatientIDOrigni = user.PATIENTID ?? ""
        Utilities.sharedInstance.setPatientId(patienId: user.PATIENTID ?? "")
        UserDefaults.standard.set(Utilities.sharedInstance.getPatientId(), forKey: "Utilities.sharedInstance.getPatientId()")
        currentPatientMobile =   user.PAT_TEL ?? ""
        UserDefaults.standard.set(currentPatientMobile, forKey: "PAT_TEL")
        user.saveToUser()
//        for controller in self.navigationController!.viewControllers as Array {
//            if controller.isKind(of: UITabBarController.self) {
//                self.navigationController!.popToViewController(controller, animated: true)
//                break
//            }
//        }
        self.navigationController?.dismiss(animated: true)
//
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "homeNavNav") as! UITabBarController
//        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func underAge(patientId:String,mobile:String,code:String = "6850",user:UserMobileDTO) {
        var urlString = ""
        let password = UserDefaults.standard.string(forKey: "user_password") ?? "123456"
        
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
                                user.saveToUser()
                                self.navigationController?.dismiss(animated: true)
//                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "homeNavNav") as! UITabBarController
//                                self.navigationController?.pushViewController(nextViewController, animated: true)
                            }
                        }
                        else if loginStratues == "1"
                        {
                            if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["PAT_DATA"] as? [String:AnyObject]
                            {
                                let OUT_PARMS_ROW = root["PAT_DATA_ROW"] as!  AnyObject
                                let loginStratues =  OUT_PARMS_ROW["PATIENTID"] as? String
                                print( OUT_PARMS_ROW["PATIENTID"] as? String ?? "")
                                currentPatientIDOrigni = OUT_PARMS_ROW["PATIENTID"] as? String ?? ""
                                Utilities.sharedInstance.setPatientId(patienId: OUT_PARMS_ROW["PATIENTID"] as? String ?? "")
                                UserDefaults.standard.set(Utilities.sharedInstance.getPatientId(), forKey: "Utilities.sharedInstance.getPatientId()")
                                UserDefaults.standard.set(true, forKey: "loginOrNO")
                                user.saveToUser()
                                self.navigationController?.dismiss(animated: true)

//                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "homeNavNav") as! UITabBarController
//                                self.navigationController?.pushViewController(nextViewController, animated: true)
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


import ObjectMapper

struct UserMobileDTO : Codable {
    var PATIENTID : String?
    var COMPLETEPATNAME_AR : String?
    var COMPLETEPATNAME_EN : String?
    var PAT_TEL : String?
    var PAT_PIC : String?
    var email:String?
    var years:String?
    var months:String?
    var days: String?
    
    enum CodingKeys: String, CodingKey {
        case PATIENTID = "PATIENTID"
        case COMPLETEPATNAME_AR = "COMPLETEPATNAME_AR"
        case COMPLETEPATNAME_EN = "COMPLETEPATNAME_EN"
        case PAT_TEL = "PAT_TEL"
        case PAT_PIC = "PAT_PIC"
        case years = "PAT_AGE_YEARS"
        case months = "PAT_AGE_MONTHS"
        case days = "PAT_AGE_DAYS"
        case email = "PAT_EMAIL"
    }
    
    func isUnderAgepatient() -> Bool {
        let yrs = Int(years ?? "") ?? 0
        if yrs <= 18 {
            return true
        }
        return false
    }
    
    func saveToUser() {
        UserDefaults.standard.set(PAT_TEL ?? "", forKey: "PAT_TEL")
        
        let user1 =  LoginedUser(COMPLETEPATNAME_AR: COMPLETEPATNAME_AR ?? "" , COMPLETEPATNAME_EN: COMPLETEPATNAME_EN ?? "", PAT_TEL: PAT_TEL ?? "", PAT_EMAIL: email ?? "", PATIENTID: PATIENTID ?? "")
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user1) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "SavedPerson")
        }
        currentPatientIDOrigni = PATIENTID ?? ""
        Utilities.sharedInstance.setPatientId(patienId: PATIENTID ?? "")
        let patImage = PAT_PIC ?? ""
        UserDefaults.standard.set(patImage, forKey: "patImage")
    }
}
