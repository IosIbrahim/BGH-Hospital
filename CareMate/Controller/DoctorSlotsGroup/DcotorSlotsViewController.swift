//
//  DcotorSlotsViewController.swift
//  CareMate
//
//  Created by Khabber on 20/06/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit
import MZFormSheetController

class DcotorSlotsViewController: BaseViewController {
    
    @IBOutlet weak var lblAppointment: UILabel!
    @IBOutlet weak var lblNat: UILabel!
    @IBOutlet weak var lblOnline: UILabel!
    @IBOutlet weak var pickerOnline: UIView!
    @IBOutlet weak var lblHospital: UILabel!
    @IBOutlet weak var pickerHospital: UIView!
    @IBOutlet weak var lblVisitType: UILabel!
    @IBOutlet weak var pickerAction: UIView!
    @IBOutlet weak var pickerVisitType: UIView!
    @IBOutlet weak var lblTerms: UILabel!
    @IBOutlet weak var imgAccept: UIImageView!
    @IBOutlet weak var pickerAccept: UIView!
    @IBOutlet weak var pickerConditions: UIView!
    @IBOutlet weak var viewSpec: RoundUIView!
    @IBOutlet weak var constraintColleectionviewSlot: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minsBtn: UIButton!
    @IBOutlet weak var collectioViewSlotTimes: UICollectionView!
    @IBOutlet weak var constraintCollectionDaysOfMonth: NSLayoutConstraint!
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var doctorSpeciality: UILabel!
    @IBOutlet weak var chosseTimeText: UILabel!
    @IBOutlet weak var bookAppoiment: UILabel!
    @IBOutlet weak var labelMonth: UILabel!
    @IBOutlet weak var collectioViewSlotDays: UICollectionView!
    @IBOutlet weak var viewBook: UIView!
    @IBOutlet weak var uiimageAvatar: UIImageView!
    @IBOutlet weak var uilabelSpkenLanText: UILabel!
    @IBOutlet weak var uilabelSpkenLan: UILabel!
    @IBOutlet weak var imageViweNext: UIImageView!
    @IBOutlet weak var imageViewPrev: UIImageView!
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var viewScedule: UIView!
    @IBOutlet weak var viewSceduleDetails: UIView!
    @IBOutlet weak var viewInfoDetails: UIView!
    @IBOutlet weak var viewLanguage: UIView!
    @IBOutlet weak var labelAboutDoctorTITLE: UILabel!
    @IBOutlet weak var labelSecializedInTitle: UILabel!
    @IBOutlet weak var labelAbout: UILabel!
    @IBOutlet weak var viewAbout: UIView!
    @IBOutlet weak var labelSpeciality: UILabel!
    @IBOutlet weak var labelBranch: UILabel!
    
    var doctor: Doctor?
    var qualifications = [Qualification]()
    var specialityID:String?
    var clincID: String?
    var branchID: String?
    var branch: Branch?
    var docID: String?
    var clicnName: String?
    var DocName: String?
    var ReservArr: [TimeSlots] = []
    var dateID: TimeSlots?
    var SlotArr:[Slot] = []
    var serviceObject:Service?
    var valueMonth = 1
    var valueIndex = 1
    var datesInMonthList = [Date]()
    var selecteIndex = 0
    var selecteIndexPAth = 0
    var selectedIndexSlot :Int?
    var year = Date().year
    var url :URL?
    var guestName = ""
    var guestPhone = ""
    var guestPhoneCode = ""
    var guestGender = ""
    var guestBithDate = ""
    var isScedule = false
    var guestIdentityType = ""
    var guestSSN = ""
    var speciality = ""
    var clinicID = ""
    var selecteDate = ""
    var isEmptyDate:Bool = false
    var comesFromDoctors = false
    var isPhysical:Bool = false
    var session:SessionRowModel?
    var acceptOnline = false
    
