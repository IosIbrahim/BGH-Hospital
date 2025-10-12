//
//  CallerInfoViewController.swift
//  CareMate
//
//  Created by MAC on 21/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

class CallerInfoViewController: BaseViewController,UITextFieldDelegate ,ListPopupDelegate{
    

    @IBOutlet weak var uiimageType: UIImageView!
    @IBOutlet weak var lblLabVisit: UILabel!
    @IBOutlet weak var labelPatientInfo: UILabel!
    @IBOutlet weak var labelCallerNameText: UILabel!
    @IBOutlet weak var labelCallerPhoneText: UILabel!
    @IBOutlet weak var labelCallertypeText: UILabel!
    @IBOutlet weak var labelNextText: UILabel!
    @IBOutlet weak var callerPhonenumber: UITextField!
    @IBOutlet weak var uiviewNext: UIView!
    @IBOutlet weak var uiviewCallType: UIView!
    @IBOutlet weak var callerPhoneTextField: UITextField!
    @IBOutlet weak var callerNameTextField: UITextField!
    @IBOutlet weak var callTypeLabel: UITextField!
    @IBOutlet weak var uilabelCallType: UILabel!
    @IBOutlet weak var uilabelPhoneNumber: UILabel!
    @IBOutlet weak var UilabelCallerName: UILabel!
    @IBOutlet weak var viewPersonalInfo: UIView!
    @IBOutlet weak var viewRequesterNameInner: UIView!
    @IBOutlet weak var viewRequesterPhoneInner: UIView!
    @IBOutlet weak var viewRequesterTYpeInner: UIView!
    @IBOutlet weak var labelVisitHint: UILabel!
    

    var arrayBranches = [Branch]()
    var fromMedicalRecord = false
    var callerType :Bool?
    var callTypeId = ""
    var submitObject:ErCallCenterrBigModel?
    var listOfErCallCenterr = [ErCallCenterr]()
    var homeVisitAm = [homeVisitAmbulance]()
    var ErCallCenterrObject:ErCallCenterr?
    var branchId = ""
    var isLabVisit:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserManager.isArabic {
            labelPatientInfo.text = "بيانات مقدم الطلب"
        }
        viewRequesterNameInner.makeShadow(color: .black, alpha: 0.25, radius: 3)
        viewRequesterPhoneInner.makeShadow(color: .black, alpha: 0.25, radius: 3)
        viewRequesterTYpeInner.makeShadow(color: .black, alpha: 0.25, radius: 3)

        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "طلب الاسعاف" : "Book Ambulance" , hideBack: false)
        if    fromMedicalRecord == true{
//            self.navigationController?.navigationBar.isHidden = false
        }
        else{
//            self.navigationController?.navigationBar.isHidden = false

        }
        if callerType == nil
        {
            self.uiimageType.isHidden = false
        }
        else
        {
            self.uiimageType.isHidden = true

        }
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1346794665, green: 0.5977677703, blue: 0.5819112062, alpha: 1)
        callerNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        callerPhonenumber.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        callerPhonenumber.keyboardType = .asciiCapableNumberPad
        callerPhoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        setup()
