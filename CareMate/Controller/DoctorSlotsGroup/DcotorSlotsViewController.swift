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
    var selecteDate = ""
    var isEmptyDate:Bool = false
    let monthsEn = ["January","February","March","April","May","June","July","August","September","October","November","December"]
  //  let monthsAr = ["يناير","فبراير","مارس","ابريل","مايو","يونيه","يوليو","اغسطس","سبتمبر","اكتوبر","نوفمبر","ديسمبر"]
    let monthsAr = ["يناير","فبراير","مارس","ابريل","مايو","يونيو","يوليو","اغسطس","سبتمبر","اكتوبر","نوفمبر","ديسمبر"]
    var selectedSpeciality: Speciality?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getData()
//        Qualification.getQualifications(forDoctorWithId: docID!) { qualifications in
//          guard let qualifications = qualifications else {return}
//            self.uilabelSpkenLan.text = UserManager.isArabic ? qualifications.HREMPLOYEELANGUAGE_AR : qualifications.HREMPLOYEELANGUAGE_EN
//            let arrSpec = (UserManager.isArabic ? qualifications.qualificationNameAR : qualifications.qualificationName).components(separatedBy: "-")
//            var specs = ""
//            for item in arrSpec {
//                if item == "" { continue }
//                specs += "- \(item.replacingOccurrences(of: "\\s?\\([^)]*\\)", with: "", options: .regularExpression))\n\n"
//            }
//            self.labelAbout.text = specs
//        }
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
        }
    }
    
    func setupView(){
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "تأكيد الحجز" : "Book Appointment", hideBack: false)
        mainView.makeShadow(color: .black, alpha: 0.14, radius: 4)
        viewSpec.makeShadow(color: .black, alpha: 0.14, radius: 4)
        setMonth(value: valueMonth)
        plusBtn.setTitle("", for: .normal)
        imageViweNext.image = UIImage.init(named: "IconRightDate")!.imageFlippedForRightToLeftLayoutDirection()
        minsBtn.setTitle("", for: .normal)
        imageViewPrev.image = UIImage.init(named: "IconleftDate")!.imageFlippedForRightToLeftLayoutDirection()
        setupcollectionView()
        doctorName.text = UserManager.isArabic ? doctor?.englishNameAR :doctor?.englishName
        doctorName.textAlignment = .center
        if doctor?.qualificationAR == nil {
            self.doctorSpeciality.text = UserManager.isArabic ? "\(doctor?.clinicNameAR ?? "") - \(doctor?.DOCCATNAME ?? "")" : "\(doctor?.clinicName ?? "") - \(doctor?.doctorCategory ?? "")"
        } else {
            self.doctorSpeciality.text = UserManager.isArabic ? doctor?.qualificationAR ?? "" : doctor?.qualification ?? ""
        }
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
        if UserManager.isArabic {
            labelAboutDoctorTITLE.text = "عن الطبيب:"
            labelSecializedInTitle.text = "متخصص في:"
            chosseTimeText.text = "اختار الوقت"
            bookAppoiment.text = "احجز الآن"
            uilabelSpkenLanText.text = "اللغات:"
        }
    }
    
    @objc func openInfo() {
        viewInfo.setBorder(color: .blue, radius: 8, borderWidth: 1)
        viewScedule.setBorder(color: .clear, radius: 8, borderWidth: 0)
        viewSceduleDetails.isHidden = true
        viewInfoDetails.isHidden = false
        viewBook.isHidden = true
    }
    
    @objc func openSchedule() {
        viewInfo.setBorder(color: .clear, radius: 8, borderWidth: 0)
        viewScedule.setBorder(color: .blue, radius: 8, borderWidth: 1)
        viewSceduleDetails.isHidden = false
        viewInfoDetails.isHidden = true
        viewBook.isHidden = false
    }
    
    func setMonth(value:Int){
//        let index = Calendar.current.component(.month, from: Date())
        let index = doctor?.FIRST_SLOT_TIME?.ConvertToDate.month ?? Calendar.current.component(.month, from: Date())
        year = doctor?.FIRST_SLOT_TIME?.ConvertToDate.year ?? Calendar.current.component(.year, from: Date())
        labelMonth.text = "\(UserManager.isArabic ?  monthsAr[index - 1] :  monthsEn[index - 1]) \(year)"
        valueIndex = index
        let dateComponents = DateComponents(year: year, month: valueIndex)
        var calendar = Calendar.current
       // calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.locale = .current
        let date34 = calendar.date(from: dateComponents)!
        var allDays = date34.getAllDays()
        for day in allDays {
            if day < Date().dayBefore {
                allDays.remove(at: 0)
            }
        }
        datesInMonthList = allDays
      //  if !isEmptyDate {
        isEmptyDate = allDays.isEmpty
        if isEmptyDate && !allDays.isEmpty {
            datesInMonthList.removeLast()
        }
       // }
        print(allDays)
        print("datesInMonthList")
        print(datesInMonthList)
        setupcollectionView()
        reloadTableView()
        loadSlots()
    
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
    //        self.collectioViewSlotDays.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
            
            if UserManager.isArabic{
                collectioViewSlotDays.layoutIfNeeded()
    //            collectioViewSlotDays.transform = CGAffineTransform(scaleX: -1, y: 1)

                collectioViewSlotDays.semanticContentAttribute = .forceRightToLeft
                self.collectioViewSlotDays.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
    //            collectioViewSlotDays.scrollToItem(at: indexPath, at: .right,animated: true)
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
            if selectedIndexSlot == nil {
                Utilities.showAlert(self, messageToDisplay: UserManager.isArabic ? "من فضلك اختر وقت الحجز اولا" : "Kindly choose reservation time")
                return
            }
            if Utilities.sharedInstance.getPatientId() == "" {
    //            Utilities.showLoginAlert(vc: self.navigationController!)
    //            return
                
                
                let vc :   SignUpAsGuestVC = SignUpAsGuestVC()
                let shiftId = SlotArr[selectedIndexSlot!].shiftID
                let schedSerial = SlotArr[selectedIndexSlot!].schedual
                let spec = specialityID!
                let appoint = makeAppointment()
                appoint.doctor = doctor!
                appoint.branch = branch!
                appoint.slot = SlotArr[selectedIndexSlot!]
                appoint.shiftID = shiftId
                appoint.scheduleSerial = schedSerial
                appoint.specialityID = spec
                
                print(SlotArr[selectedIndexSlot!].schedual)
                appoint.dateDone = SlotArr[selectedIndexSlot!].id
                appoint.dateDoneEnd = SlotArr[selectedIndexSlot! + Int(serviceObject!.numberSlots ?? "0")! ].TIME_SLOT_END
                appoint.branchID = branchID!
                appoint.branch = branch!

                appoint.patientID = Utilities.sharedInstance.getPatientId()
                vc.SelectedDoctorFromSearch = appoint
                vc.SelectedDoctorFromSearch?.branch = branch
                vc.guestName = guestName
                vc.guestPhone = guestPhone
                vc.guestPhoneCode = guestPhoneCode
                vc.isScedule = isScedule
                vc.guestBithDate = guestBithDate
                vc.guestGender = guestGender
                vc.guestIdentityType = guestIdentityType
                vc.guestSSN = guestSSN
                vc.clinicName = clicnName ?? ""
                
                self.navigationController?.pushViewController(vc, animated: true)
                
                return
                
            }
            let shiftId = SlotArr[selectedIndexSlot!].shiftID
            let schedSerial = SlotArr[selectedIndexSlot!].schedual
            let spec = specialityID!
            let appoint = makeAppointment()
            appoint.doctor = doctor!
            appoint.branch = branch!
            appoint.slot = SlotArr[selectedIndexSlot!]
            appoint.shiftID = shiftId
            appoint.scheduleSerial = schedSerial
            appoint.specialityID = spec
            
            print(SlotArr[selectedIndexSlot!].schedual)
            appoint.dateDone = SlotArr[selectedIndexSlot!].id
            appoint.dateDoneEnd = SlotArr[selectedIndexSlot! + Int(serviceObject?.numberSlots ?? "0")! ].TIME_SLOT_END
            appoint.branchID = branchID!
            appoint.branch = branch!
            appoint.patientID = Utilities.sharedInstance.getPatientId()
            let vc =  ReservationConfirmVC()
            vc.speciality = speciality
            vc.serviceId = serviceObject?.id ?? ""
            vc.SelectedDoctorFromSearch = appoint
            vc.branch = branch
            vc.selectedSpeciality = selectedSpeciality
            vc.specialityID = specialityID ?? ""
            vc.url =    URL(string: "\(Constants.APIProvider.IMAGE_BASE)\(doctor?.DOCTOR_PIC ?? "")")
            
            self.navigationController?.pushViewController(vc, animated: true)
            
//            self.performSegue(withIdentifier: "ReservationConfirmVC", sender: nil)
        }
        
        else
        {
            if selectedIndexSlot == nil {
                Utilities.showAlert(self, messageToDisplay: UserManager.isArabic ? "من فضلك اختر وقت الحجز اولا" : "Kindly choose reservation time")
                return
            }
            if Utilities.sharedInstance.getPatientId() == "" {
    //            Utilities.showLoginAlert(vc: self.navigationController!)
    //            return
                
                
                let vc :   SignUpAsGuestVC = SignUpAsGuestVC()
                let shiftId = SlotArr[selectedIndexSlot!].shiftID
                let schedSerial = SlotArr[selectedIndexSlot!].schedual
                let spec = specialityID!
                let appoint = makeAppointment()
                appoint.doctor = doctor!
                appoint.branch = branch!
                appoint.slot = SlotArr[selectedIndexSlot!]
                appoint.shiftID = shiftId
                appoint.scheduleSerial = schedSerial
                appoint.specialityID = spec
                
                print(SlotArr[selectedIndexSlot!].schedual)
                appoint.dateDone = SlotArr[selectedIndexSlot!].id
                appoint.dateDoneEnd = SlotArr[selectedIndexSlot!].TIME_SLOT_END
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
                self.navigationController?.pushViewController(vc, animated: true)
                
                return
                
            }
            
//            self.performSegue(withIdentifier: "ReservationConfirmVC", sender: nil)
            
            let shiftId = SlotArr[selectedIndexSlot!].shiftID
            let schedSerial = SlotArr[selectedIndexSlot!].schedual
            let spec = specialityID!
            let appoint = makeAppointment()
            appoint.doctor = doctor!
            appoint.branch = branch!
            appoint.slot = SlotArr[selectedIndexSlot!]
            appoint.shiftID = shiftId
            appoint.scheduleSerial = schedSerial
            appoint.specialityID = spec
            
            print(SlotArr[selectedIndexSlot!].schedual)
            appoint.dateDone = SlotArr[selectedIndexSlot!].id
            appoint.dateDoneEnd = SlotArr[selectedIndexSlot! + Int(serviceObject?.numberSlots ?? "0")! ].TIME_SLOT_END
            appoint.branchID = branchID!
            appoint.patientID = Utilities.sharedInstance.getPatientId()
            let vc =  ReservationConfirmVC()
            vc.serviceId = serviceObject?.id ?? ""
            vc.speciality = speciality
            vc.SelectedDoctorFromSearch = appoint
            vc.gender = doctor?.gender ?? ""
            vc.branch = branch
            vc.selectedSpeciality = selectedSpeciality
            vc.specialityID = specialityID ?? ""
            vc.url =    URL(string: "\(Constants.APIProvider.IMAGE_BASE)\(doctor?.DOCTOR_PIC ?? "")")

            self.navigationController?.pushViewController(vc, animated: true)
        }
       
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
        TimeSlots.getSlotsTimes(branchID: branchID ?? "", clincID: clincID ?? "", docID: docID ?? "",date:selecteDate){ [self] slots,avDate, slotsTime in
          
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
//                if UserManager.isArabic{
//                    
//                    let formSheet = MZFormSheetController.init(viewController: slotNot(messageAr: messageAr, MessageEn: messageEN))
//                    formSheet.shouldDismissOnBackgroundViewTap = true
//                    formSheet.transitionStyle = .slideFromBottom
//                    formSheet.presentedFormSheetSize = CGSize.init(width: UIScreen.main.bounds.width * 0.9, height: 380)
//                    formSheet.shouldCenterVertically = true
//                    formSheet.present(animated: true, completionHandler: nil)
//                    
//                }
//                else{
//                    let formSheet = MZFormSheetController.init(viewController:  slotNot(messageAr: messageAr, MessageEn: messageEN))
//                    formSheet.shouldDismissOnBackgroundViewTap = true
//                    formSheet.transitionStyle = .slideFromBottom
//                    formSheet.presentedFormSheetSize = CGSize.init(width: UIScreen.main.bounds.width * 0.9, height: 340)
//                    formSheet.shouldCenterVertically = true
//                    formSheet.present(animated: true, completionHandler: nil)
//                    
//                }
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
