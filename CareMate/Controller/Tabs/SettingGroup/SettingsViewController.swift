//
//  SettingsViewController.swift
//  CareMate
//
//  Created by Khabber on 27/06/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {

    @IBOutlet weak var uilableName: UILabel!
    @IBOutlet weak var uilableEmail: UILabel!
    @IBOutlet weak var userBackgroungimage: UIImageView!
    @IBOutlet weak var uilableGenerlSettingsText: UILabel!
    @IBOutlet weak var uilableLanguageText: UILabel!
    @IBOutlet weak var uilableAbout: UILabel!
    @IBOutlet weak var uilableAccount: UILabel!
    @IBOutlet weak var uilableEditProfile: UILabel!
    @IBOutlet weak var uilableLogout: UILabel!
    @IBOutlet weak var uiviewLanguage: UIView!
    @IBOutlet weak var uiviewLogout: UIView!
    @IBOutlet weak var uiviewEdit: UIView!
    @IBOutlet weak var uiviewAbout: UIView!
    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var labelAppVersion: UILabel!
    
    var userData = [String: AnyObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        userBackgroungimage.layer.cornerRadius = 20
            userBackgroungimage.clipsToBounds = true
     //   userBackgroungimage.image = userBackgroungimage.image?.withRenderingMode(.alwaysTemplate)
     //   userBackgroungimage.tintColor = UIColor.fromHex(hex: "#00ABC8")
        setPatientInfo()
        labelAppVersion.text = "\(UserManager.isArabic ? "إصدار" : "Version"): \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)"
        labelAppVersion.textAlignment = .center
    }
    override func viewWillAppear(_ animated: Bool) {
        setup()
        let imageUrl = "\(Constants.APIProvider.IMAGE_BASE)\(UserDefaults.standard.object(forKey: "patImage") as? String ?? "")"
        imageViewUser.loadFromUrl(url: imageUrl, placeHolder: "profileHome")
    }


    func setup(){
        initHeader(isNotifcation: false, isLanguage: true, title: UserManager.isArabic ? "الاعدادات" :" Settings", hideBack: true)
        if UserManager.isArabic{
            uilableLanguageText.text  = "اللغه"
            uilableGenerlSettingsText.text = "الاعدادات العامه"
            uilableAbout.text = "عن المستشفي"
            uilableLogout.text = "تسجيل الخروج"
            uilableEditProfile.text = "تعديل الحساب"
            uilableAccount.text = "حسابي"
        }
        else{
            uilableLanguageText.text  = "Language"
            uilableGenerlSettingsText.text = "General Settings"
            uilableAbout.text = "About Al- Salam"
            uilableLogout.text = "logout"
            uilableEditProfile.text = "Edit Account"
            uilableAccount.text = "My Account"
        }
        uiviewLanguage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeLanguage)))
        uiviewLogout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(login)))
        uiviewEdit.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editProfile)))
        uiviewAbout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(About)))
    }
    
    @objc func changeLanguage(){
         let vc = LanguageViewController()
         self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func login() {
        let message = UserManager.isArabic ? "هل انت متاكد من تسجيل الخروج؟" : "Are you sure you want to logout?"
        OPEN_OPTION_POPUP(container: self, message: message) { ok in
            if ok {
                var urlString = Constants.APIProvider.logout
                let params = ["PATIENT_ID": Utilities.sharedInstance.getPatientId(),
                              "MOBILEAPP_KEY": UserDefaults.standard.object(forKey: "pushToken") as? String ?? ""] as [String : Any]
                urlString = urlString.replacingOccurrences(of: " ", with: "")
                WebserviceMananger.sharedInstance.makeCall(method: .post, url: urlString, parameters: params, vc: self) { (data, error) in
//                    if error == nil {
                    let token = UserDefaults.standard.object(forKey: "pushToken") as? String ?? ""
                    let lang = UserDefaults.standard.object(forKey: "appLang") as? String ?? ""
                    let domain = Bundle.main.bundleIdentifier!
                    UserDefaults.standard.removePersistentDomain(forName: domain)
                    UserDefaults.standard.synchronize()
                    Utilities.sharedInstance.setPatientId(patienId: "")
                    currentPatientIDOrigni = ""
                    UserDefaults.standard.set(token, forKey: "pushToken")
                    UserDefaults.standard.set(lang, forKey: "appLang")
//                    UserManager.language = lang
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    if let nav = appDelegate.window!.rootViewController as? UINavigationController {
                        nav.popToRootViewController(animated: true)
                    }
//                    }
                }
            }
        }
        
        
//        if UserManager.isLoggedIn{
//            Utilities.sharedInstance.getPatientId() = ""
////            UserManager.logout()
//            let prefs = UserDefaults.standard
//            prefs.removeObject(forKey: "SavedPerson")
//
//
//            self.navigationController?.pushViewController(LoginViewController(), animated: true)
//
//        }
//        else{
//
//        }
    }
    @objc func editProfile(){
       getUserData()
    }
    @objc func About(){
        let DrugVC = AboutViewController()
        self.navigationController?.pushViewController(DrugVC, animated: true)
    }
    func getUserData() {
        var urlString = Constants.APIProvider.load_patient_data+"PATIENT_ID=\(Utilities.sharedInstance.getPatientId())"
        urlString = urlString.replacingOccurrences(of: " ", with: "")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            if error == nil {
               
                self.userData = (data as? [String: AnyObject])!
                var contactMethods = [ContactMethodModel]()
                for item in self.userData["PREFFERED_CONTACTS"] as? [[String: Any]] ?? [[:]]{
                    let model = ContactMethodModel()
                    model.ID = item["ID"] as? String ?? ""
                    model.NAME_AR = item["NAME_AR"] as? String ?? ""
                    model.NAME_EN = item["NAME_EN"] as? String ?? ""
                    contactMethods.append(model)
                }
                self.navigationController?.pushViewController(EditProfileViewController(userData:  self.userData, arrayContact: contactMethods), animated: true)
            }
        }
    }
    func setPatientInfo(){
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: "SavedPerson") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(LoginedUser.self, from: savedPerson) {
                if UserManager.isArabic == true{
                    uilableName.text = loadedPerson.COMPLETEPATNAME_AR
                    uilableName.textAlignment = .right
                }else{
                    uilableName.text = loadedPerson.COMPLETEPATNAME_EN
                    uilableName.textAlignment = .left
                }
                uilableName.textAlignment = .center

//                uilableEmail.text = loadedPerson.PAT_EMAIL
            }
        }
        else{
        }
    }
}
extension UIImage {
    func withCornerRadius(_ radius: CGFloat) -> UIImage? {
        let rect = CGRect(origin: .zero, size: self.size)

        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
        path.addClip()
        self.draw(in: rect)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return roundedImage
    }
}