//        setupTabBar.instance.setuptabBar(vc: self)

        if UserManager.isArabic
        {
            labelCallerNameText.text = "اسم مقدم الطلب"
            labelCallerPhoneText.text = "رقم هاتف مقدم الطلب"
            labelCallertypeText.text = "نوع الطلب"
            labelNextText.text = "التالي"
            callerNameTextField.placeholder = "اسم طالب الخدمة"
            callerPhonenumber.placeholder = "رقم الجوال"
            callTypeLabel.placeholder = "اختر نوع الطلب"
            

        }
        else
        {
            labelCallerNameText.text = "Requester Name"
            labelCallerPhoneText.text = "Requester Phone"
            labelCallertypeText.text = "Type"
            labelNextText.text = "Next"
            callerNameTextField.placeholder = "Requester Name"
            callerPhonenumber.placeholder = "Phone Namer"
            callTypeLabel.placeholder = "Choose Request Type"
        }
        setInitialVisitHintText()

        let defaults = UserDefaults.standard
        guard let data = defaults.object(forKey: "SavedPerson") as? Data else { return }
        let encoder = JSONDecoder()
        if let encoded = try? encoder.decode(LoginedUser.self, from: data) {
            callerNameTextField.text = UserManager.isArabic ?  encoded.COMPLETEPATNAME_AR : encoded.COMPLETEPATNAME_EN
            callerNameTextField.text = encoded.COMPLETEPATNAME_EN
            callerPhonenumber.text = encoded.PAT_TEL
            //callerPhonenumber.text = removeKuwaitPrefix(from: callerPhonenumber.text ?? "")
        }
    }
    
    //BY Hamdiiiiii ....
    func setInitialVisitHintText() {
        let fullText: String
        let redTexts: [String]
        
        if UserManager.isArabic {
            fullText = """
            خدمة الزيارة المنزلية متاحة من
            
            ٧ صباحآ - ١١ مساء

            خدمة الإسعاف متوفرة من
            
            ٧ صباحآ - ١١ مساء

            خدمة زيارة المختبر المنزلية متاحة من
            
            ٨ صباحآ - ٢ مساء
            """
            redTexts = ["٧ صباحآ - ١١ مساء", "٧ صباحآ - ١١ مساء", "٨ صباحآ - ٢ مساء"]
        } else {
            fullText = """
            Home visit service available from
            
            7am - 11pm

            Ambulance service available from
            
            7am - 11pm

            Lab home visit service available from
            
            8am - 2pm
            """
            redTexts = ["7am - 11pm", "7am - 11pm", "8am - 2pm"]
        }

        labelVisitHint.numberOfLines = 0
        let attributedString = NSMutableAttributedString(string: fullText)
        
        for redText in redTexts {
            var searchRange = fullText.startIndex..<fullText.endIndex
            while let range = fullText.range(of: redText, options: [], range: searchRange) {
                let nsRange = NSRange(range, in: fullText)
                attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: nsRange)
                searchRange = range.upperBound..<fullText.endIndex
            }
        }
        
        labelVisitHint.attributedText = attributedString
    }
    func setSingleVisitHintText(for type: String) {
        let fullText: String
        let redTexts: [String]
        
        if UserManager.isArabic {
            switch type {
            case "Home Visit":
                fullText = """
                خدمة الزيارة المنزلية متاحة من
                
                ٧ صباحآ - ١١ مساء
                """
                redTexts = ["٧ صباحآ - ١١ مساء"]
            case "Ambulance":
                fullText = """
                خدمة الإسعاف متوفرة من
                
                ٧ صباحآ - ١١ مساء
                """
                redTexts = ["٧ صباحآ - ١١ مساء"]
            case "Lab Home Visit":
                fullText = """
                خدمة زيارة المختبر المنزلية متاحة من
                
                ٨ صباحآ - ٢ مساء
                """
                redTexts = ["٨ صباحآ - ٢ مساء"]
            default:
                fullText = ""
                redTexts = []
            }
        } else {
            switch type {
            case "Home Visit":
                fullText = """
                Home visit service available from
                
                7am - 11pm
                """
                redTexts = ["7am - 11pm"]
            case "Ambulance":
                fullText = """
                Ambulance service available from
                
                7am - 11pm
                """
                redTexts = ["7am - 11pm"]
            case "Lab Home Visit":
                fullText = """
                Lab home visit service available from
                
                8am - 2pm
                """
                redTexts = ["8am - 2pm"]
            default:
                fullText = ""
                redTexts = []
            }
        }

        labelVisitHint.numberOfLines = 0
        let attributedString = NSMutableAttributedString(string: fullText)
        
        for redText in redTexts {
            var searchRange = fullText.startIndex..<fullText.endIndex
            while let range = fullText.range(of: redText, options: [], range: searchRange) {
                let nsRange = NSRange(range, in: fullText)
                attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: nsRange)
                searchRange = range.upperBound..<fullText.endIndex
            }
        }
        
        labelVisitHint.attributedText = attributedString
    }




    //BY Hamdiiiiii ....
  
    func listPopupDidSelect(index: Int, type: String) {
        if type == "gov" {
            if index == 0 {
                branchId = "1"
            } else {
                branchId = "1"
            }
            isLabVisit = index == 2
            callTypeId = homeVisitAm[index].id
            submitObject?.erCallCenterr?[0].callType = homeVisitAm[index].id
            callTypeLabel.text = UserManager.isArabic ? homeVisitAm[index].nameAr : homeVisitAm[index].nameEn
            callerType = true
            uiimageType.isHidden = callerType != nil ? true : false
            setSingleVisitHintText(for: homeVisitAm[index].nameEn)
        } else if type == "branch" {
            branchId = arrayBranches[index].id
        }
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
        if textField == callerPhonenumber {
            if textField.text?.count ?? 0 > 8 {
                callerPhonenumber.text = textField.text?.prefix(8).lowercased()
            }
        }
    }
    
    func removeKuwaitPrefix(from number: String) -> String {
        if number.hasPrefix("+965") {
            let index = number.index(number.startIndex, offsetBy: 4)
            return String(number[index...])
        } else {
            return number
        }
    }
    
    @objc func nextCliked()
    {
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: "SavedPerson") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(LoginedUser.self, from: savedPerson) {

                ErCallCenterrObject = ErCallCenterr(bufferStatus: "1", callarName: callerNameTextField.text ?? "", homePhone: callerPhonenumber.text?.convertArabicNumbers() ?? "", govID: "", cityID: "", villageCode: "", address: "hghg", newRemarks: "true", callType: callTypeId, ambulanceDocNeed: "1", ambulanceNurseNeed: "1", ambulanceCarType: "4", callPatType: "4", patientID: loadedPerson.PATIENTID)
                listOfErCallCenterr.append(ErCallCenterrObject!)
              submitObject =  ErCallCenterrBigModel(ErParmsObject:  ErParms(branchID: branchId, processID: "177961", userID: "KHABEER", computerName: "DESKTOP-LR3BK6G", inOutCity: "0"), erCallCenterrOb:listOfErCallCenterr)
                if callerType == true && callerPhonenumber.text != "" && callerNameTextField.text != ""
                {
                    var num = removeKuwaitPrefix(from: callerPhonenumber.text ?? "")
                    if checkMobileValidate(num ?? "") {
                        let vc:PatientAddressViewController = PatientAddressViewController(submitrObject: submitObject!)
                        vc.isLabHomeVisit = self.isLabVisit
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else {
                        Utilities.showAlert(messageToDisplay:UserManager.isArabic ? "من فضلك ادخل رقم هاتف صحيحا" : "Please Enter Valid Mobile Number")
                    }
                  
              
                }
                else
                {
                    Utilities.showAlert(messageToDisplay:UserManager.isArabic ? "من فضلك ادخل جميع البيانات" : "Please Enter All Data")

                }
           
        }
           

    }
        else
        {
           
            
            if callerType == true && callerPhonenumber.text != "" && callerNameTextField.text != ""
            {
                ErCallCenterrObject = ErCallCenterr(bufferStatus: "1", callarName: callerNameTextField.text ?? "", homePhone: callerPhonenumber.text ?? "", govID: "", cityID: "", villageCode: "", address: "hghg", newRemarks: "true", callType: callTypeId, ambulanceDocNeed: "1", ambulanceNurseNeed: "1", ambulanceCarType: "4", callPatType: "3", patientID: "")
                listOfErCallCenterr.append(ErCallCenterrObject!)
              submitObject =  ErCallCenterrBigModel(ErParmsObject:  ErParms(branchID: branchId, processID: "177961", userID: "KHABEER", computerName: "DESKTOP-LR3BK6G", inOutCity: "0"), erCallCenterrOb:listOfErCallCenterr)
                if checkMobileValidate(callerPhonenumber.text ?? "") {
                    let vc:PatientInfoSecondViewController = PatientInfoSecondViewController(submitrObject: submitObject!)
                    vc.isLabHomeVisit = self.isLabVisit // fixed by hamdi
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    Utilities.showAlert(messageToDisplay:UserManager.isArabic ? "من فضلك ادخل رقم هاتف صحيحا" : "Please Enter Valid Mobile Number")
                }
            }
            else
            {
                Utilities.showAlert(messageToDisplay:UserManager.isArabic ? "من فضلك ادخل جميع البيانات" : "Please Enter All Data")

            }
//            viewPersonalInfo.isHidden = true

        }
    
       
    }
    
    
    @objc func choosseHomeVisitAm()
    {
        AppPopUpHandler.instance.initListPopup(container: self, arrayNames: UserManager.isArabic ? homeVisitAm.map{$0.nameAr} : homeVisitAm.map{$0.nameEn}, title: "Choose call Type", type: "gov")
    }
    
   
    func setup()  {
        homeVisitAm.append(homeVisitAmbulance(nameEn: "Home Visit", nameAr: "زيارة منزلية", id: "2"))
        homeVisitAm.append(homeVisitAmbulance(nameEn: "Ambulance", nameAr: "سيارة إسعاف", id: "1"))
        homeVisitAm.append(homeVisitAmbulance(nameEn: "Lab Home Visit", nameAr: "زيارة منزلية للمختبر", id: "3"))

        let gestureuiviewNext = UITapGestureRecognizer(target: self, action:  #selector(self.nextCliked))
        self.uiviewNext.addGestureRecognizer(gestureuiviewNext)
        
        let gestureCallType = UITapGestureRecognizer(target: self, action:  #selector(self.choosseHomeVisitAm))
        self.uiviewCallType.addGestureRecognizer(gestureCallType)
     
        callerNameTextField.delegate = self
        callerPhonenumber.delegate = self
        callerNameTextField.rightViewMode = .always
        callerPhonenumber.rightViewMode = .always

        
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: "SavedPerson") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(LoginedUser.self, from: savedPerson) {

              
                }
              
//            viewPersonalInfo.isHidden = true
//            uilabelInfo.isHidden = true
        }
           


        else
        {
//            viewPersonalInfo.isHidden = false
//            uilabelInfo.isHidden = false
        }
     
}
    
  
   
}
extension CallerInfoViewController
{
 
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField.text == ""
//        {
//            textField.rightViewMode = .always
//            textField.rightView?.isHidden = false
//        }
//        else
//        {
//            textField.rightViewMode = .never
//            textField.rightView?.isHidden = true
//
//        }
//    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == callerPhonenumber
        {
            submitObject?.erCallCenterr?[0].homePhone = callerNameTextField.text ?? ""
        }
        if textField == callerNameTextField
        {
            submitObject?.erCallCenterr?[0].callarName = callerNameTextField.text ?? ""
        }
      
    }
    
    func getBranches() {
        Branch.getOnlineAppointment(getBranchesOnly: true) { onlineAppointments, branchesDic  in
            guard let onlineAppointments = onlineAppointments else {
                OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "خطأ في الاتصال" : "Error in connection") {
                    self.getBranches()
                }
                return
                
            }
            self.arrayBranches = onlineAppointments
            DispatchQueue.main.async {
                OPEN_LIST_POPUP(container: self, title: "", arrayNames: onlineAppointments.map({UserManager.isArabic ? $0.arabicName : $0.englishName}), dismiss: false) { index in
                    guard let index = index else { return }
                    self.branchId = self.arrayBranches[index].id
                }
            }
        }
    }
}


extension UITextField
{
    
    
    
        open override func awakeFromNib() {
            if UserManager.isArabic{
                self.textAlignment = .right
            }
            else{
                self.textAlignment = .left
            }
        }
    
}

extension UIViewController {
    func checkMobileValidate(_ mobile:String) -> Bool {
        let pre = mobile.prefix(1).lowercased()
        let starts = ["4","5","6","7","8","9"]
        return starts.contains(pre)
    }
}
   
extension String {
    func convertArabicNumbers() -> String {
        var number = self
        number = number.replacingOccurrences(of: "٠", with: "0")
        number = number.replacingOccurrences(of: "١", with: "1")
        number = number.replacingOccurrences(of: "٢", with: "2")
        number = number.replacingOccurrences(of: "٣", with: "3")
        number = number.replacingOccurrences(of: "٤", with: "4")
        number = number.replacingOccurrences(of: "٥", with: "5")
        number = number.replacingOccurrences(of: "٦", with: "6")
        number = number.replacingOccurrences(of: "٧", with: "7")
        number = number.replacingOccurrences(of: "٨", with: "8")
        number = number.replacingOccurrences(of: "٩", with: "9")
        return number
    }
}
    


