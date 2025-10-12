//
//  SignUpAsGuestVC.swift
//  CareMate
//
//  Created by mostafa gabry on 3/17/21.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit
import PopupDialog
import DropDown
import MZFormSheetController
import CountryPickerView
import JNPhoneNumberView

struct identityNameID {
    var nameAr = ""
    var nameEn = ""

    var id  = ""
}
class SignUpAsGuestVC: BaseViewController {
    
    @IBOutlet weak var Confirm: UILabel!
    @IBOutlet weak var civilView: RoundUIView!
    @IBOutlet weak var identityLabel: UILabel!
    @IBOutlet weak var birthDAteLAbel: UILabel!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var civilIdTextField: UITextField!
    @IBOutlet weak var fullNameLabel: UITextField!
    @IBOutlet weak var DateOfBirthClikedView: RoundUIView!
//    @IBOutlet weak var MobileNumberLabel: UITextField!
    @IBOutlet weak var identityView: RoundUIView!
    @IBOutlet weak var confirmBooking: RoundUIView!
    @IBOutlet weak var viewMale: UIView!
    @IBOutlet weak var viewFemale: UIView!
    @IBOutlet weak var viewName: RoundUIView!
    @IBOutlet weak var viewMobilr: RoundUIView!
    @IBOutlet weak var viewCountry: CountryPickerView!
    @IBOutlet weak var labelMale: UILabel!
    @IBOutlet weak var labelFemale: UILabel!
    
    
    var SelectedDoctorFromSearch : makeAppointment?
    var gender = ""
    var identitty = ""
    var phoneCode = ""
    var dateString = ""
    var agreeDisAgree =  false
    var identies = [identityNameID]()
    var userLoginn:LoginedUser?
    var arrayOfIdenties = [IdenttypeRow]()
    var dropDown = DropDown()
    var selectedCountry: Country?
    var guestName = ""
    var guestPhone = ""
    var guestPhoneCode = ""
    var guestGender = ""
    var isScedule = false
    var guestBithDate = ""
    var guestIdentityType = ""
    var guestSSN = ""
    var clinicName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCountry.setCountryByName("Saudi Arabia")
        selectedCountry = viewCountry.selectedCountry
        phoneCode = viewCountry.selectedCountry.phoneCode
        viewCountry.delegate = self
        
        initHeader(isNotifcation: false, isLanguage: true, title: UserManager.isArabic ? "تسجيل بيانات المريض" :"Patient Details", hideBack: false)
        viewMale.layer.cornerRadius = 10
        viewMale.makeShadow(color: .black, alpha: 0.14, radius: 4)
        viewFemale.layer.cornerRadius = 10
        viewFemale.makeShadow(color: .black, alpha: 0.14, radius: 4)
        viewName.layer.cornerRadius = 10
        viewName.makeShadow(color: .black, alpha: 0.14, radius: 4)
        viewMobilr.layer.cornerRadius = 10
        viewMobilr.makeShadow(color: .black, alpha: 0.14, radius: 4)
        DateOfBirthClikedView.layer.cornerRadius = 10
        DateOfBirthClikedView.makeShadow(color: .black, alpha: 0.14, radius: 4)
        identityView.layer.cornerRadius = 10
        identityView.makeShadow(color: .black, alpha: 0.14, radius: 4)
        civilView.layer.cornerRadius = 10
        civilView.makeShadow(color: .black, alpha: 0.14, radius: 4)
        maleCliked()
        if #available(iOS 11.0, *) {
            mobileNumberTextField.smartInsertDeleteType = .no
        }
        mobileNumberTextField.autocorrectionType = .yes
