//
//  PatientInfoSecondViewController.swift
//  CareMate
//
//  Created by MAC on 21/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit
import PopupDialog
class PatientInfoSecondViewController: BaseViewController,ListPopupDelegate, DataPickerPopupDelegate,UITextFieldDelegate {
    var isLabHomeVisit: Bool = false  
    func returnDate(date: Date) {
        let now = Date()
        let birthday = date
        let calendar = Calendar.current
        

        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        let age = ageComponents.year
        submitObject?.erCallCenterr?[0].years = age
        textFieldAge.text = "\(age ?? 0)"
      
        
    }
    func timeDidAdded(day: Int, month: Int, year: Int) {
        labelBirthOfDate.text = "\(day)/\(month)/\(year)".convertArabicNumbers()
        var daystr = "\(day)"
        if day < 10 {
            daystr = "0\(day)"
        }
        var monthstr = "\(month)"
        if month < 10 {
            monthstr = "0\(month)"
        }
        submitObject?.erCallCenterr?[0].DATE_OF_BIRTH = "\(daystr)/\(monthstr)/\(year) 00:00:00".convertArabicNumbers()
        submitObject?.erCallCenterr?[0].DATE_OF_BIRTH_STR_FORMATED = "\(daystr)-\(monthstr)-\(year) 00:00:00".convertArabicNumbers()
        uiimageMaleFemale.isHidden = true
        
    }
   
    func listPopupDidSelect(index: Int, type: String) {
        if type == "Type"
        {
            submitObject?.erCallCenterr?[0].GENDER = homeVisitAm[index].id
            genderLabel.text = UserManager.isArabic ? homeVisitAm[index].nameAr :  homeVisitAm[index].nameEn
        }
    }
    
    @IBOutlet weak var labelFirstNameText: UILabel!
    @IBOutlet weak var labelSecondNameText: UILabel!
    @IBOutlet weak var labelThirdNameText: UILabel!
    @IBOutlet weak var labelLastNameText: UILabel!
    @IBOutlet weak var labelBirthOfDateText: UILabel!
    @IBOutlet weak var labelageText: UILabel!
    @IBOutlet weak var labelTypeText: UILabel!
    @IBOutlet weak var labelnextText: UILabel!
    @IBOutlet weak var uiimageMaleFemale: UIImageView!
    @IBOutlet weak var labelCallerInfoText: UILabel!

    @IBOutlet weak var labelPatientAddressText: UILabel!
    @IBOutlet weak var labelOtherInfoText: UILabel!

    @IBOutlet weak var labelPatientInfoText: UILabel!
    
    @IBOutlet weak var labelNextText: UILabel!

    @IBOutlet weak var viewPersonalInfo: UIView!

    @IBOutlet weak var LABELPATIENTINFO: UILabel!
    @IBOutlet weak var labelBirthOfDate: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var uiviewNext: UIView!
    
    @IBOutlet weak var viewGender: UIView!
    @IBOutlet weak var viewFirstName: UIView!
    @IBOutlet weak var viewSecondName: UIView!
    @IBOutlet weak var viewThirdName: UIView!
    @IBOutlet weak var viewFourName: UIView!


    @IBOutlet weak var viewBirthDate: UIView!
    @IBOutlet weak var textFieldAge: UITextField!
    
    @IBOutlet weak var textNameLastName: UITextField!
    @IBOutlet weak var textFieldThirdName: UITextField!
    @IBOutlet weak var textFieldSecondName: UITextField!
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldNickName: UITextField!
    @IBOutlet weak var viewAge: UIView!
    @IBOutlet weak var labelPatientInfo: UILabel!
    
    var submitObject:ErCallCenterrBigModel?
    var homeVisitAm = [homeVisitAmbulance]()

