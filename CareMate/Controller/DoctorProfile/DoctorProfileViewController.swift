//
//  DoctorProfileViewController.swift
//  CareMate
//
//  Created by Mohamed Elmaazy on 29/01/2023.
//  Copyright © 2023 khabeer Group. All rights reserved.
//

import UIKit

class DoctorProfileViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewDoctor: UIImageView!
    @IBOutlet weak var labelSpeciality: UILabel!
    @IBOutlet weak var labelBranch: UILabel!
    @IBOutlet weak var labelAbout: UILabel!
    @IBOutlet weak var uilabelSpkenLan: UILabel!
    @IBOutlet weak var labelAboutDoctorTITLE: UILabel!
    @IBOutlet weak var labelSecializedInTitle: UILabel!
    @IBOutlet weak var uilabelSpkenLanText: UILabel!
    @IBOutlet weak var labelReserve: UILabel!
    @IBOutlet weak var viewReerve: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelTitleSpec: UILabel!
    @IBOutlet weak var labelName2: UILabel!
    
    var branchID: String?
    var doctor: Doctor?
    var branch: Branch?
    var specialityID:String?
    var DocName: String?
    var docID: String?
    var clincID: String?
    var clinicName: String?
    var noReservation = false
    var clinicPhoneNumber = ""
    var clinicLetter = ""
    var selectedBranches = [Branch]()
    var isSelected:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHeader(title: UserManager.isArabic ? "بيانات الطبيب" : "Doctor details")
        getData()
        let url = URL(string: "\(Constants.APIProvider.IMAGE_BASE)\(doctor?.DOCTOR_PIC ?? "")")
        print("http://172.25.26.140/mobileApi/\(doctor?.DOCTOR_PIC ?? "")")
        imageViewDoctor.kf.setImage(with: url, placeholder: UIImage(named: doctor?.GENDERCODE ?? "M" == "M" ? "RectangleMan" : "RectangleGirl"))
        if UserManager.isArabic {
            labelAboutDoctorTITLE.text = "عن الطبيب:"
            labelSecializedInTitle.text = "متخصص في:"
            uilabelSpkenLanText.text = "لغة التواصل:"
            labelReserve.text = "حجز موعد"
        }
        if !selectedBranches.isEmpty {
            branch = selectedBranches.first
        }
        viewReerve.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reserve)))
        labelName.text = DocName
        labelName2.text = DocName
        labelName.textAlignment = .center
        labelBranch.text = branch?.getName()
    }
    
    func getData() {
        scrollView.isHidden = true
        let parseUrl = "\(Constants.APIProvider.doctorProfiledata)branch=\(branchID ?? "")&emp_id=\(doctor?.id ?? "")"
        indicator.sharedInstance.show()
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: parseUrl, parameters: nil, vc: self) { (data, error) in
            if error == nil {
                self.scrollView.isHidden = false
                if let model = ((data as? [String: AnyObject])?["EMP_BIOGRAPHY"] as? [String:AnyObject])?["EMP_BIOGRAPHY_ROW"] as? [String: AnyObject] {
                    self.labelSpeciality.text = (UserManager.isArabic ? model["SPECIALTY_NAME_AR"] as? String : model["SPECIALTY_NAME_EN"] as? String) ?? ""
                    self.labelTitleSpec.text = (UserManager.isArabic ? model["SPECIALTY_NAME_AR"] as? String : model["SPECIALTY_NAME_EN"] as? String) ?? ""
                    self.labelTitleSpec.textAlignment = .center
                    self.labelBranch.text = (UserManager.isArabic ? model["PLACE_AR"] as? String : model["PLACE_EN"] as? String) ?? ""
                    if let loc = model["PLACE_AR"] as? String {
                        self.branch?.arabicName = loc
                    }else {
                        self.branch?.arabicName = "كل الفروع"
                    }
                    if let locEn = model["PLACE_EN"] as? String {
                        self.branch?.englishName = locEn
                    }else {
                        self.branch?.englishName = "All Branches"
                    }
                    
                    self.labelAbout.stringFromHtml(htmlString: (UserManager.isArabic ? model["EMP_BIO_DESC_AR"] as? String : model["EMP_BIO_DESC_EN"] as? String) ?? "")
                    self.labelAbout.font = UIFont(name: "Tajawal-Regular", size: 15)
                }
                if let languagesParent = (data as? [String: AnyObject])?["HREMPLOYEELANGUAGE"] as? [String: AnyObject] {
                    if let language = languagesParent["HREMPLOYEELANGUAGE_ROW"] as? [String: AnyObject] {
                        self.uilabelSpkenLan.text = UserManager.isArabic ?  language["LANG_AR"] as? String ?? "" : language["LANG_EN"] as? String ?? ""
                    } else if let languages = languagesParent["HREMPLOYEELANGUAGE_ROW"] as? [[String: AnyObject]] {
                        var string = ""
                        for language in languages {
                            string += "\(UserManager.isArabic ?  language["LANG_AR"] as? String ?? "" : language["LANG_EN"] as? String ?? ""), "
                        }
                        if string.count > 0 {
                            string.removeLast(2)
                        }
                        self.uilabelSpkenLan.text = string
                    }
                }
            }
        }
    }
    
    @objc func reserve() {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "loginOrNO") ==  false {
            let msg = UserManager.isArabic ? "يجب عليك تسجيل الدخول للمتابعة مع حجزك":"You Must Login First To Continue"
            OPEN_HINT_POPUP(container: self, message: msg) {
                self.navigationController?.pushViewController(BHGLoginController(), animated: true)
            }
        }
        else if noReservation {
            AppPopUpHandler.instance.openPopup(container: self, vc: ContactDoctorPopupViewController(phoneNumber: clinicPhoneNumber, place: clinicLetter))
        } else {
            if doctor?.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW?.count ?? .zero > 1 {
                if !isSelected {
                    openBranches()
                    return
                }
            }
            let doctorProfileVC = DcotorSlotsViewController()
            doctorProfileVC.doctor = doctor
            doctorProfileVC.branchID = branchID
            doctorProfileVC.branch = branch
            doctorProfileVC.specialityID = specialityID
            doctorProfileVC.DocName = DocName
            doctorProfileVC.docID = docID
            doctorProfileVC.clincID = clincID
            doctorProfileVC.clicnName = clinicName
            doctorProfileVC.doctor?.clinicId = doctorProfileVC.clincID
            let url = URL(string: "\(Constants.APIProvider.IMAGE_BASE)\(doctor?.DOCTOR_PIC ?? "")")
            doctorProfileVC.url = url
            isSelected = false
            self.navigationController?.pushViewController(doctorProfileVC, animated: true)
        }
    }
    
    func openBranches() {
        var names = [String]()
        let itms = doctor?.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW ?? []
        for (i,item) in itms.enumerated() {
            for itm in selectedBranches {
                if item.HOSP_ID == itm.id {
                    names.append(item.getName() + " - " +  itm.getName())
                    break
                }
            }
        }
        OPEN_LIST_POPUP(container: self, arrayNames: names) { index in
            guard let index else { return }
            self.clincID =  self.doctor?.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW?[index].CLINIC_ID ?? ""
            self.doctor?.clinicId = self.clincID
            self.clinicName = UserManager.isArabic ? self.doctor?.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW?[index].CLINIC_NAME_AR ?? "" : self.doctor?.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW?[index].CLINIC_NAME_EN ?? ""
            self.noReservation =  self.doctor?.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW?[index].NO_RESERVATION_ONLINE_ONLY_TEL ?? "" == "1"
            self.clinicPhoneNumber = self.doctor?.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW?[index].CLINIC_PHONE_NUMBER ?? ""
            self.clinicLetter = UserManager.isArabic ? self.doctor?.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW?[index].CLINIC_LETTER ?? "" : self.doctor?.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW?[index].CLINIC_LETTER_EN ?? ""
            for item in self.selectedBranches {
                if self.doctor?.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW?[index].HOSP_ID == item.id {
                    self.branch = item
                    self.branchID = item.id 
                    break
                }
            }
      //      self.branch?.id = self.doctor?.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW?[index].HOSP_ID ?? ""
            self.labelBranch.text = self.branch?.getName()
            self.isSelected = true
            self.reserve()
        }
    }
}
