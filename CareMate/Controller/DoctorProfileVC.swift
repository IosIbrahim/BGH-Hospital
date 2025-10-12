//
//  DoctorProfileVC.swift
//  CliniVisor
//
//  Created by Yo7ia on 7/21/18.
//  Copyright © 2018 Yo7ia. All rights reserved.
//

protocol gotToDoctorProfileFromDermenology {
    func gotToDoctorProfileFromDermenologyFunc(dermenologyService:Service)
    
}

import UIKit
import MZFormSheetController
import PopupDialog

class DoctorProfileVC: UITableViewController, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var bookNowBtn: UIButton!
    @IBOutlet weak var aboutDoctorLbl: UILabel!
    @IBOutlet weak var doctorSpeciality: UILabel!
    @IBOutlet weak var doctorQualifications: UILabel!
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var doctorImg: UIImageView!
  
    private var animationFinished = true
    var selectedIndex = 0
    var  serviceObject:Service?

    @IBOutlet weak var qualifcationCell: UITableViewCell!
    @IBOutlet weak var qulifactionCellDetails: UITableViewCell!
    var totalHeight = Constants.ScreenHeight-50
    @IBOutlet weak var currencyLbl: UILabel!
    
    @IBOutlet weak var waitingTimeLbl: UILabel!
    @IBOutlet weak var waitingTimeTitleLbl: UILabel!
    
    @IBOutlet weak var viewsCountLbl: UILabel!
    
    @IBOutlet weak var viewTitleLbl: UILabel!
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
    @IBOutlet weak var NoBranches: UILabel!

    @IBOutlet weak var doctorLocation: UILabel!
    var BusyDays: [Date] = [Date]()

    @IBOutlet weak var patientReviewsBtn: UIButton!
    @IBOutlet weak var bookNoteLbl: UILabel!
    @IBOutlet weak var bookNowLbl: UILabel!
    @IBOutlet weak var slotsCollectionView: UICollectionView!
    var currentDate = Date()
    var selectedDate : Date?
    var isFav = false
    var selectedTimeSlot = ""
    
    
    let Label = UILabel()
 
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var aboutHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var slotsViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var slotCollectionConstraint: NSLayoutConstraint!
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateComponents = DateComponents(year: 2021, month: 2)
        let calendar = Calendar.current
        let date34 = calendar.date(from: dateComponents)!
        let allDays = date34.getAllDays()

        print("allDays")
        print(allDays)
        
        Label.text = "No Branch"
        Label.numberOfLines = 0
      
        Label.textAlignment = .center
        Label.sizeToFit()
        Label.frame = CGRect(x: 50, y: 200, width: 200, height: 21)
        Label.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        Label.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        self.navigationController?.navigationBar.isHidden = false
      