    init(submitrObject: ErCallCenterrBigModel) {
        super.init(nibName: "PatientInfoSecondViewController", bundle: nil)
        self.submitObject = submitrObject
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar.instance.setuptabBar(vc: self)

        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "طلب الاسعاف" : "Book Ambulance" , hideBack: false)
        setup()
        
        
        if UserManager.isArabic
        {
            labelPatientInfo.text = "بيانات المريض"
            labelFirstNameText.text = "الاسم الاول"
            labelSecondNameText.text = "الاسم الثاني"
            labelThirdNameText.text = "الاسم الثالث"
            labelLastNameText.text = "الاسم الاخير"
            labelBirthOfDateText.text = "تاريخ الميلاد"
            labelTypeText.text = "الجنس"
            labelNextText.text = "التالي"

        }
        else
        {
            labelFirstNameText.text = "First Name"
            labelSecondNameText.text = "Second Name"
            labelThirdNameText.text = "Third Name"
            labelLastNameText.text = "Last Name"

            labelBirthOfDateText.text = "Birth Of Date"
            labelTypeText.text = "Gender"
            labelNextText.text = "Next"

        }
    }


    @objc func nextCliked()
    {
        if textFieldFirstName.text != ""  && textNameLastName.text != "" && textFieldAge.text != "" && genderLabel.text != "" {
            submitObject?.erCallCenterr?[0].F_NAME = textFieldFirstName.text ?? ""
            submitObject?.erCallCenterr?[0].T_NAME = textNameLastName.text ?? ""
            submitObject?.erCallCenterr?[0].S_NAME = textNameLastName.text ?? ""
            submitObject?.erCallCenterr?[0].L_NAME = textNameLastName.text ?? ""
            // PRINT date before sending
                    if let dob = submitObject?.erCallCenterr?[0].DATE_OF_BIRTH,
                       let dobFormatted = submitObject?.erCallCenterr?[0].DATE_OF_BIRTH_STR_FORMATED {
                        print("DOB (raw):", dob)
                        print("DOB (formatted):", dobFormatted)
                    }
            let vc:PatientAddressViewController = PatientAddressViewController(submitrObject: self.submitObject!)
            vc.isLabHomeVisit = self.isLabHomeVisit  // pass flag here too
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            Utilities.showAlert(messageToDisplay:UserManager.isArabic ? "من فضلك ادخل جميع البيانات" : "Please Enter All Data")
        }
    }
   
    @objc func DateCliked() {
        textNameLastName.resignFirstResponder()
        let vc = DatePickerPopUpVC()
        vc.delegate = self
        vc.minimumAge = 13  // Apply 13-year validation only here // hamdi
        let popup = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .zoomIn, tapGestureDismissal: true)
        self.present(popup, animated: true, completion: nil)
    }


    @objc func genderCliked()
    {
        AppPopUpHandler.instance.initListPopup(container: self, arrayNames: UserManager.isArabic ? homeVisitAm.map{$0.nameAr} : homeVisitAm.map{$0.nameEn}, title: UserManager.isArabic ? "اختار جنس المريض" :"Choose Gender", type: "Type")
    }
    func setup()  {
        
        textFieldFirstName.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        textFieldSecondName.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        textFieldThirdName.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        textNameLastName.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
//        textFieldAge.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        textFieldFirstName.rightViewMode = .always
        textFieldSecondName.rightViewMode = .always
        textFieldThirdName.rightViewMode = .always
        textNameLastName.rightViewMode = .always
//        textFieldAge.rightViewMode = .always
        viewFirstName.makeShadow(color: .black, alpha: 0.14, radius: 4)
        viewSecondName.makeShadow(color: .black, alpha: 0.14, radius: 4)
        viewThirdName.makeShadow(color: .black, alpha: 0.14, radius: 4)
        viewFourName.makeShadow(color: .black, alpha: 0.14, radius: 4)
        viewGender.makeShadow(color: .black, alpha: 0.14, radius: 4)
        viewBirthDate.makeShadow(color: .black, alpha: 0.14, radius: 4)
        viewAge.makeShadow(color: .black, alpha: 0.14, radius: 4)

        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: "SavedPerson") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(LoginedUser.self, from: savedPerson) {

              
                }
              
            viewPersonalInfo.isHidden = true
//            LABELPATIENTINFO.isHidden = true
        }
           


        else
        {
            viewPersonalInfo.isHidden = false
//            LABELPATIENTINFO.isHidden = false

            

        }
    homeVisitAm.append(homeVisitAmbulance(nameEn: "Male", nameAr: "ذكر", id: "M"))
    homeVisitAm.append(homeVisitAmbulance(nameEn: "Female", nameAr: "انثي", id: "F"))
        let gestureuiviewNext = UITapGestureRecognizer(target: self, action:  #selector(self.nextCliked))
        self.uiviewNext.addGestureRecognizer(gestureuiviewNext)
        
        
        let viewGenderNext = UITapGestureRecognizer(target: self, action:  #selector(self.genderCliked))
        self.viewGender.addGestureRecognizer(viewGenderNext)
        
        let viewBirthOfDate = UITapGestureRecognizer(target: self, action:  #selector(self.DateCliked))
        self.viewBirthDate.addGestureRecognizer(viewBirthOfDate)
        textFieldFirstName.delegate = self
        textFieldSecondName.delegate = self
        textFieldThirdName.delegate = self
        textNameLastName.delegate = self
//        textFieldAge.delegate = self
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text == ""
        {
            textField.rightViewMode = .always
            textField.rightView?.isHidden = false
        }
        else
        {
            textField.rightViewMode = .never
            textField.rightView?.isHidden = true

        }
    }

}

extension PatientInfoSecondViewController: UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldFirstName {
            textNameLastName.becomeFirstResponder()
        }
        return true
    }
}