    let monthsEn = ["January","February","March","April","May","June","July","August","September","October","November","December"]
  //  let monthsAr = ["يناير","فبراير","مارس","ابريل","مايو","يونيه","يوليو","اغسطس","سبتمبر","اكتوبر","نوفمبر","ديسمبر"]
    let monthsAr = ["يناير","فبراير","مارس","ابريل","مايو","يونيو","يوليو","اغسطس","سبتمبر","اكتوبر","نوفمبر","ديسمبر"]
    var selectedSpeciality: Speciality?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getData()
    }
    
    func getData() {
        
        let parseUrl = "\(Constants.APIProvider.doctorProfiledata)branch=\(branchID ?? "")&emp_id=\(doctor?.id ?? "")"
        indicator.sharedInstance.show()
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: parseUrl, parameters: nil, vc: self) { (data, error) in
            if error == nil {
                if let model = ((data as? [String: AnyObject])?["EMP_BIOGRAPHY"] as? [String:AnyObject])?["EMP_BIOGRAPHY_ROW"] as? [String: AnyObject] {
                    self.labelSpeciality.text = (UserManager.isArabic ? model["SPECIALTY_NAME_AR"] as? String : model["SPECIALTY_NAME_EN"] as? String) ?? ""
                    self.labelBranch.text = (UserManager.isArabic ? model["PLACE_AR"] as? String : model["PLACE_EN"] as? String) ?? ""
                    self.labelAbout.stringFromHtml(htmlString: (UserManager.isArabic ? model["EMP_BIO_DESC_AR"] as? String : model["EMP_BIO_DESC_EN"] as? String) ?? "")
                    self.labelAbout.font = UIFont(name: "Tajawal-Regular", size: 12)
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
            self.loadSlots()
        }
    }
    
    func setupView(){
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "تأكيد الحجز" : "Book Appointment", hideBack: false)
        let color = UIColor.fromHex(hex: "#003B701A", alpha: 1.0)
        mainView.makeShadow(color:color , alpha: 0.14, radius: 12)
        viewSpec.makeShadow(color: color, alpha: 0.14, radius: 12)
        pickerAction.makeShadow(color: color, alpha: 0.14, radius: 12)
        pickerVisitType.makeShadow(color: color, alpha: 0.14, radius: 12)
        mainView.Rounded(corner: 12)
        viewSpec.Rounded(corner: 12)
        pickerAction.Rounded(corner: 12)
        pickerVisitType.Rounded(corner: 12)

        setMonth(value: valueMonth)
        plusBtn.setTitle("", for: .normal)
        imageViweNext.image = UIImage.init(named: "IconRightDate")!.imageFlippedForRightToLeftLayoutDirection()
        minsBtn.setTitle("", for: .normal)
        imageViewPrev.image = UIImage.init(named: "IconleftDate")!.imageFlippedForRightToLeftLayoutDirection()
        setupcollectionView()
        doctorName.text = UserManager.isArabic ? doctor?.englishNameAR :doctor?.englishName
        doctorName.textAlignment = .center
        if comesFromDoctors {
            doctorSpeciality.text = "\(doctor?.getDocName() ?? "") - \(doctor?.getClinic() ?? "")"
        }else if doctor?.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW?.count ?? .zero > 1 {
                for item in doctor?.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW ?? [] {
                    if item.CLINIC_ID == clincID {
                        let cat = UserManager.isArabic ? doctor?.doctorCategoryAR:doctor?.doctorCategory
                        if let categ = cat {
                            doctorSpeciality.text = " \(categ) - \(item.getName())"
                        }else {
                            let spec = UserManager.isArabic ? doctor?.SPECIALITY_AR :doctor?.SPECIALITY_EN
                            doctorSpeciality.text = "\(spec ?? "") - \(item.getName())"
                        }
                        
                        break
                    }
                }
        }else {
                let cat = UserManager.isArabic ? doctor?.doctorCategoryAR:doctor?.doctorCategory
                let spec = UserManager.isArabic ? doctor?.SPECIALITY_AR :doctor?.SPECIALITY_EN
                let clinic = UserManager.isArabic ? doctor?.clinicNameAR :doctor?.clinicName
                if let categ = cat, let clin = clinic {
                    doctorSpeciality.text = "\(clin) - \(categ)"
                }else {
                    doctorSpeciality.text = "\(cat ?? "") - \(spec ?? "")"
                }
            }
      //  }
      
        uilabelSpkenLan.text =  UserManager.isArabic ? doctor?.HREMPLOYEELANGUAGE_AR: doctor?.HREMPLOYEELANGUAGE_AR
        viewBook.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bookCliked)))
        self.uiimageAvatar.kf.setImage(with: self.url, placeholder: doctor?.gender == "M" ? UIImage(named: "RectangleMan") : UIImage(named: "DoctorIconRX") , options: nil, completionHandler: nil)
        viewLanguage.makeShadow(color: .black, alpha: 0.14, radius: 4)
        viewInfo.makeShadow(color: .black, alpha: 0.14, radius: 4)
        viewScedule.makeShadow(color: .black, alpha: 0.14, radius: 4)
        viewAbout.makeShadow(color: .black, alpha: 0.14, radius: 4)
        
        viewInfo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openInfo)))
        viewScedule.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openSchedule)))
        openSchedule()
        var condition = "I would like to book this follow-up as a remote consultation; I agree to Terms & Conditions"
       var terms =  "Terms & Conditions"
        lblVisitType.text = "Visit Type"
        lblHospital.text = "In Hospital"
        lblOnline.text = "Online Consultation"
        lblAppointment.text = "Follow-up appointment"
        lblNat.text = doctor?.nationality
        lblVisitType.textAlignment = .left
        lblTerms.textAlignment = .left
        lblNat.textAlignment = .left
        lblAppointment.textAlignment = .left
        lblHospital.textAlignment = .left
        lblOnline.textAlignment = .left
        if UserManager.isArabic {
            labelAboutDoctorTITLE.text = "عن الطبيب:"
            labelSecializedInTitle.text = "متخصص في:"
            chosseTimeText.text = "اختار الوقت"
            bookAppoiment.text = "احجز الآن"
            uilabelSpkenLanText.text = "اللغات:"
            terms =  "الشروط والاحكام"
            condition =  "ارغب في حجز هذه المتابعة كاستشارة عن بعد ،اوافق علي الشروط والاحكام"
            lblVisitType.text = "نوع الزيارة"
            lblHospital.text = "الحضور في المستشفي"
            lblOnline.text = "استشارة عن بعد"
            lblAppointment.text = "موعد متابعة"
            lblNat.text = doctor?.nationalityAR
            lblVisitType.textAlignment = .right
            lblTerms.textAlignment = .right
            lblNat.textAlignment = .right
            lblAppointment.textAlignment = .right
            lblHospital.textAlignment = .right
            lblOnline.textAlignment = .right
        }
        lblAppointment.adjustsFontSizeToFitWidth = true
        lblHospital.adjustsFontSizeToFitWidth = true
        lblOnline.adjustsFontSizeToFitWidth = true
        let mainString = condition
        let attributedString = NSMutableAttributedString(string: mainString)
           
           // Apply different colors to specific substrings
        attributedString.setColor(forText: terms, withColor: UIColor.fromHex(hex: "#00ABC8", alpha: 1.0))
           
        lblTerms.attributedText = attributedString
        let gestureviewagreegation = UITapGestureRecognizer(target: self, action:  #selector(self.agreegationCliked))
        lblTerms.addGestureRecognizer(gestureviewagreegation)
        
        let gestureRemberMe = UITapGestureRecognizer(target: self, action:  #selector(self.acceptTerms))
        pickerAccept.addGestureRecognizer(gestureRemberMe)
    }
    
    @objc func agreegationCliked(sender : UITapGestureRecognizer) {
        let vc = termsAndConditionVC()
        vc.typePrivacyPolicy = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func acceptTerms(sender : UITapGestureRecognizer) {
        if acceptOnline == false {
            acceptOnline =  true
            imgAccept.image = UIImage(named: "dignosisSelected.png")
        } else {
            acceptOnline =  false
            imgAccept.image = UIImage(named: "additinakDataDiagnosisSeleected.png")
        }
    }

    func getAttributedString(string: String) -> AttributedString {
            var attributedString = AttributedString(string)
            attributedString.font = .body.bold()
            attributedString.underlineStyle = .single
            return attributedString
    }

    
    @objc func openInfo() {
        viewInfo.setBorder(color: UIColor.fromHex(hex: "#DDE4EC", alpha: 1.0), radius: 12, borderWidth: 1)
   //     viewScedule.setBorder(color: .clear, radius: 8, borderWidth: 0)
        viewSceduleDetails.isHidden = true
        pickerVisitType.isHidden = true
        pickerAction.isHidden = true
        UIView.transition(with: viewInfoDetails, duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
                         self.viewInfoDetails.isHidden = false
                      })
    }
    
    @objc func openSchedule() {
        viewInfo.setBorder(color: UIColor.fromHex(hex: "#DDE4EC", alpha: 1.0), radius: 12, borderWidth: 1)
    //    viewScedule.setBorder(color: .blue, radius: 8, borderWidth: 1)
        viewInfoDetails.isHidden = true
        pickerAction.isHidden = false
        pickerVisitType.isHidden = false
        
        UIView.transition(with: viewSceduleDetails, duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
                         self.viewSceduleDetails.isHidden = false
                      })
    }
    
    func setMonth(value:Int){
        
        let index = doctor?.FIRST_SLOT_TIME?.ConvertToDate.month ?? Calendar.current.component(.month, from: Date())
        year = doctor?.FIRST_SLOT_TIME?.ConvertToDate.year ?? Calendar.current.component(.year, from: Date())
        labelMonth.text = "\(UserManager.isArabic ?  monthsAr[index - 1] :  monthsEn[index - 1]) \(year)"
        valueIndex = index
        
        let dateComponents = DateComponents(year: year, month: valueIndex)
        var calendar = Calendar.current
        calendar.locale = .current
        let date34 = calendar.date(from: dateComponents)!
        var allDays = date34.getAllDays()
        
        for day in allDays {
            if day < Date().dayBefore {
                allDays.remove(at: 0)
            }
        }
        
        datesInMonthList = allDays
        isEmptyDate = allDays.isEmpty
        if isEmptyDate && !allDays.isEmpty {
            datesInMonthList.removeLast()
        }
        
        print(allDays)
        print("datesInMonthList")
        print(datesInMonthList)
        setupcollectionView()
        reloadTableView()
       // loadSlots()
    
    }
    func reloadTableView(){
        for (index,item) in datesInMonthList.enumerated(){
            let dateFormatterYYYMMDD = DateFormatter()
            dateFormatterYYYMMDD.dateFormat = "dd/MM/yyyy"
            dateFormatterYYYMMDD.locale = Locale(identifier: "en_US_POSIX")
            dateFormatterYYYMMDD.locale = .current
            let dayInYYYMMDDDateInCell = dateFormatterYYYMMDD.string(from: item)
            let dayInYYYMMDDCuurentDate = dateFormatterYYYMMDD.string(from: doctor?.FIRST_SLOT_TIME?.ConvertToDate ?? Date())
            if dayInYYYMMDDDateInCell == dayInYYYMMDDCuurentDate{
                selecteIndex = index
                selecteDate = dayInYYYMMDDCuurentDate
                selecteIndexPAth = index
                break
            }
        }
        collectioViewSlotDays.reloadData()
        if datesInMonthList.isEmpty {
            print("Empty List")
        }else {
            let indexPath = IndexPath(item: selecteIndex, section: 0)
            if UserManager.isArabic{
                collectioViewSlotDays.layoutIfNeeded()
                collectioViewSlotDays.semanticContentAttribute = .forceRightToLeft
                self.collectioViewSlotDays.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
            }
            else{
                collectioViewSlotDays.layoutIfNeeded()
                collectioViewSlotDays.semanticContentAttribute = .forceLeftToRight

                self.collectioViewSlotDays.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
            }
        }


    }
    
    @objc func bookCliked(){
        
        if let serviceObjectConstant = self.serviceObject
        {
            print(serviceObjectConstant.clinicID ?? "")
            if selectedIndexSlot == nil {
                Utilities.showAlert(self, messageToDisplay: UserManager.isArabic ? "من فضلك اختر وقت الحجز اولا" : "Kindly choose reservation time")
                return
            }
            if Utilities.sharedInstance.getPatientId() == "" {
    //            Utilities.showLoginAlert(vc: self.navigationController!)
    //            return
                gotoGuest()
                
                return
                
            }
            gotoUser()
        }
        
        else
        {
            if selectedIndexSlot == nil {
                Utilities.showAlert(self, messageToDisplay: UserManager.isArabic ? "من فضلك اختر وقت الحجز اولا" : "Kindly choose reservation time")
                return
            }
            if Utilities.sharedInstance.getPatientId() == "" {
                gotoGuest()
                return
                
            }
            gotoUser()

        }
       
    }
    
    func gotoGuest() {
        let vc :   SignUpAsGuestVC = SignUpAsGuestVC()
        let appoint = makeAppointment()
        var shiftId = ""
        var schedSerial = ""
        let spec = specialityID
        appoint.doctor = doctor
        appoint.branch = branch
        if let index = selectedIndexSlot {
            appoint.slot = SlotArr[index]
            appoint.dateDone = SlotArr[index].id ?? ""
            shiftId = SlotArr[index].shiftID ?? ""
            schedSerial = SlotArr[index].schedual ?? ""
            appoint.dateDone = SlotArr[index].id ?? ""
            appoint.dateDoneEnd = SlotArr[index].TIME_SLOT_END ?? ""

        }
        appoint.slot = SlotArr[selectedIndexSlot!]
        appoint.shiftID = shiftId
        appoint.scheduleSerial = schedSerial
        appoint.specialityID = spec ?? ""
        
        appoint.branchID = branchID!
        appoint.patientID = Utilities.sharedInstance.getPatientId()
        appoint.branch = branch!
        vc.SelectedDoctorFromSearch = appoint
        vc.guestName = guestName
        vc.guestPhone = guestPhone
        vc.guestPhoneCode = guestPhoneCode
        vc.isScedule = isScedule
        vc.guestBithDate = guestBithDate
        vc.guestGender = guestGender
        vc.guestIdentityType = guestIdentityType
        vc.guestSSN = guestSSN
        vc.clinicName = clicnName ?? ""
        vc.session = session
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoUser() {
        var shiftId = ""
        var schedSerial = ""
        let spec = specialityID
        let appoint = makeAppointment()
        appoint.doctor = doctor
        appoint.branch = branch
        if let index = selectedIndexSlot {
            appoint.slot = SlotArr[index]
            appoint.dateDone = SlotArr[index].id ?? ""
            shiftId = SlotArr[index].shiftID ?? ""
            schedSerial = SlotArr[index].schedual ?? ""
            let number = Int(serviceObject?.numberSlots ?? "0") ?? .zero
            appoint.dateDoneEnd = SlotArr[index + number].TIME_SLOT_END ?? ""

        }
        appoint.shiftID = shiftId
        appoint.scheduleSerial = schedSerial
        appoint.specialityID = spec ?? ""
        
        appoint.branchID = branchID ?? ""
        appoint.patientID = Utilities.sharedInstance.getPatientId()
        let vc =  ReservationConfirmVC()
        vc.serviceId = serviceObject?.id ?? ""
        vc.speciality = speciality
        vc.SelectedDoctorFromSearch = appoint
        vc.gender = doctor?.gender ?? ""
        vc.branch = branch
        vc.session = session
        vc.comesFromDoctors = comesFromDoctors
        vc.clinicName = doctorSpeciality.text?.components(separatedBy: "-").first ?? ""
        vc.selectedSpeciality = selectedSpeciality
        vc.specialityID = specialityID ?? ""
        vc.isPhysical = isPhysical
        vc.session = session
        vc.acceptOnline = acceptOnline
        vc.url =    URL(string: "\(Constants.APIProvider.IMAGE_BASE)/\(doctor?.DOCTOR_PIC ?? "")")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func monthPlus(_ sender: Any) {
        selecteIndexPAth = -1
        selecteIndex = 0
        valueIndex += 1
        if valueIndex > 12 {
            year += 1
            valueIndex = 1
        }
        labelMonth.text  = "\(UserManager.isArabic ? monthsAr[valueIndex - 1] : monthsEn[valueIndex - 1]) \(year)"
        let dateComponents = DateComponents(year: year, month: valueIndex)
        let calendar = Calendar.current
        let date34 = calendar.date(from: dateComponents)!
        let allDays = date34.getAllDays()
        datesInMonthList = allDays
        reloadTableView()
//        loadSlots()
        
       
    }
    @IBAction func monthMins(_ sender: Any) {
        selecteIndexPAth = -1
        selecteIndex = 0
        valueIndex -= 1
        if valueIndex < 1 {
            year -= 1
            valueIndex = 12
        }
        labelMonth.text = "\(UserManager.isArabic ?   monthsAr[valueIndex - 1] :  monthsEn[valueIndex - 1]) \(year)"
       
        let dateComponents = DateComponents(year: year, month: valueIndex)
        let calendar = Calendar.current
        let date34 = calendar.date(from: dateComponents)!
        let allDays = date34.getAllDays()
        datesInMonthList = allDays
        reloadTableView()
    }
    
    func loadSlots(){
        self.ReservArr.removeAll()
        TimeSlots.getSlotsTimes(branchID: branchID ?? "", clincID: clincID ?? "", docID: docID ?? "",date:selecteDate,isPhysical: isPhysical){ [self] slots,avDate, slotsTime in
            self.checkOnline()
            if selecteDate == slotsTime {
                self.ReservArr = slots ?? []
                for i in self.ReservArr
                {
                    self.SlotArr.append(contentsOf: i.slotsarray?.SINGLE_HOUR_SLOTS_ROW ?? [])
                }
                self.SlotArr = self.SlotArr.filter{$0.statuse == "empty"}
                self.collectioViewSlotTimes.delegate = self
                self.collectioViewSlotTimes.dataSource = self
                self.collectioViewSlotTimes.reloadData()
                let numbersOfRows =  Double(SlotArr.count) / 5.0
                print( numbersOfRows)
                print( numbersOfRows.rounded())
                
                
                var slotheight = ceil(numbersOfRows) * 51
                if numbersOfRows == 1{
                    
                    slotheight = 150
                }
                else{
                    slotheight += 200
                    
                }
                
                
                constraintColleectionviewSlot.constant = CGFloat(slotheight)
                let messageAr = "الدكتور الذي تم اختياره ليس له جدول مواعيد في هذا اليوم اذا كنت ترغب في حجز موعد في الاوقات الغير متاحة على التطبيق يرجى التواصل معنا عبر "
                let messageEN = "The selected doctor does not have a schedule on the selected date.In case you which to take an appointment for unavailable dates please call"
                print(messageAr,messageEN)
            } else if slotsTime != "" {
                if selecteDate.ConvertToDate.month != slotsTime.ConvertToDate.month {
                    monthPlus(2)
                }
                selecteDate = slotsTime
                self.SlotArr.removeAll()
                let dateFormatterYYYMMDD = DateFormatter()
                dateFormatterYYYMMDD.dateFormat = "dd/MM/yyyy"
                for (i, item) in datesInMonthList.enumerated() {
                    if item.asStringDMYEN == selecteDate {
                        selecteIndexPAth = i
                        break
                    }
                }
                self.collectioViewSlotDays.reloadData()
                self.collectioViewSlotDays.scrollToItem(at: IndexPath(item: selecteIndexPAth, section: 0), at: .right, animated: true)
                loadSlots()
            } else if self.SlotArr.count == 0
            {
                
                OPEN_RESERVATION_AND_NO_SLOTS_POPUP(container: self, type: .noSlots) {
//                    self.navigationController?.popViewController(animated: true)
                }
             }
         

             }
            
        }
    
    func checkOnline() {
        let dateFormatterYYYMMDD = DateFormatter()
        dateFormatterYYYMMDD.dateFormat = "dd/MM/yyyy"
        dateFormatterYYYMMDD.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterYYYMMDD.locale = .current
        let dayInYYYMMDDDateInCell = dateFormatterYYYMMDD.string(from: Date())
        let parseUrl = "\(Constants.APIProvider.checkOnlineCons)BRANCH_ID=\(branchID ?? "")&DOC_ID=\(doctor?.id ?? "")&CLINIC_ID=\(doctor?.clinicId  ?? "")&PATIENT_ID=\(Utilities.sharedInstance.getPatientId())&DATE_FROM_FORMATED=\(dayInYYYMMDDDateInCell)"
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: parseUrl, parameters: nil, vc: self) { (data, error) in
            if error == nil {
                if let model = ((data as? [String: AnyObject])?["Root"] as? [String:AnyObject])?["OUT_PARMS"] as? [String: AnyObject] {
                    let inner = model["OUT_PARMS_ROW"] as? [String: AnyObject]
                    let follow = inner?["PATIENT_HAS_FOLLOWUP"] as? String
                    if follow == "1" {
                        self.pickerConditions.isHidden = false
                    }else {
                        self.pickerConditions.isHidden = true
                    }
                }else {
                    self.pickerConditions.isHidden = true
                }
            }
        }
    }

}
    





extension UILabel {
    
    func stringFromHtml(htmlString: String) {
        let alignment = self.textAlignment
        let font = self.font
        let htmlData = NSString(string: htmlString).data(using: String.Encoding.unicode.rawValue)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        let attributedString = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
        self.attributedText = attributedString
        self.textAlignment = alignment
        self.font = font
    }
}

extension Date {
   static var yesturday:  Date { return Date().dayBefore }
   static var today: Date {return Date()}
   var dayBefore: Date {
      return Calendar.current.date(byAdding: .day, value: -1, to: Date())!
   }
}


extension NSMutableAttributedString {
    func setColor(forText stringToFind: String, withColor color: UIColor) {
        let range = self.mutableString.range(of: stringToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            self.addAttribute(.foregroundColor, value: color, range: range)
        }
    }
}
