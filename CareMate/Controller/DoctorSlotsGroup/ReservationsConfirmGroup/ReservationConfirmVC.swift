//
//  FSCalendarScopeViewController.swift
//  FSCalendarSwiftExample
//
//  Created by dingwenchao on 30/12/2016.
//  Copyright © 2016 wenchao. All rights reserved.
//

import UIKit
import MZFormSheetController
var sucessResrve = false
class ReservationConfirmVC: BaseViewController {
    @IBOutlet weak var doctorSpeciality: UILabel!
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var doctorImg: UIImageView!
    @IBOutlet weak var costLbl: UILabel!
    @IBOutlet weak var feesLbl: UILabel!
    @IBOutlet weak var currencyLbl: UILabel!
    
    @IBOutlet weak var waitingTimeLbl: UILabel!
    @IBOutlet weak var waitingTimeTitleLbl: UILabel!

    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var locationBlock: UIView!
    @IBOutlet weak var phoneNumberBlock: UIView!
    @IBOutlet weak var emailBlock: UIView!
    @IBOutlet weak var viewBook: UIView!
    @IBOutlet weak var dayText: UILabel!
    @IBOutlet weak var pmTextLabel: UILabel!
    @IBOutlet weak var doctorLocation: UILabel!
    @IBOutlet weak var patientnameLbl: UILabel!
    @IBOutlet weak var patientemailLbl: UILabel!
    @IBOutlet weak var patientmobileLbl: UILabel!
    @IBOutlet weak var BookDetailsText: UILabel!
    @IBOutlet weak var labelPlaceTitle: UILabel!
    @IBOutlet weak var viewPlaceHolder: UIView!
    
    
    var SelectedDoctorFromSearch : makeAppointment?
    var loginUseeer:LoginedUser?
    var patPatinet = ""
    var speciality = ""
    var specialityID = ""
    var serviceId = ""
    var url :URL?
    var gender = ""
    var branch: Branch?
    var selectedSpeciality: Speciality?

    @IBOutlet weak var bookNowBtn: UILabel!
    @IBOutlet weak var labelAppoiment: UILabel!

    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelPlace: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "تأكيد الحجز": "Book Confirmation", hideBack: false)
        viewBook.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(confirmClicked)))
        BookDetailsText.text = UserManager.isArabic ? "تفاصيل الحجز" : "Booking Details"
        
        print("urlurlurlurlurlurlurlurlurlurlurlurlurlurl")
        var brachType = "1"
        if branch?.BRANCH_TYPE != "" {
            brachType = branch?.BRANCH_TYPE ?? "1"
        }
        print(brachType)
        self.labelPlace.text = UserManager.isArabic ? SelectedDoctorFromSearch?.doctor?.CLINIC_LOCATION_AR : SelectedDoctorFromSearch?.doctor?.CLINIC_LOCATION_EN

//        Doctor.getDoctors(withSpecialityId: selectedSpeciality?.id ?? specialityID, andBranchId: branch?.id ?? "", type: brachType,isload: false) { doctors in
//            guard let doctors = doctors else {
//                self.viewPlaceHolder.isHidden = true
//                return
//            }
//            self.labelPlace.text = UserManager.isArabic ? doctors.first?.CLINIC_LOCATION_AR : doctors.first?.CLINIC_LOCATION_EN
//        }
    }
    
    deinit {
        print("\(#function)")
    }
    
    
    
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        UIView.appearance().semanticContentAttribute = !UserManager.isArabic ? .forceLeftToRight : .forceRightToLeft

        CheckLang()
        self.navigationController?.navigationBar.backItem?.title = ""