//        setupTabBar.instance.setuptabBar(vc: self)
        let nib = UINib(nibName: "ReservCell", bundle: nil)
        
        let url = URL(string: "\(Constants.APIProvider.IMAGE_BASE)\(doctor?.DOCTOR_PIC ?? "")")
        
        print("http://192.168.1.235/primecaretest//\(doctor?.DOCTOR_PIC ?? "")")

        self.doctorImg.kf.setImage(with: url, placeholder: doctor?.gender == "M" ? UIImage(named: "doctor") : UIImage(named: "doctor_woman") , options: nil, completionHandler: nil)
        
        self.slotsCollectionView.register(nib, forCellWithReuseIdentifier: "Cell")
    }
    
    deinit {
        print("\(#function)")
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return totalHeight
        case 1:
            return 60
        case 2:
            return doctorQualifications.bounds.height + 30
        default:
            return 50
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.appearance().semanticContentAttribute = !UserManager.isArabic ? .forceLeftToRight : .forceRightToLeft
        CheckLang()

        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        IQKeyboardManager.sharedManager().enable = true
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
   
    @IBAction func BookNowClicked(_ sender: Any) {
//        let x = timeSlotsList.filter{$0.selected}
        
        if let serviceObjectConstant = self.serviceObject
        {
            if selectedIndex == nil {
                Utilities.showAlert(self, messageToDisplay: "Kindly choose reservation time")
                return
            }
            if Utilities.sharedInstance.getPatientId() == "" {
    //            Utilities.showLoginAlert(vc: self.navigationController!)
    //            return
                
                
                let vc :   SignUpAsGuestVC = SignUpAsGuestVC()
                let shiftId = SlotArr[selectedIndex].shiftID
                let schedSerial = SlotArr[selectedIndex].schedual
                let spec = specialityID!
                let appoint = makeAppointment()
                appoint.doctor = doctor!
                appoint.branch = branch!
                appoint.slot = SlotArr[selectedIndex]
                appoint.shiftID = shiftId
                appoint.scheduleSerial = schedSerial
                appoint.specialityID = spec
                
                print(SlotArr[selectedIndex].schedual)
                appoint.dateDone = SlotArr[selectedIndex].id
                appoint.dateDoneEnd = SlotArr[selectedIndex + Int(serviceObject!.numberSlots ?? "0")! ].TIME_SLOT_END
                appoint.branchID = branchID!
                appoint.patientID = Utilities.sharedInstance.getPatientId()
                vc.SelectedDoctorFromSearch = appoint
                self.navigationController?.pushViewController(vc, animated: true)
                
                return
                
            }
            
            self.performSegue(withIdentifier: "ReservationConfirmVC", sender: nil)
        }
        
        else
        {
            if selectedIndex == nil {
                Utilities.showAlert(self, messageToDisplay: "Kindly choose reservation time")
                return
            }
            if Utilities.sharedInstance.getPatientId() == "" {
    //            Utilities.showLoginAlert(vc: self.navigationController!)
    //            return
                
                
                let vc :   SignUpAsGuestVC = SignUpAsGuestVC()
                let shiftId = SlotArr[selectedIndex].shiftID
                let schedSerial = SlotArr[selectedIndex].schedual
                let spec = specialityID!
                let appoint = makeAppointment()
                appoint.doctor = doctor!
                appoint.branch = branch!
                appoint.slot = SlotArr[selectedIndex]
                appoint.shiftID = shiftId
                appoint.scheduleSerial = schedSerial
                appoint.specialityID = spec
                
                print(SlotArr[selectedIndex].schedual)
                appoint.dateDone = SlotArr[selectedIndex].id
                appoint.dateDoneEnd = SlotArr[selectedIndex].TIME_SLOT_END
                appoint.branchID = branchID!
                appoint.patientID = Utilities.sharedInstance.getPatientId()
                vc.SelectedDoctorFromSearch = appoint
                self.navigationController?.pushViewController(vc, animated: true)
                
                return
                
            }
            
            self.performSegue(withIdentifier: "ReservationConfirmVC", sender: nil)
        }
       

//
//        self.performSegue(withIdentifier: "ReservationConfirmVC", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let serviceObjectConstant = serviceObject
        {
            if segue.identifier == "ReservationConfirmVC"
            {
                let shiftId = SlotArr[selectedIndex].shiftID
                let schedSerial = SlotArr[selectedIndex].schedual
                let spec = specialityID!
                let appoint = makeAppointment()
                appoint.doctor = doctor!
                appoint.branch = branch!
                appoint.slot = SlotArr[selectedIndex]
                appoint.shiftID = shiftId
                appoint.scheduleSerial = schedSerial
                appoint.specialityID = spec
                
                print(SlotArr[selectedIndex].schedual)
                appoint.dateDone = SlotArr[selectedIndex].id
                appoint.dateDoneEnd = SlotArr[selectedIndex + Int(serviceObject?.numberSlots ?? "0")! - 1 ].TIME_SLOT_END
                appoint.branchID = branchID!
                appoint.patientID = Utilities.sharedInstance.getPatientId()
                let vc = segue.destination as! ReservationConfirmVC
                vc.serviceId = serviceObject?.id ?? ""
                vc.SelectedDoctorFromSearch = appoint
            }
        }
        else
        {
            
            if segue.identifier == "ReservationConfirmVC"
            {
                let shiftId = SlotArr[selectedIndex].shiftID
                let schedSerial = SlotArr[selectedIndex].schedual
                let spec = specialityID!
                let appoint = makeAppointment()
                appoint.doctor = doctor!
                appoint.branch = branch!
                appoint.slot = SlotArr[selectedIndex]
                appoint.shiftID = shiftId
                appoint.scheduleSerial = schedSerial
                appoint.specialityID = spec
                
                print(SlotArr[selectedIndex].schedual)
                appoint.dateDone = SlotArr[selectedIndex].id
                appoint.dateDoneEnd = SlotArr[selectedIndex].TIME_SLOT_END
                appoint.branchID = branchID!
                appoint.patientID = Utilities.sharedInstance.getPatientId()
                let vc = segue.destination as! ReservationConfirmVC
                vc.serviceId = serviceObject?.id ?? ""
                vc.SelectedDoctorFromSearch = appoint
            }
           
        }
       
    }
    

    func CheckLang() {
        self.title = UserManager.isArabic ? "عن الطبيب" : "About Doctor"
        self.doctorImg.roundedimage()
//        clincID = doctor?.clinicId
        self.tableView.allowsSelection = false
        self.currencyLbl.text = UserManager.isArabic ? "المؤهلات" : "Qualifications"
        self.bookNowBtn.setTitle(UserManager.isArabic ? "حجز الأن" : "Book Now", for: .normal)
        doctorName.text = UserManager.isArabic ? doctor?.englishNameAR :doctor?.englishName
        
//        if doctor?.qualificationAR == nil
//        {
//            qualifcationCell.isHidden = true
//            qulifactionCellDetails.isHidden = true
////        }
////        else
////        {
//            qualifcationCell.isHidden = false
//            qulifactionCellDetails.isHidden = false
////        }
        
        
        
        doctorQualifications.text = UserManager.isArabic ? doctor?.qualificationAR : doctor?.qualification
        doctorQualifications.sizeToFit()
        doctorImg.layer.cornerRadius = self.doctorImg.bounds.width / 2
        doctorImg.layer.borderWidth = 3
        doctorImg.layer.borderColor = #colorLiteral(red: 0, green: 0.7450980392, blue: 0, alpha: 1)
//        doctorImg.image = doctor?.gender == "M" ? #imageLiteral(resourceName: "doctor") : #imageLiteral(resourceName: "doctor_woman")
        
        
    
        
        self.doctorSpeciality.text = UserManager.isArabic ? doctor?.doctorCategoryAR : doctor?.doctorCategory!

//        self.bookNowBtn.setTitle(  "Book Now", for: .normal)
        
//        self.calendar.delegate = nil

        self.calendar.dataSource = self
            let mindate = Date()
            self.calendar.delegate = self
            self.calendar.allowsSelection = true
            self.calendar.allowsMultipleSelection = false
            //            self.calendar.reloadData()
            self.calendar.appearance.headerTitleColor = UIColor.white
            self.calendar.appearance.weekdayTextColor = UIColor.white
            self.calendar.appearance.titleDefaultColor = UIColor.white
            self.calendar.appearance.selectionColor = UIColor.green
            self.calendar.appearance.todaySelectionColor = UIColor.green
            self.calendar.appearance.todayColor = UIColor.clear
            //            self.calendar.select(SelectedDoctorFromSearch!.Branches[0].freedate.ConvertToDate, scrollToDate: true)
        self.calendar.scope = .month
            self.calendar.reloadData()
            
            self.calendar.select(mindate, scrollToDate: true)
            
//            self.calendar.deselect(mindate)
            self.getTimeSlots(date: mindate)
//        }
        
        
        
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        self.slotsCollectionView.delegate = self
//        self.slotsCollectionView.emptyDataSetSource = self
        self.slotsCollectionView.dataSource = self
//        self.slotsCollectionView.emptyDataSetDelegate = self
        self.slotsCollectionView.isScrollEnabled = false
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        let mindate = Date()
        
        return mindate
    }
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date().addDaysToCurrentDate(numofDays: 90)
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dates = Date.init(timeIntervalSince1970: date.timeIntervalSince1970)
        if(BusyDays.contains(dates))
        {
            print(dates.asString)
            cell.preferredFillDefaultColor = UIColor.red
            cell.preferredFillSelectionColor = UIColor.red
            cell.appearance.selectionColor = UIColor.red
            cell.appearance.todayColor = UIColor.red
            cell.appearance.todaySelectionColor = UIColor.red
            cell.appearance.eventDefaultColor = UIColor.red
        }
        else
        {
            cell.appearance.selectionColor = UIColor.green
            cell.appearance.todayColor = UIColor.clear
            cell.appearance.todaySelectionColor = UIColor.green



        }
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let dates = Date.init(timeIntervalSince1970: date.timeIntervalSince1970)
        if(BusyDays.contains(dates))
        {
            return false
        }
        return true
    }
   
    func calendarCurrentMonthDidChange(_ calendar: FSCalendar) {
        
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if BusyDays.contains(date ) || Date().trimTime.compare(date.addingTimeInterval(7200)) == .orderedDescending
        {
            return false
        }
        print("No Events")
        
        return true
    }
