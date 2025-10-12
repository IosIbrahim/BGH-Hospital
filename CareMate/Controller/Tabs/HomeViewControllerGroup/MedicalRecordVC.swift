//
//  MedicalRecordVC.swift
//  CareMate
//
//  Created by Yo7ia on 12/31/18.
//  Copyright © 2018 khabeer Group. All rights reserved.
//

import UIKit
import MapKit
import SCLAlertView
import MOLH

class MedicalRecordVC: BaseViewController
{
    
    @IBOutlet weak var uilabelRequestEmegency: UILabel!
    @IBOutlet weak var LabelInvocies: UILabel!
    @IBOutlet weak var LabelRequestEmerency: UILabel!
    @IBOutlet weak var LabelrequestReport: UILabel!
    @IBOutlet weak var uilabelComplian: UILabel!
    @IBOutlet weak var usernumberLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var questionareLbl: UILabel!
    @IBOutlet weak var myappointmentLbl: UILabel!
    @IBOutlet weak var MedicalـOverview : UILabel!
    @IBOutlet weak var openPatientHistory: UIView!
    @IBOutlet weak var openSickLeave: UIView!
    @IBOutlet weak var openHospitalViews: UIView!
    @IBOutlet weak var openLocationss: UIView!
    @IBOutlet weak var openCurrentMedVC: UIView!
    @IBOutlet weak var openQuestionary: UIView!
    @IBOutlet weak var openMedicationOverView: UIView!
    @IBOutlet weak var openOperation: UIView!
    @IBOutlet weak var openProfile: UIView!
    @IBOutlet weak var reservationCliked: UIView!
    @IBOutlet weak var viewMyAppoiment: UIView!
    @IBOutlet weak var viewLanguage: UIView!
    @IBOutlet weak var viewBook: UIView!


    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var pickerCounter: RoundUIView!
    @IBOutlet weak var uilabelQuetinaryDetails: UILabel!
    @IBOutlet weak var uilabel365: uilabelCenter!
    @IBOutlet weak var uilabel365Details: uilabelCenter!
    @IBOutlet weak var uilabelHello: UILabel!
    @IBOutlet weak var uilabelServices: UILabel!

    @IBOutlet weak var uilabelBookAppoiment: UILabel!
    @IBOutlet weak var uilabelBookAppoimentDetails: UILabel!
    @IBOutlet weak var uilabelBook: UILabel!


    
   
    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var openHospitalCliked: UIView!
    @IBOutlet weak var viewMakeRequest: UIView!
    @IBOutlet weak var reservationsLAbel: UILabel!
    @IBOutlet weak var DoseReminder: UILabel!
    @IBOutlet weak var Diet: UILabel!
    @IBOutlet weak var Locations: UILabel!
    var branches = [Branch]()
    var selectedBranch: Branch?

    @IBOutlet weak var reportRequets: UIView!
    @IBOutlet weak var invoices: UIView!
    @IBOutlet weak var requestEmergency: UIView!
    @IBOutlet weak var viewComplains: UIView!
    @IBOutlet weak var viewNotifications: UIView!
    @IBOutlet weak var viewOpenProfile: UIView!
    @IBOutlet weak var viewKnowYourDoctor: UIView!
    @IBOutlet weak var labelKnowDoctor: uilabelCenter!
    
    @IBOutlet weak var cellOne: UITableViewCell!
    
    @IBOutlet weak var imageViewIn: UIImageView!
    @IBOutlet weak var imageViewFacebook: UIImageView!
    @IBOutlet weak var imageViewinsta: UIImageView!
    @IBOutlet weak var imageViewYoutube: UIImageView!
    @IBOutlet weak var imageViewDerma: UIImageView!
    @IBOutlet weak var imageViewTwitter: UIImageView!
    @IBOutlet weak var lobalContact: UILabel!
    @IBOutlet weak var imageViewSurvey: UIImageView!
    @IBOutlet weak var imageViewVirtualTour: UIImageView!
    @IBOutlet weak var viewChat: UIView!
    @IBOutlet weak var labelChat: uilabelCenter!
    @IBOutlet weak var viewHelpSupport: UIView!
    @IBOutlet weak var labelHelp: uilabelCenter!
    var isLoaded = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("✅ Current lang:", MOLHLanguage.currentAppleLanguage())

