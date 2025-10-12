//
//  ReservationSuccessVC.swift
//  CliniVisor
//
//  Created by Yo7ia on 8/28/18.
//  Copyright © 2018 Yo7ia. All rights reserved.
//
import UIKit
import EventKit

protocol ClinicReservationDonePopupDelegate {
    func closeDonePopup()
}

class ReservationSuccessVC: UIViewController {
    
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var thanksLabel: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var doctorLocation: UILabel!
    @IBOutlet weak var reservationID: UILabel!
    @IBOutlet weak var reservationIDText: UILabel!
    @IBOutlet weak var DoctorNameText: UILabel!
    @IBOutlet weak var viewBook: UIView!
    @IBOutlet weak var dayTextLabel: UILabel!
    @IBOutlet weak var pmTextLabel: UILabel!
    @IBOutlet weak var bookNowBtn: UILabel!
    @IBOutlet weak var labelBranchTitle: UILabel!
    @IBOutlet weak var labelBranch: UILabel!
    @IBOutlet weak var clinicTitle: UILabel!
    @IBOutlet weak var labelClinic: UILabel!
    @IBOutlet weak var labelLocationTitle: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelInstructions: UILabel!
    @IBOutlet weak var labelGetInstructions: UILabel!
    @IBOutlet weak var viewAddToCalendar: UIView!
    @IBOutlet weak var labelAddToCart: UILabel!
    
    var delegate:ClinicReservationDonePopupDelegate?
    var SelectedDoctorFromSearch: makeAppointment?
    var clinicName = ""
    var location = ""
    var speciality = ""
    var instructions = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reservationIDText.text = UserManager.isArabic ? "كود الحجز" : "Reservation Code"
        DoctorNameText.text = UserManager.isArabic ? "اسم الطبيب" : "Doctor Name"
        labelBranchTitle.text = UserManager.isArabic ? "الفرع" : "Branch"
        clinicTitle.text = UserManager.isArabic ? "التخصص" : "Speciality"
        labelLocationTitle.text = UserManager.isArabic ? "الموقع" : "Location"
        labelGetInstructions.text = UserManager.isArabic ? "إضغط هنا لمعرفة تعليمات الموعد" : "Click here for appointment instructions"
        labelInstructions.text = instructions
        viewBook.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(confirmClicked)))
        viewAddToCalendar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addToCalendar)))
        labelGetInstructions.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getInstructions)))
        labelGetInstructions.underline()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        successLabel.text = UserManager.isArabic ? "تم الحجز بنجاح" : "Your Booking is Successful"
        labelAddToCart.text = UserManager.isArabic ? "إضافة الي التقويم" : "Add to calendar"
        successLabel.textAlignment = .center
        labelAddToCart.textAlignment = .center
        doctorName.text = UserManager.isArabic ?  SelectedDoctorFromSearch?.doctor?.englishNameAR :  SelectedDoctorFromSearch?.doctor?.englishName
        dateLbl.text = SelectedDoctorFromSearch!.dateDone.formateDAte(dateString: SelectedDoctorFromSearch?.dateDone ?? "" , formateString: "dd MMMM yyyy")
        dayTextLabel.text = SelectedDoctorFromSearch?.dateDone.formateDAte(dateString: SelectedDoctorFromSearch?.dateDone ?? "" , formateString: "EEEE")
//        pmTextLabel.text = SelectedDoctorFromSearch!.dateDone.formateDAte(dateString: SelectedDoctorFromSearch?.dateDone ?? "" , formateString: "a")
//        let time = SelectedDoctorFromSearch!.slot!.id.characters.suffix(8)
//        let arr = time.components(separatedBy: ":")
//        if arr.count > 1 {
//            if Int(arr[0]) ?? 0 > 12 {
//                timeLbl.text = "\((Int(arr[0]) ?? 0) - 12):\(arr[1])"
//            } else {
//                timeLbl.text = "\((Int(arr[0]) ?? 0)):\(arr[1])"
//            }
//        }
        timeLbl.text = SelectedDoctorFromSearch?.slot?.id.ConvertToDate.ToTimeOnly ?? "asdasdasd"
        reservationID.text = SelectedDoctorFromSearch?.reservationID ?? "asdasdas"
        bookNowBtn.text = UserManager.isArabic ? "تم" : "Ok"
        labelBranch.text = UserManager.isArabic ? SelectedDoctorFromSearch?.branch?.arabicName ?? "" : SelectedDoctorFromSearch?.branch?.englishName ?? ""
        labelClinic.text = speciality
        labelLocation.text = location
        if labelClinic.text == "" {
            labelClinic.text = clinicName
        }
    }
    
    @objc func confirmClicked() {
        isFromOrder = true
        mz_dismissFormSheetController(animated: true) { _ in
            self.delegate?.closeDonePopup()
        }
    }
    
    @IBAction func closeClicked(sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("GoToHome"), object: nil)
        self.dismissAnimated()
    }
    
    @objc func getInstructions() {
        openWebsite(url: "\(Constants.APIProvider.IMAGE_BASE)images/instructions.pdf")
    }
    
    @objc func addToCalendar() {
        let eventTitle = "\(UserManager.isArabic ? "حجز مع الدكتور" : "Reservation with doctor") \(UserManager.isArabic ? SelectedDoctorFromSearch!.doctor!.englishNameAR! :  SelectedDoctorFromSearch!.doctor!.englishName!)"
        let eventStartDate = SelectedDoctorFromSearch?.dateDone.ConvertToDate ?? Date() // Set your start date
        let eventEndDate = eventStartDate.addingTimeInterval(900) // 1/4 hour later

        addEventToCalendar(title: eventTitle, startDate: eventStartDate, endDate: eventEndDate)
    }
    
    func addEventToCalendar(title: String, startDate: Date, endDate: Date) {
        let eventStore = EKEventStore()

        // Check for calendar access permission
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized, .fullAccess, .writeOnly:
            createEvent(eventStore: eventStore, title: title, startDate: startDate, endDate: endDate)
        case .denied:
            // Handle denied access
            print("Access to calendar is denied.")
        case .notDetermined:
            // Request calendar access
            eventStore.requestAccess(to: .event, completion:
                { (granted: Bool, error: Error?) in
                    if granted {
                        self.createEvent(eventStore: eventStore, title: title, startDate: startDate, endDate: endDate)
                    } else {
                        // Handle denied access
                        print("Access to calendar is denied.")
                    }
                })
        case .restricted:
            // Handle restricted access
            print("Access to calendar is restricted.")
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }

    func createEvent(eventStore: EKEventStore, title: String, startDate: Date, endDate: Date) {
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents

        do {
            try eventStore.save(event, span: .thisEvent)
            print("Event added to calendar.")
        } catch {
            print("Error adding event to calendar: \(error.localizedDescription)")
        }
        DispatchQueue.main.async {
            self.mz_dismissFormSheetController(animated: true) { _ in
                self.delegate?.closeDonePopup()
            }
        }
//        self.view.showToast(toastMessage: UserManager.isArabic ? "تمت الاضافة الي المفكرة" : "Added to calendar", duration: 2)
    }
}