//
//    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
//
//    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
//        print("selected dates is \(selectedDates)")
//        if monthPosition == .next || monthPosition == .previous {
//            calendar.setCurrentPage(date, animated: true)
//        }
        
        print("Message from the CEOMessage from the CEOMessage from the CEOMessage from the CEOMessage from the CEOMessage from the CEOMessage from the CEO")
        print(date)
        let dates = Date.init(timeIntervalSince1970: date.timeIntervalSince1970)
        if(!BusyDays.contains(dates))
        {
            getTimeSlots(date: date)
        
        }
        
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getTimeSlots(date : Date)
    {
        
        SlotArr.removeAll()
        self.ReservArr.removeAll()
        selectedDate = date
        selectedIndex = 0
        SlotArr.removeAll()
        slotsCollectionView.reloadData()
        
        print("selectedDate!.asStringDMY")
        print(selectedDate!.asStringDMY)
        print("doctor?.clinicId")
        print(doctor?.clinicId)
        
        print("doctor?.id ")
        print(doctor?.id )
        TimeSlots.getSlotsTimes(branchID: branchID ?? "", clincID:clincID ?? "", docID:docID ?? "",date: selectedDate!.asStringDMY){ [self]
            slots,avDate,slotsDay
            in
            
            if slots != nil
            {
            let dat = avDate.ConvertToDate.asStringDMY
                if self.selectedDate!.asStringDMY != dat
                {
                    self.calendar.select(avDate.ConvertToDate, scrollToDate: true)
                    self.getTimeSlots(date: avDate.ConvertToDate)
                    return
                }
            self.ReservArr = slots!
            }
            for i in self.ReservArr
            {
                self.SlotArr.append(contentsOf: i.slotsarray?.SINGLE_HOUR_SLOTS_ROW ?? [])
            }
            self.SlotArr = self.SlotArr.filter{$0.statuse == "empty"}
            
            var slotheight = (self.SlotArr.count > 0 ? (self.SlotArr.count/5) : 2) * 40
            slotheight += 40
            UIView.animate(withDuration: 0.5, animations: {
                self.slotCollectionConstraint.constant = CGFloat(slotheight)
                self.slotsViewConstraint.constant = CGFloat(slotheight + 170)
                self.totalHeight = (320) + CGFloat(slotheight)
                self.slotsCollectionView.reloadData()
                self.view.layoutIfNeeded()
            })
            self.slotsCollectionView.isScrollEnabled = false
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            
            
            let messageAr = "الدكتور الذي تم اختياره ليس له جدول مواعيد في هذا اليوم اذا كنت ترغب في حجز موعد في الاوقات الغير متاحة على التطبيق يرجى التواصل معنا عبر "
            
            let messageEN = "The selected doctor does not have a schedule on the selected date.In case you which to take an appointment for unavailable dates please call"
            
            if self.SlotArr.count == 0
            {
                if UserManager.isArabic
                {
//                    Utilities.showAlert(messageToDisplay: "لا يوجد مواعيد متاحه")
                    
                    let formSheet = MZFormSheetController.init(viewController: slotNot(messageAr: messageAr, MessageEn: messageEN))
                    formSheet.shouldDismissOnBackgroundViewTap = true
                    formSheet.transitionStyle = .slideFromBottom
                    formSheet.presentedFormSheetSize = CGSize.init(width: UIScreen.main.bounds.width * 0.9, height: 380)
                    formSheet.shouldCenterVertically = true
                    formSheet.present(animated: true, completionHandler: nil)

                }
                else
                {
//                    Utilities.showAlert(messageToDisplay: "No Available Slots")
                    let formSheet = MZFormSheetController.init(viewController:  slotNot(messageAr: messageAr, MessageEn: messageEN))
                    formSheet.shouldDismissOnBackgroundViewTap = true
                    formSheet.transitionStyle = .slideFromBottom
                    formSheet.presentedFormSheetSize = CGSize.init(width: UIScreen.main.bounds.width * 0.9, height: 340)
                    formSheet.shouldCenterVertically = true
                    formSheet.present(animated: true, completionHandler: nil)

                }
            }
            if  self.SlotArr.count > 0
            {
//                self.Label.isHidden = true
                
             

            }
             else
            {
//                self.Label.isHidden = false

//                self.noSLot()

            }
            
        }
        
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    // MARK:- UITableViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SlotArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return  CGSize(width: 0, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.slotsCollectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ReservCell
        cell.configCell(slot: SlotArr[indexPath.row])
        if SlotArr.count == 0
        {
//            noSLot()

            
        }
        
        
        if let  serviceObjectConstant = serviceObject
        {
            
            if (selectedIndex + Int(serviceObjectConstant.numberSlots ?? "0")!) <= SlotArr.count
            {
                print("selectedIndex")
                print(selectedIndex)
                print("SlotArr.count")

                print(SlotArr.count)
                
                print("serviceObjectConstant.numberSlots ?? ")
                print(serviceObjectConstant.numberSlots ?? "0")
                
                if  selectedIndex..<(selectedIndex + Int(serviceObjectConstant.numberSlots ?? "0")!) ~= indexPath.row {
                    cell.slotTimeView.backgroundColor = UIColor.green
                    cell.timeSlotLabel.textColor = UIColor.white
                }
                
    //            if let selectedIndex = selectedIndex,
    //               indexPath.row >= selectedIndex || indexPath.row <= (selectedIndex + Int(serviceObjectConstant.numberSlots ?? "0")!)  {
    //                print("mostafa index")
    //                print(indexPath.row)
    //                print("mostafa selec")
    //                print(selectedIndex)
    //                cell.slotTimeView.backgroundColor = Color.GreenColor
    //                cell.timeSlotLabel.textColor = Color.white!
    //            }
                else {
                    cell.slotTimeView.backgroundColor = UIColor.white
                    cell.timeSlotLabel.textColor = UIColor.darkGray

                }
                
                return cell

            }
            
            else
            {
                cell.slotTimeView.backgroundColor = UIColor.white
                cell.timeSlotLabel.textColor = UIColor.darkGray

//                noSLot()

//                return cell

            }
            
        
        }
        
        else
        {
            
            if indexPath.row == selectedIndex
            {
                
                cell.slotTimeView.backgroundColor = UIColor.green
                cell.timeSlotLabel.textColor = UIColor.white
               
            }
            
            else
            {
                cell.slotTimeView.backgroundColor = UIColor.white
                cell.timeSlotLabel.textColor = UIColor.darkGray
            }
            
            
           
            return cell

        }
      
        
        return cell

    
    }
    
    
}
extension DoctorProfileVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size = CGSize.zero
        // collection view size minus the section inset spacing and in between spacing each of 10
        size.width = (collectionView.bounds.size.width)/6
        size.height =  35
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    func noSLot()  {
        
        let messageAr = "الدكتور الذي تم اختياره ليس له جدول مواعيد في هذا اليوم اذا كنت ترغب في حجز موعد في الاوقات الغير متاحة على التطبيق يرجى التواصل معنا عبر "
        
        let messageEN = "The selected doctor does not have a schedule on the selected date.In case you which to take an appointment for unavailable dates please call"
        let vc:slotNot =  slotNot(messageAr: messageAr, MessageEn: messageEN)

        if UserManager.isArabic
        {
//                    Utilities.showAlert(messageToDisplay: "لا يوجد مواعيد متاحه")
            
//            let formSheet = MZFormSheetController.init(viewController: PaymentPopupViewController())
//            formSheet.shouldDismissOnBackgroundViewTap = true
//            formSheet.transitionStyle = .slideFromBottom
//            formSheet.presentedFormSheetSize = CGSize.init(width: UIScreen.main.bounds.width * 0.9, height: 340)
//            formSheet.shouldCenterVertically = true
//            formSheet.present(animated: true, completionHandler: nil)
            
            
            
            let popup = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .zoomIn,  tapGestureDismissal: true)
            self.present(popup, animated: true, completion: nil)
        

        }
        else
        {
            
            let popup = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .zoomIn,  tapGestureDismissal: true)
            self.present(popup, animated: true, completion: nil)
        