        openQuestionary.Rounded(corner: 20)
        
        imageViewSurvey.loadFromUrl(url: ConstantsData.survey, placeHolder: "quetionary")
        imageViewVirtualTour.loadFromUrl(url: ConstantsData.vitual, placeHolder: "Image 5")

        if UserManager.isArabic
        {
            
            reservationsLAbel.text = "الحجوزات"
            uilabelComplian.text = "اقتراحات و شكاوي"
            labelKnowDoctor.text = "إعرف طبيبك"
            lobalContact.text = "تواصل معنا عبر"
            labelChat.text = "تواصل مع سالم"
            labelHelp.text = "المساعدة والدعم"
        }
        else
        {
            reservationsLAbel.text = "Reservations"
            uilabelComplian.text = "Complaints & Suggestions"
        }
        viewKnowYourDoctor.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openKnowDoctor)))
        let gestureComplains = UITapGestureRecognizer(target: self, action:  #selector(self.OpenComplains))
        self.viewComplains.addGestureRecognizer(gestureComplains)

        viewOpenProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openProfileTab)))
        let gestureviewBook = UITapGestureRecognizer(target: self, action:  #selector(self.OpenBook))
        self.viewBook.addGestureRecognizer(gestureviewBook)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.reservationCliked.addGestureRecognizer(gesture)
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(self.chatWhatsapp))
        //fself.viewChat.addGestureRecognizer(gesture2)


        let gestureRequestEmergency = UITapGestureRecognizer(target: self, action:  #selector(self.openRequestEmergency))
        self.requestEmergency.addGestureRecognizer(gestureRequestEmergency)
        
        let gestureLoctionss = UITapGestureRecognizer(target: self, action:  #selector(self.openRequestlocationsss))
        self.openLocationss.addGestureRecognizer(gestureLoctionss)
        

        let gestureReports = UITapGestureRecognizer(target: self, action:  #selector(self.openReportsRequest))
        self.reportRequets.addGestureRecognizer(gestureReports)

        let gestureinvoices = UITapGestureRecognizer(target: self, action:  #selector(self.openInvocie))
        self.invoices.addGestureRecognizer(gestureinvoices)
        
        
        
        let gestureCurrentMedVC = UITapGestureRecognizer(target: self, action:  #selector(self.openDoseReminder))
        self.openCurrentMedVC.addGestureRecognizer(gestureCurrentMedVC)
        
        let gestureMyAppointmentVC = UITapGestureRecognizer(target: self, action:  #selector(self.openMyAppoiment))
        self.viewMyAppoiment.addGestureRecognizer(gestureMyAppointmentVC)

        
        
        let gestureLaguange = UITapGestureRecognizer(target: self, action:  #selector(self.openLanguageVC))
        self.viewLanguage.addGestureRecognizer(gestureLaguange)
        
        viewNotifications.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openNotifications)))
        
       // viewHelpSupport.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chatWhatsapp2)))
        let openMedicationOverViewCliked = UITapGestureRecognizer(target: self, action:  #selector(self.opendMedication))
        self.openMedicationOverView.addGestureRecognizer(openMedicationOverViewCliked)
        let gestureopenopenopenQuestionary = UITapGestureRecognizer(target: self, action:  #selector(self.openquesCliked))
        self.openQuestionary.addGestureRecognizer(gestureopenopenopenQuestionary)
        let gestureopenHospitalViews = UITapGestureRecognizer(target: self, action:  #selector(self.openHospitalViewsCliked))
        self.openHospitalViews.addGestureRecognizer(gestureopenHospitalViews)


        imageViewIn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(linkedIn)))
        imageViewFacebook.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(facebook)))
        imageViewinsta.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(instagram)))
        imageViewYoutube.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(youtube)))
        imageViewDerma.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(derma)))
        imageViewTwitter.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(twitter)))
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(noUserFound), name: Notification.Name("noUserFound"), object: nil)
        nc.addObserver(self, selector: #selector(updatePush), name: Notification.Name("new.push.notifications"), object: nil)
        showNotificationPopUp()
    }
    
    @objc func updatePush() {
        getNotificationCount()
    }
    
    func showNotificationPopUp() {
        if let dic = UserDefaults.standard.object(forKey: "remoteNotif") as? [String:Any] {
            print(dic)
            let abs = dic["aps"] as? [String:Any]
            let alert = abs?["alert"] as? [String:Any]
            let body = alert?["body"] as? String ?? ""
            UserDefaults.standard.removeObject(forKey: "remoteNotif")
            let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector.matches(in: body, options: [], range: NSRange(location: 0, length: body.utf16.count))
            for match in matches {
                guard let range = Range(match.range, in: body) else { continue }
                let url = body[range]
                print(url)
                guard let url = URL(string: String(url)) else { return }
                UIApplication.shared.open(url)
            }
                
        }
    }
    
    @objc func noUserFound(){
        let vc = BHGLoginController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func openProfileTab() {
        self.tabBarController?.selectedIndex = 2
    }
    
    @objc func openNotifications() {
        navigationController?.pushViewController(NotifcationsViewController(), animated: true)
    }
    
    @objc func openLanguageVC(sender : UITapGestureRecognizer) {
        self.navigationController?.pushViewController(LanguageViewController(), animated: true)
    }

    
    @IBAction func OpenOurNotifcation(_ sender: Any) {
        AppPopUpHandler.instance.openVCPop(vc, height: 600)
    }
    
    let vc =  NotifcationsViewController()
   
    
    
    @objc func openHospitalViewsCliked(sender : UITapGestureRecognizer) {
        navigationController?.pushViewController(Choose365HospitalViewController(), animated: true)
    }
    
    @objc func openquesCliked(sender : UITapGestureRecognizer) {
        let vc = VisitsViewController()
        vc.gotoSurvery = true
        vc.isSurvey = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func openOperationCliked(sender : UITapGestureRecognizer) {
//        let vc1:OperationViewController = OperationViewController(patientId: Utilities.sharedInstance.getPatientId(), branchId: "1")

//        self.navigationController?.pushViewController(vc1, animated: true)
    }
    @objc func checkAction(sender : UITapGestureRecognizer) {

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let v1 = storyBoard.instantiateViewController(withIdentifier: "BranchesViewController") as! BranchesViewController
        v1.fromMedicalRecord = true
        v1.vcType = .fromReservation
        self.navigationController?.pushViewController(v1, animated: true)
    }
    
    @objc func openReportsRequest(sender : UITapGestureRecognizer) {
        let vc1:reportRequestsViewController = reportRequestsViewController(patientId: Utilities.sharedInstance.getPatientId(), branchId: "1")
        self.navigationController?.pushViewController(vc1, animated: true)
//
//        let vc1:complainListViewController = complainListViewController(patientId: currentPatientIDOrigni, branchId: "1")
//        self.navigationController?.pushViewController(vc1, animated: true)
    }
    @objc func opendrugs(sender : UITapGestureRecognizer) {

        
        let vc1:RXOFPatientViewController = RXOFPatientViewController(month: 1)
    
              self.navigationController?.pushViewController(vc1, animated: true)
    }
    
    @objc func OpenComplains(sender : UITapGestureRecognizer) {
        let vc1:complainListViewController = complainListViewController(patientId: currentPatientIDOrigni, branchId: "1")
        print(Utilities.sharedInstance.getPatientId())
       
        self.navigationController?.pushViewController(vc1, animated: true)
    }
    @objc func OpenBook(sender : UITapGestureRecognizer) {
//        let vc1:BrnachiesViewController = BrnachiesViewController()
//
//        vc1.vcType = .fromReservation
//        vc1.fromMedicalRecord = true
//        self.navigationController?.pushViewController(vc1, animated: true)
        self.tabBarController?.selectedIndex = 1
    }
    
    @objc func OpenSickLeave(sender : UITapGestureRecognizer) {
        let vc1:sickLeaveViewController = sickLeaveViewController(patientId: Utilities.sharedInstance.getPatientId(), branchId: "1")

        self.navigationController?.pushViewController(vc1, animated: true)
    }
    @objc func OpenPatientHistory(sender : UITapGestureRecognizer) {
        let vc1:PatientHistoryViewController = PatientHistoryViewController(patientId: Utilities.sharedInstance.getPatientId(), branchId: "1")
       
        self.navigationController?.pushViewController(vc1, animated: true)
    }
    
    @objc func opendMedication(sender : UITapGestureRecognizer) {
        let vc1:MedicationsViewViewController = MedicationsViewViewController()
       
        self.navigationController?.pushViewController(vc1, animated: true)
    }
    

    @objc func OpenHospital(sender : UITapGestureRecognizer) {
        let vc1:viewAllHospital = viewAllHospital(Url: "https://sih-kw.com/vtour/basement-final/sihb.html", title: "")
       
        self.navigationController?.pushViewController(vc1, animated: true)
    }
    
    @objc func openInvocie(sender : UITapGestureRecognizer) {
        let vc1:InvoicesAndReceiptsViewController = InvoicesAndReceiptsViewController()
       
        self.navigationController?.pushViewController(vc1, animated: true)
    }
    @objc func openRequestEmergency(sender : UITapGestureRecognizer) {
        navigationController?.pushViewController(AmbulanceHistoryViewController(), animated: true)
    }
    
    @objc func showLanguage()
    {
        let alertView = SCLAlertView()
            alertView.addButton("English") {
                alertView.dismissAnimated()
//                UserManager.language = "en"
                self.GoToHomeView()
            }
            alertView.addButton("Arabic") {
                alertView.dismissAnimated()
//                UserManager.language = "ar"
                self.GoToHomeView()
            }
        alertView.showTitle("Note", subTitle:  "Choose language ", style: .notice, closeButtonTitle: "Dismiss", timeout: nil, colorStyle: 0x3788B0, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: .topToBottom)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
//
    override func viewWillAppear(_ animated: Bool) {
        if isLoaded {
            getNotificationCount()
        }
        super.viewWillAppear(animated)
        
        let imageUrl = "\(Constants.APIProvider.IMAGE_BASE)\(UserDefaults.standard.object(forKey: "patImage") as? String ?? "")"
        imageViewUser.loadFromUrl(url: imageUrl, placeHolder: "profileHome")
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.title = UserManager.isArabic ? "التقارير الطبية" : "Medical Record"

        self.uilabelHello.text = UserManager.isArabic ? "اهلا وسهلا بك" : "Hello"
        self.uilabelServices.text = UserManager.isArabic ? "خدماتنا" : "Our Services"
        self.uilabelBook.text = UserManager.isArabic ? "حجز موعد" : "Book Appointment"
        self.uilabelBookAppoiment.text = UserManager.isArabic ? "حجز موعد" : "Book Appointment"
        
        self.uilabelBookAppoimentDetails.text = UserManager.isArabic ? "لحجز موعد مع نخبة متميزة من الأطباء" : "Book an appointment with a distinguished group of doctors"
        let p = "Virtual Tour (360)"
        self.uilabel365.text = UserManager.isArabic ? "جولة إفتراضيه (360)" : p
        self.uilabel365Details.text = UserManager.isArabic ? "تجول في مرافقنا" : "Tour our facilities"
        self.uilabelQuetinaryDetails.text = UserManager.isArabic ? "آرائكم تهمنا" : "Your opinion matters"

        self.MedicalـOverview.text = UserManager.isArabic ? "الملف الطبي" : "Medical Overview"
        self.myappointmentLbl.text = UserManager.isArabic ? "حجوزاتي" : "My Appointments"
        self.questionareLbl.text = UserManager.isArabic ? "إستطلاع رأي" : "Survey"
        self.DoseReminder.text = UserManager.isArabic ? "منبه الدواء" : "Dose Reminder"
        
        self.Locations.text = UserManager.isArabic ? "موقعنا" : "Our Locations"
        uilabelRequestEmegency.text =  UserManager.isArabic ? "زيارة منزلية/اسعاف" : "Ambulance/ Home Visit"
        LabelInvocies.text = UserManager.isArabic ? "الماليات"  :"Invocies"
        LabelrequestReport.text = UserManager.isArabic ? "طلب تقرير طبي" : "Medical Report Request"

//        user name
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: "SavedPerson") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(LoginedUser.self, from: savedPerson) {
                userNameLabel.text = loadedPerson.COMPLETEPATNAME_EN
                usernumberLabel.text = loadedPerson.PATIENTID.trimmed
            }
        }
   //     getNotificationCount()
    }
//
    
    func getNotificationCount() {
      let url =  Constants.APIProvider.getNotificationCount+"\(Utilities.sharedInstance.getPatientId())"
        print(url)
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: url, parameters: nil, vc: self, showIndicator: false) { (data, error) in
            if error == nil {
                if let bigRoot = (data as? [String: Any])?["Root"] as? [String: Any] {
                    let alert = bigRoot["ALERT_COUNTS"] as? [String: Any] ?? [String: Any]()
                    let alertCount = alert["ALERT_COUNTS_ROW"] as? [String: Any] ?? [String: Any]()
                    let count = alertCount["ALERT_COUNTS_RESULT"] as? String ?? ""
                    let cnt = Int(count) ?? .zero
                    self.lblCounter.textAlignment = .center
                    if cnt == .zero {
                        self.pickerCounter.isHidden = true
                    }else if cnt > 99 {
                        self.pickerCounter.isHidden = false
                        self.lblCounter.text = "+99"
                    }else {
                        self.lblCounter.text = "\(cnt)"
                        self.pickerCounter.isHidden = false
                    }
                }
            } else {
                self.pickerCounter.isHidden = true
            }
        }
    }
    
    
    @objc func openRequestlocationsss(sender : UITapGestureRecognizer) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let v1 = storyBoard.instantiateViewController(withIdentifier: "BranchesViewController") as! BranchesViewController
        v1.fromMedicalRecord = true
        v1.vcType = .fromOUrLocation
        self.navigationController?.pushViewController(v1, animated: true)
    }
    
    
    @objc func openMyAppoiment(sender : UITapGestureRecognizer) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let v1 = MyAppoimentViewController()
        self.navigationController?.pushViewController(v1, animated: true)