//        self.navigationController?.navigationBar.isHidden = true
        if SelectedDoctorFromSearch?.doctor?.qualificationAR == nil{
            self.doctorSpeciality.text = UserManager.isArabic ? "\(SelectedDoctorFromSearch?.doctor?.clinicNameAR ?? "") - \(SelectedDoctorFromSearch?.doctor?.DOCCATNAME ?? "")" : "\(SelectedDoctorFromSearch?.doctor?.clinicName ?? "") - \(SelectedDoctorFromSearch?.doctor?.doctorCategory ?? "")"
        }
        else{
         
            self.doctorSpeciality.text = UserManager.isArabic ? SelectedDoctorFromSearch?.doctor?.qualificationAR ?? "" : SelectedDoctorFromSearch?.doctor?.qualification ?? ""
        }
        doctorName.text = UserManager.isArabic ? (SelectedDoctorFromSearch!.doctor!.englishNameAR!) : (SelectedDoctorFromSearch!.doctor!.englishName!)
        doctorName.textAlignment = .center
        doctorLocation.text =  UserManager.isArabic ? branch!.arabicName :branch?.englishName
        dateLbl.text = SelectedDoctorFromSearch!.dateDone.formateDAte(dateString: SelectedDoctorFromSearch?.dateDone ?? "", formateString: "yyyy MMMM dd")
        dayText.text = SelectedDoctorFromSearch!.dateDone.formateDAte(dateString: SelectedDoctorFromSearch?.dateDone ?? "", formateString: "EEEE")
        timeLbl.text = SelectedDoctorFromSearch!.slot!.id.ConvertToDate.ToTimeOnly
        bookNowBtn.text = UserManager.isArabic ? "تأكيد" : "Confirmation"
        labelAppoiment.text = UserManager.isArabic ? "الموعد" : "Appoiment"
        labelLocation.text = UserManager.isArabic ? "الفرع" : "Branch"
        labelPlaceTitle.text = UserManager.isArabic ? "الموقع" : "Location"
        let defaults = UserDefaults.standard
        let url = URL(string: "\(Constants.APIProvider.IMAGE_BASE)\(SelectedDoctorFromSearch?.doctor?.DOCTOR_PIC ?? "")")
        print("http://172.25.26.140/mobileApi/\(SelectedDoctorFromSearch?.doctor?.DOCTOR_PIC ?? "")")
        self.doctorImg.kf.setImage(with: url, placeholder: SelectedDoctorFromSearch?.doctor?.gender == "M" ? UIImage(named: "RectangleMan") : UIImage(named: "RectangleGirl") , options: nil, completionHandler: nil)
        if let savedPerson = defaults.object(forKey: "SavedPerson") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(LoginedUser.self, from: savedPerson) {
                loginUseeer =  loadedPerson
                patPatinet = loginUseeer?.PAT_TEL ?? ""
            }
        }
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        IQKeyboardManager.sharedManager().enable = true
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    @objc func confirmClicked() {
        confirmClicked2(changeRequest: 0, ser: "")
            }
    
    @objc func confirmClicked2(changeRequest: Int, ser: String) {
        
        var pars = [
//            "PAT_TEL": patPatinet,
            "BRANCH_ID": branch?.id ?? "" ,
                    "COMPUTER_NAME":"ios" ,
                    "SERV_TYPE":"1",
                    "DETECT_TYPE":"1",
                    "CLINIC_ID": SelectedDoctorFromSearch!.doctor!.clinicId! ,
                    "SHIFT_ID": SelectedDoctorFromSearch!.shiftID,
                    "SCHED_SERIAL": SelectedDoctorFromSearch!.scheduleSerial,
                    "DOC_ID": SelectedDoctorFromSearch!.doctor!.id!,
                    "PATIENT_ID": SelectedDoctorFromSearch!.patientID,
//                    "GENDER": SelectedDoctorFromSearch!.doctor!.gender != nil ? SelectedDoctorFromSearch!.doctor!.gender! : "M" ,
                    "SPEC_ID": SelectedDoctorFromSearch!.specialityID,
                    "buffer_status": isReschedule ? "2" : "1",
                    "dateDone": SelectedDoctorFromSearch!.dateDone,
                    "EXPECTEDDONEDATE": SelectedDoctorFromSearch!.dateDone,
                    "EXPECTED_END_DATE": SelectedDoctorFromSearch!.dateDoneEnd,
                    "SERVICE_ID":serviceId
                    
        ] as [String : String]
        print(pars)
        if isReschedule {
            pars.updateValue(reservationID, forKey: "SER")
        }
        if changeRequest != 0 {
            pars.updateValue("\(changeRequest)", forKey: "changeRequest")
            pars.updateValue("\(ser)", forKey: "CONFIRM_DOUBLICATION_SER")
        }
        let urlString = Constants.APIProvider.SubmitAppointment
        let url = URL(string: urlString)
        let parseUrl = Constants.APIProvider.SubmitAppointment + Constants.getoAuthValue(url: url!, method: "POST",parameters: pars)
        WebserviceMananger.sharedInstance.makeCall(method: .post, url: urlString, parameters: pars, vc: self) { [weak self] (data, error) in
            guard let self = self else { return }
            let root = (data as? [String:AnyObject])?["Root"] as? [String: AnyObject] ?? [:]
            if root.keys.contains("OUT_PARMS") { // save success
                let params = (root["OUT_PARMS"] as? [String: AnyObject])?["OUT_PARMS_ROW"] as? [String : AnyObject]
                let ser = params?["SER"] as? String ?? ""
                let location = params?[UserManager.isArabic ? "CLINIC_LOCATION_ADDRESS" : "CLINIC_LOCATION_ADDRESS_EN"] as? String ?? ""
                let instructions = params?[UserManager.isArabic ? "CLINIC_APPOINT_INSTRUCTIONS" : "CLINIC_APPOINT_INSTRUCTIONS_EN"] as? String ?? ""
                self.SelectedDoctorFromSearch?.reservationID = ser
                let vc = ReservationSuccessVC()
                vc.instructions = instructions
                vc.delegate = self
                vc.speciality = self.speciality
                vc.location = (UserManager.isArabic ? SelectedDoctorFromSearch?.doctor?.clinicNameAR : SelectedDoctorFromSearch?.doctor?.clinicName) ?? location
                vc.SelectedDoctorFromSearch = self.SelectedDoctorFromSearch!
                AppPopUpHandler.instance.openVCPop(vc, height: 550)
            } else {
                let root2 = root["Root"] as? [String: AnyObject] ?? [:]
                let messageDic = (root["MESSAGE"] as? [String: AnyObject])?["MESSAGE_ROW"] as? [String: AnyObject] ?? [:]
                if messageDic["CODE"] as? String ?? "" == "6751" { // Dublicate
                    let messageRow = (root2["OUT_PARMS"] as? [String: AnyObject])?["OUT_PARMS_ROW"] as? [String : AnyObject]
                    let dublication = messageRow?["CONFIRM_DOUBLICATION_SER"] as? String ?? ""
                    let messageDic = (root["MESSAGE"] as? [String: AnyObject])?["MESSAGE_ROW"] as? [String: AnyObject] ?? [:]
                    OPEN_DUBLICATE_POPUP(container: self, message: UserManager.isArabic ? messageDic["NAME_AR"] as? String ?? "" : messageDic["NAME_EN"] as? String ?? "") { type in
                        if type == 0 { return }
                        self.confirmClicked2(changeRequest: type, ser: dublication)
                    }
                } else { // Dublicate visit
                    OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? messageDic["NAME_AR"] as? String ?? "" : messageDic["NAME_EN"] as? String ?? "")
                }
            }
        }
    }
    
   
    func CheckLang() {
        self.title =  UserManager.isArabic ? "تأكيد الحجز" : "Confirmation"
        self.doctorImg.roundedimage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "success"
        {
            segue.ccmPopUp(width: 300, height: 450)
            let vc = segue.destination as! ReservationSuccessVC
            vc.SelectedDoctorFromSearch = SelectedDoctorFromSearch!
        }
    }
}

extension ReservationConfirmVC :ClinicReservationDonePopupDelegate{
    func closeDonePopup() {
        if let nav = navigationController {
            var index = 0
            for (i, vc) in nav.viewControllers.enumerated() {
                if vc is TabBarNavigationController {
                    vc.tabBarController?.selectedIndex = 0
                    index = i
                    
                    break
                }
            }
             sucessResrve = true
            nav.popToViewController(nav.viewControllers[index], animated: true)
        }
    }
}