//                    Utilities.showAlert(messageToDisplay: "No Available Slots")
//            let formSheet = MZFormSheetController.init(viewController: PaymentPopupViewController())
//            formSheet.shouldDismissOnBackgroundViewTap = true
//            formSheet.transitionStyle = .slideFromBottom
//            formSheet.presentedFormSheetSize = CGSize.init(width: UIScreen.main.bounds.width * 0.9, height: 340)
//            formSheet.shouldCenterVertically = true
//            formSheet.present(animated: true, completionHandler: nil)

        }
    }
}

//extension DoctorProfileVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
//    // ===============================================
//    // ==== DZNEmptyDataSet Delegate & Datasource ====
//    // ===============================================
//
//    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
//        return timeSlotsList.count == 0
//    }
//
//    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
//        return UIImage(named: "error")
//    }
//
//    func imageAnimation(forEmptyDataSet scrollView: UIScrollView!) -> CAAnimation! {
//        let animation = CABasicAnimation(keyPath: "transform")
//
//        animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
//        animation.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat(M_PI_2), 0.0, 0.0, 1.0))
//
//        animation.duration = 0.25
//        animation.isCumulative = true
//        animation.repeatCount = MAXFLOAT
//
//        return animation
//    }
//
//    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
//        let text =  "No appointments available"
////        let attributes = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeueLT W20 55 Roman", size: 17)!,NSAttributedStringKey.foregroundColor:Color.white!]
//
//        return NSAttributedString(string: text, attributes: attributes)
//    }
//}