//        let input = "This is a test with the URL https://www.hackingwithswift.com to be detected."
//        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
//        let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
//
//        for match in matches {
//            guard let range = Range(match.range, in: input) else { continue }
//            let url = input[range]
//            print(url)
//            guard let url = URL(string: String(url)) else { return }
//            UIApplication.shared.open(url)
//        }
    }
    
    
    @objc func openDoseReminder(sender : UITapGestureRecognizer) {
        let v1 = DoseReminderHomeViewController()
        self.navigationController?.pushViewController(v1, animated: true)
    }
    
    
    func openMap() {
            let latitude = ConstantsData.lat1
            let longitude = ConstantsData.long1
            let appleURL = "http://maps.apple.com/?daddr=\(latitude),\(longitude)"
            let googleURL = "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving"
            let wazeURL = "waze://?ll=\(latitude),\(longitude)&navigate=false"

            let googleItem = ("Google Map", URL(string:googleURL)!)
            let wazeItem = ("Waze", URL(string:wazeURL)!)
            var installedNavigationApps = [("Apple Maps", URL(string:appleURL)!)]

            if UIApplication.shared.canOpenURL(googleItem.1) {
                installedNavigationApps.append(googleItem)
            }

            if UIApplication.shared.canOpenURL(wazeItem.1) {
                installedNavigationApps.append(wazeItem)
            }

            let alert = UIAlertController(title: "Selection", message: "Select Navigation App", preferredStyle: .actionSheet)
            for app in installedNavigationApps {
                let button = UIAlertAction(title: app.0, style: .default, handler: { _ in
                    UIApplication.shared.open(app.1, options: [:], completionHandler: nil)
                })
                alert.addAction(button)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true)
        }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func openKnowDoctor() {
//        navigationController?.pushViewController(WebViewViewController(UserDefaults.standard.object(forKey: UserManager.isArabic ? "knowYourDoctorAr" : "knowYourDoctorEn") as? String ?? "" , showShare: false), animated: true)
        navigationController?.pushViewController(DoctorsSearchViewController(), animated: true)
    }
    
    @objc func linkedIn() {
        openUrl(ConstantsData.linkedin)
    }
    
    @objc func facebook() {
        openUrl(ConstantsData.facebook)
    }
    
    @objc func instagram() {
        openUrl(ConstantsData.instegram)
    }
    
    @objc func youtube() {
        openUrl(ConstantsData.youtube)
    }
    @objc func derma() {
        openUrl(ConstantsData.drama)
    }
    
    @objc func twitter() {
        openUrl(ConstantsData.twitter)
    }
    