//        mobileNumberTextField.keyboardType = .numberPad
        mobileNumberTextField.textContentType = UITextContentType.telephoneNumber
        mobileNumberTextField.keyboardType = .asciiCapableNumberPad
        if UserManager.isArabic
        {
            fullNameLabel.placeholder = "الاسم بالكامل"
            fullNameLabel.textAlignment = .right
            mobileNumberTextField.placeholder = "رقم الهاتف"
            mobileNumberTextField.textAlignment = .right
            
            birthDAteLAbel.text = "تاريخ الميلاد"
            identityLabel.text = "نوع الهويه"
//
            civilIdTextField.placeholder = "رقم الهويه"
            civilIdTextField.textAlignment = .right
            labelMale.text = "ذكر"
            labelFemale.text = "انثي"
            Confirm.text = "تأكيد"

        }
        else
        {
            fullNameLabel.placeholder = "Full Name"
            fullNameLabel.textAlignment = .left
            mobileNumberTextField.placeholder = "Phone Number"
            mobileNumberTextField.textAlignment = .left
            
            birthDAteLAbel.text = "Date of birth"
            identityLabel.text = "Identity Type"
            civilIdTextField.placeholder = "Civil ID"

            civilIdTextField.textAlignment = .left

            Confirm.text = "Confirm"



        }
        let  identi1 = identityNameID(nameAr:  "الرقم القومى", nameEn: "SSN", id: "4")
        
        let  identi2 = identityNameID(nameAr: "البطاقة المدنية", nameEn: "ID", id: "6")

        let  identi3 = identityNameID(nameAr: "رقم الهوية", nameEn: "Civil ID" , id: "2")

        let  identi4 = identityNameID(nameAr: "لم يستخرج", nameEn: "No identity", id: "5")
        identies.append(identi1)
        identies.append(identi2)

        identies.append(identi3)

        identies.append(identi4)

        mobileNumberTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        uiInit()
        if UserManager.isArabic {
            viewMobilr.transform = CGAffineTransform(scaleX: -1, y: 1)
            viewCountry.transform = CGAffineTransform(scaleX: -1, y: 1)
            mobileNumberTextField.transform = CGAffineTransform(scaleX: -1, y: 1)
            mobileNumberTextField.textAlignment = .left
            viewCountry.initWithArabic()
        }
        
        if isScedule {
            viewMale.isUserInteractionEnabled = false
            viewFemale.isUserInteractionEnabled = false
            if guestGender.lowercased() == (UserManager.isArabic ? "ذكر" : "male") {
                maleCliked()
            } else {
                femaleCliked()
            }
            fullNameLabel.text = guestName
            fullNameLabel.isUserInteractionEnabled = false
            mobileNumberTextField.text = guestPhone
            mobileNumberTextField.isUserInteractionEnabled = false
            viewCountry.setCountryByPhoneCode(guestPhoneCode)
            viewCountry.isUserInteractionEnabled = false
            DateOfBirthClikedView.isUserInteractionEnabled = false
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let myString = formatter.string(from: guestBithDate.ConvertToDate)
            
            
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "dd-MM-yyyy"
            let myString1 = formatter1.string(from: guestBithDate.ConvertToDate)
            birthDAteLAbel.text = myString1
            dateString = myString
            
            
            
            identityView.isUserInteractionEnabled = false
            identityLabel.text = guestIdentityType
            civilIdTextField.text = guestSSN
            civilIdTextField.isUserInteractionEnabled = false
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == mobileNumberTextField {
            if textField.text?.count ?? 0 > 8 {
                mobileNumberTextField.text = textField.text?.prefix(8).lowercased()
            }
        }
    }
    
    
    @IBAction func opernTermsAndConditions(_ sender: Any) {
        
        let vc = termsAndConditionVC()
        vc.typePrivacyPolicy = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
//    @IBAction func termissAndConditionsCliked(_ sender: Any) {
//        if agreeDisAgree == false
//        {
//            agreeDisAgree =  true
//            termsConditionsImage.image = UIImage(named: "dignosisSelected.png")
//        }
//        else
//        {
//            agreeDisAgree =  false
//            termsConditionsImage.image = UIImage(named: "additinakDataDiagnosisSeleected.png")
//
//
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard

//        self.navigationController?.navigationBar.isHidden = false

//           self.navigationItem.setHidesBackButton(false, animated: false)
        

        if let savedPerson = defaults.object(forKey: "identityArray") as? Data {
            let decoder = JSONDecoder()
            
            
            if let loadedPerson = try? decoder.decode([IdenttypeRow].self, from: savedPerson) {
              
                let arr =  loadedPerson.map{UserManager.isArabic ? $0.nameAr : $0.nameEn}
                
                arrayOfIdenties = loadedPerson
                
                if UserManager.isArabic
                {
                    dropDown.dataSource =  arr as! [String]
                }

                else
                {
                    dropDown.dataSource = arr as! [String]

                }
                
            }
        }
        else
        {
          

        }
        
//            initHeader(isNotifcation: false, isLanguage: false)
            super.viewWillAppear(animated)
    }
    
    func uiInit()  {
//        MaleInner.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        femaleInner.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        dropDown.anchorView = identityView
        
      
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(maleCliked))
        viewMale.addGestureRecognizer(gesture)
        
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(femaleCliked))
        viewFemale.addGestureRecognizer(gesture1)
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(DateCliked))
        self.DateOfBirthClikedView.addGestureRecognizer(gesture2)
        
        let gesture4 = UITapGestureRecognizer(target: self, action:  #selector(identityCliked))
        self.identityView.addGestureRecognizer(gesture4)
        
        let gesture5 = UITapGestureRecognizer(target: self, action:  #selector(confirmBookingfunc))
        self.confirmBooking.addGestureRecognizer(gesture5)
        
        
    }
    @objc func maleCliked()
    {
        
        viewMale.setBorder(color: .fromHex(hex: "#1A9A8C", alpha: 1), radius: 10, borderWidth: 1)
        viewFemale.setBorder(color: .clear, radius: 10, borderWidth: 0)
        gender = "M"
        
    }
    @objc func femaleCliked()
    {
        viewFemale.setBorder(color: .fromHex(hex: "#1A9A8C", alpha: 1), radius: 10, borderWidth: 1)
        viewMale.setBorder(color: .clear, radius: 10, borderWidth: 0)
        gender = "F"
    }
    
   
    
    @objc func identityCliked()
    {
       
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
           
            self.identitty = arrayOfIdenties[index].id ?? ""
//            civilIdTextField.text =  UserManager.isArabic ?  arrayOfIdenties[index].nameEn ?? "" : arrayOfIdenties[index].nameAr ?? ""
            if let noIndetity = arrayOfIdenties[index].noIdentityFlag
            {
                if noIndetity == "1"
                {
                    civilView.isHidden = true
                }
                else
                {
                    civilView.isHidden = false

                }
            }
            else
            {
                civilView.isHidden = false

            }
//
            self.identityLabel.text = UserManager.isArabic ? arrayOfIdenties[index].nameAr : arrayOfIdenties[index].nameEn
            self.civilIdTextField.placeholder =  UserManager.isArabic ?  arrayOfIdenties[index].nameAr ?? "" : arrayOfIdenties[index].nameEn ?? ""
            
            
        }
    }
    
    @objc func DateCliked()
    {
        let vc:DatePickerPopUpVC =   DatePickerPopUpVC()
        vc.delegate = self

        let popup = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .zoomIn,  tapGestureDismissal: true)
        self.present(popup, animated: true, completion: nil)
    }
    
    @objc func confirmBookingfunc()
    {
        
//        if agreeDisAgree == false
//        {
//            Utilities.showAlert(messageToDisplay: "Please Confitrm Terms And Conditions")
//
//            
//            return
//        }
        
//        "dateofbirth" -> "17-03-2010 00:00:00"
//        "PAT_NAME" -> "mohamed abdelwahab"
        
        guard   fullNameLabel.text != "" else {
            
            
            Utilities.showAlert(messageToDisplay: UserManager.isArabic ? "من فضلك اكتب الاسم بالكامل" : "Please write full Name")
                           return
           }
//        if !JNPhoneNumberUtil.isPhoneNumberValid(phoneNumber: mobileNumberTextField.text!, defaultRegion: selectedCountry?.code ?? "") {
//            OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "رقم الهاتف غير صحيح" : "Mobile number is not correct")
//            return
//        }
        guard   mobileNumberTextField.text != "" else {
            Utilities.showAlert(messageToDisplay: UserManager.isArabic ? "من فضلك اكتب رقم الهاتف" : "Please write mobile Number")
               return
           }
        
        guard  dateString != "" else {
            
            Utilities.showAlert(messageToDisplay: UserManager.isArabic ? "الرجاء ادخال تاريخ الميلاد" : "Please choose the date")

               return
           }
//        guard  identitty != "" else {
//
//            Utilities.showAlert(messageToDisplay: UserManager.isArabic ? "من فضلك اختر الهوية" : "Please choose the identitty")
//
//               return
//           }
//
//        guard   civilIdTextField.text != "" else {
//
//            Utilities.showAlert(messageToDisplay: "please Write civilId")
//
//               return
//           }
        
//        var pars1 = [String:Any]
        
    
     
//        NO_IDENTITY_FLAG
        if !checkMobileValidate(mobileNumberTextField.text ?? "")  {
            Utilities.showAlert(messageToDisplay:UserManager.isArabic ? "من فضلك ادخل رقم هاتف صحيحا" : "Please Enter Valid Mobile Number")
            return
        }
      
        var pars = ["BRANCH_ID":SelectedDoctorFromSearch!.branchID ,
                    "COMPUTER_NAME":"ios" ,
                    "SERV_TYPE":"1",
                    "DETECT_TYPE":"1",
                    "PAT_NAME":fullNameLabel.text ?? "",
                    "dateofbirth" : dateString,
                    "PAT_TEL":mobileNumberTextField.text ?? "",
                    "PAT_SSN":civilIdTextField.text ?? "" ,
                    "GENDER":gender,
                    "CLINIC_ID": SelectedDoctorFromSearch!.doctor!.clinicId! ,
                    "SHIFT_ID": SelectedDoctorFromSearch!.shiftID,
                    "SCHED_SERIAL": SelectedDoctorFromSearch!.scheduleSerial,
                    "DOC_ID": SelectedDoctorFromSearch!.doctor!.id!,
                    "SPEC_ID": SelectedDoctorFromSearch!.specialityID,
                    "buffer_status": isReschedule ? "2" : "1",
                    "dateDone": SelectedDoctorFromSearch!.dateDone,
                    "EXPECTEDDONEDATE": SelectedDoctorFromSearch!.dateDone,
                    "EXPECTED_END_DATE": SelectedDoctorFromSearch!.dateDoneEnd,
                    "TELEPHONE_COUNTRY_CODE": phoneCode
        ] as [String : String]
        if identitty != "" {
            pars.updateValue(identitty, forKey: "IDIN_TYPE")
        }
        print(pars)
        if isReschedule {
            pars.updateValue(reservationID, forKey: "SER")
        }
//        UserModel.PatientRequest(vc: self, data: pars) { (dat) in
//            self.navigationController?.popToRootViewController(animated: false)
//
//        }
        let urlString = Constants.APIProvider.SubmitAppointment
        let url = URL(string: urlString)
        let parseUrl = Constants.APIProvider.SubmitAppointment + Constants.getoAuthValue(url: url!, method: "POST",parameters: pars)
        WebserviceMananger.sharedInstance.makeCall(method: .post, url: parseUrl, parameters: pars, vc: self) { (data, error) in
            let root = (data as! [String:AnyObject])["Root"] as? [String: AnyObject] ?? [:]
            print(root)
            if root.keys.contains("OUT_PARMS") {
                let messageRow = (root["OUT_PARMS"] as! [String: AnyObject])["OUT_PARMS_ROW"] as! [String : AnyObject]
                let englishMsg = messageRow["SER"] as? String ?? ""
                self.SelectedDoctorFromSearch!.reservationID = englishMsg
                let vc = ReservationSuccessVC()
                vc.delegate = self
                vc.clinicName = self.clinicName
                vc.SelectedDoctorFromSearch = self.SelectedDoctorFromSearch!
                AppPopUpHandler.instance.openVCPop(vc, height: 500, dismiss: false)
            } else if root.keys.contains("MESSAGE") {
                let messageRow = (root["MESSAGE"] as! [String: AnyObject])["MESSAGE_ROW"] as! [String : AnyObject]
                let englishMsg = messageRow["NAME_EN"] as! String
                self.SelectedDoctorFromSearch!.reservationID = englishMsg
                let code = messageRow["CODE"] as! String
                if code == "6455" {
                    OPEN_RESERVATION_AND_NO_SLOTS_POPUP(container: self, type: .reservationDone) {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        if let nav = appDelegate.window!.rootViewController as? UINavigationController {
                            var index = 0
                            for (i, controller) in nav.viewControllers.enumerated() {
                                if controller is ErmergenyClinicViewController {
                                    index = i
                                    break
                                }
                            }
                            nav.popToViewController(nav.viewControllers[index], animated: true)
                        }
                    }
                } else {
                    Utilities.showAlert(messageToDisplay: "\(englishMsg)")
                }
            } else {
                OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "Error in connection" : "مشكلة في الاتصال")
            }
        }
    }
    
    
    
}


extension SignUpAsGuestVC:DataPickerPopupDelegate
{
    func timeDidAdded(day: Int, month: Int, year: Int) {
    }
    
    func returnDate(date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        formatter.locale = Locale(identifier: "en")
        let myString = formatter.string(from: date)
        
        
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "dd-MM-yyyy"
        formatter1.locale = Locale(identifier: "en")
        let myString1 = formatter1.string(from: date)
        birthDAteLAbel.text = myString1
        dateString = myString
    }
    
    
}
extension SignUpAsGuestVC:CountryPickerViewDelegate{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.phoneCode = country.phoneCode
        selectedCountry = country
    }
    
    
    
}

extension SignUpAsGuestVC: ClinicReservationDonePopupDelegate {
    func closeDonePopup() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let nav = appDelegate.window!.rootViewController as? UINavigationController {
            var index = 0
            for (i, controller) in nav.viewControllers.enumerated() {
                if controller is ErmergenyClinicViewController {
                    index = i
                    break
                }
            }
            nav.popToViewController(nav.viewControllers[index], animated: true)
        }
    }
}