//if let selectedIndex = selectedIndex,
//   selectedIndex == indexPath.row  {
//    cell.slotTimeView.backgroundColor = Color.GreenColor
//    cell.timeSlotLabel.textColor = Color.white!
//}
//else {
//    cell.slotTimeView.backgroundColor = UIColor.white
//    cell.timeSlotLabel.textColor = Color.darkGray!
//
//}
//return cell
extension Date
{
    mutating func addDays(n: Int)
    {
        var cal = Calendar.current
        self = cal.date(byAdding: .day, value: n, to: self)!
        cal.locale = Locale(identifier: "en_US_POSIX")
    }

    func firstDayOfTheMonth() -> Date {
        return Calendar.current.date(from:
                                        Calendar.current.dateComponents([.year,.month], from: self))!
        
    }

//    func getAllDays() -> [Date]
//    {
//        var days = [Date]()
//
//        var calendar = Calendar.current
//       // calendar.locale = Locale(identifier: "en_US_POSIX")
//        calendar.locale = .current
//        let range = calendar.range(of: .day, in: .month, for: self)!
//
//        var day = firstDayOfTheMonth()
//
//        for _ in range
//        {
//            days.append(day)
//            day.addDays(n: 1)
//        }
////        days.removeFirst()
//        return days
//    }
//}
    
        func getAllDays() -> [Date] {
            var calendar = Calendar.current
            calendar.locale = Locale(identifier: "en_US_POSIX")

            guard let range = calendar.range(of: .day, in: .month, for: self),
                  let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: self)) else {
                return []
            }

            let today = calendar.startOfDay(for: Date())
            var days: [Date] = []

            for day in range {
                if let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart),
                   date >= today {
                    days.append(date)
                }
            }
            return days
        }
    }