//    func openUrl(_ url: String) {
//        let urlString = url
//        let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//        if let URL = URL(string: urlStringEncoded!) {
//            if UIApplication.shared.canOpenURL(URL) {
//                UIApplication.shared.open(URL , options: [:], completionHandler: nil)
//
//            }
//        }
//    }
    
    @objc func chatWhatsapp2() {
//        openUrl("https://api.whatsapp.com/send?phone=\("+96594032241")")
        navigationController?.pushViewController(GuideAndSupportViewController(), animated: true)
    }
}
extension MedicalRecordVC: SpecialityFilterDelegate {
 func specialityFilter(_ specialityFilter: SpecialityFilter, didSelectSpeciality speciality: Speciality) {
//   specialityFilterPopup?.dismiss()
    
     Branch.getOnlineAppointment() { onlineAppointments, branchesDic  in
    guard let onlineAppointments = onlineAppointments else {
        return
        
    }
         self.branches = onlineAppointments
         self.selectedBranch = self.branches[0]
         
         // Create a custom view controller
         let specialityFilter = SpecialityFilter(nibName: "SpecialityFilter", bundle: nil)
         specialityFilter.delegate = self

        let doctorsVC = DoctorsViewController()
             doctorsVC.branchId = self.selectedBranch?.id
             doctorsVC.branch = self.selectedBranch!
        doctorsVC.specialityId = speciality.id
             doctorsVC.SpecType = speciality.SPEC_TYPE ?? ""

        isReschedule = false
             
        self.navigationController?.pushViewController(doctorsVC, animated: true)
 }
}
    
    @objc func chatWhatsapp() {
        sendMessageWhatsApp(ConstantsData.whatsapp)
    }
    
    func sendMessageWhatsApp(_ number: String) {
        let urlString = UserManager.isArabic ?
        "https://api.whatsapp.com/send/?phone=9651830003&text=سلام+سالم+لنتحدث" : "https://api.whatsapp.com/send/?phone=9651830003&text=Hello+Salem+let’s+chat"
        openUrl(urlString)
        print (number)
    }
    
    func openWhatsApp(number: String) {
        openUrl("https://api.whatsapp.com/send/?phone=9651830003")
    }
    
    
}
