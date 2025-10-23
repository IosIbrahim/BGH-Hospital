//
//  OffersVC.swift
//  الرومانسية
//
//  Created by Yo7ia on 3/19/18.
//  Copyright © 2018 Yo7ia. All rights reserved.
//



import UIKit
import BetterSegmentedControl
import DZNEmptyDataSet
import SCLAlertView
import SwiftyJSON
import MZFormSheetController

class MyAppoimentViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, AppointmentCellDelagete, backAfterFiltered{
    
    @IBOutlet weak var filertView: UIView!
    @IBOutlet weak var labelfilter: UILabel!
    @IBOutlet weak var segmentedControl: BetterSegmentedControl!
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var viewDoctor: UIView!
    @IBOutlet weak var labeldoctor: UILabel!
    @IBOutlet weak var viewClinic: UIView!
    @IBOutlet weak var labelClinic: UILabel!
    @IBOutlet weak var viewFrom: UIView!
    @IBOutlet weak var labelFrom: UILabel!
    @IBOutlet weak var viewTo: UIView!
    @IBOutlet weak var labelTo: UILabel!
    
    var cancelReasonsList = [cancelReason]()
    var filteredData = [AppointmentDTO]()
    var filteredDataForPrevious = [AppointmentDTO]()
    var allData = [AppointmentDTO]()
    var selectIndex:Int = -100
    var CurrentDate = Date()
    var mobileNumber = ""
    var isPopup = false
    var showUpcomming = true
    var vcType:reservationOfForget?
    var fromGuest = false
    var canceledCelled:AppoimentCollectionViewCell?
    var phoneNumber = ""
    var countryCode = ""
    
    override func viewDidLoad() {
        segmentedControl.indicatorViewBackgroundColor = UIColor(red: 0/255, green: 171/255, blue: 200/255, alpha: 1)

        let nib = UINib(nibName: "AppoimentCollectionViewCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "AppoimentCollectionViewCell")
        self.collectionView.emptyDataSetSource = self
        self.collectionView.emptyDataSetDelegate = self
        self.collectionView.allowsSelection = true
        self.hideKeyboardWhenTappedAround()
        segmentedControl.setIndex(0)
        isFromOrder = false
        initHeader(isNotifcation: false, isLanguage: true, title: UserManager.isArabic ? "حجوزاتي" : "My Appointment", hideBack: false)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(openAsGuest))
        self.filertView.addGestureRecognizer(gesture)
        labelfilter.text =   UserManager.isArabic ? "فلتر البحث" : "Filter"
        if UserManager.isArabic {
            scrollView.transform = CGAffineTransform(scaleX: -1, y: 1)
            for sub in stackView.subviews {
                sub.transform = CGAffineTransform(scaleX: -1, y: 1)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = UserManager.isArabic ? "حجوزاتي" : "My Appointments"
        if vcType != nil && vcType == .fromReservation {
            if fromGuest {
                GetDataForGuestReservations()
            }else {
                GetData()
            }
        } else {
            GetData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dismissKeyboard()
    }
    
    override func back() {
        if isPopup {
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
            } else {
                super.back()
            }
        } else {
            super.back()
        }
    }
    
    func backAfterFiltered(filterData1: [AppointmentDTO], doctorName: String, clinicName: String, from: String, to: String) {
        if doctorName == "" {
            viewDoctor.isHidden = true
        } else {
            viewDoctor.isHidden = false
            labeldoctor.text = doctorName
        }
        if clinicName == "" {
            viewClinic.isHidden = true
        } else {
            viewClinic.isHidden = false
            labelClinic.text = clinicName
        }
        if from == "" {
            viewFrom.isHidden = true
        } else {
            viewFrom.isHidden = false
            labelFrom.text = "\(UserManager.isArabic ? "من" : "From"): \(from)"
        }
        if to == "" {
            viewTo.isHidden = true
        } else {
            viewTo.isHidden = false
            labelTo.text = "\(UserManager.isArabic ? "الى" : "To"): \(to)"
        }
        self.filteredData = filterData1
        collectionView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func segmentedControl1ValueChanged(_ sender: BetterSegmentedControl) {
        print("The selected index is \(sender.index)")
        showUpcomming = sender.index == 0
        filterData()
    }
    
    func filterData() {
        filteredData = allData.filter({ (appoint) -> Bool in
            let date = appoint.eXPECTEDDONEDATE.ConvertToDate
            if showUpcomming {
                filertView.isHidden = true
                scrollView.isHidden = true
                return date.trimTime.compare(Date().trimTime) != ComparisonResult.orderedAscending
            } else {
                filertView.isHidden = false
                scrollView.isHidden = false
                viewDoctor.isHidden = true
                viewClinic.isHidden = true
                viewFrom.isHidden = true
                viewTo.isHidden = true
                return date.trimTime.compare(Date().trimTime) == ComparisonResult.orderedAscending
            }
        })
        filteredDataForPrevious = filteredData
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func openAsGuest() {
        let vc = filterPreviousViewController(filterData: filteredDataForPrevious)
        vc.delegate = self
        let formSheet = MZFormSheetController.init(viewController: vc)
        formSheet.shouldDismissOnBackgroundViewTap = true
        formSheet.transitionStyle = .slideFromBottom
        formSheet.presentedFormSheetSize = CGSize.init(width: UIScreen.main.bounds.width * 0.9, height: 550)
        formSheet.shouldCenterVertically = true
        formSheet.present(animated: true, completionHandler: nil)
    }
    
    func GetDataForGuestReservations() {
        if allData.isEmpty {
            indicator.sharedInstance.show()
        }
        segmentedControl.segments = LabelSegment.segments(withTitles: [UserManager.isArabic ? "القادمة" : "Upcomming", UserManager.isArabic ? "السابقة" : "Previous"],normalTextColor: .black,selectedTextColor: .white)
        NotificationCenter.default.addObserver(self, selector: #selector(self.ReloadAppointments(notification:)), name: NSNotification.Name(rawValue: "UpdateAppointment"), object: nil)
      
  
        let urlString = Constants.APIProvider.OutpatientControllersearchOpCallCenter+"PAT_TEL=\(phoneNumber)&COUNTERY_TEL_KEY=\(countryCode)&SERV_TYPE=\(1)&INDEX_FROM=1&INDEX_TO=100&BRANCH_ID=1"
//        let url = URL(string: urlString)
//        let parseUrl = Constants.APIProvider.OutpatientControllersearchOpCallCenter + Constants.getoAuthValue(url: url!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            indicator.sharedInstance.dismiss()
            if error == nil {
                if let root = ((data as? [String: AnyObject])?["Root"] as? [String:AnyObject])?["REQUEST"] as? [String: AnyObject] {
                    print(JSON(data?.result))
                    self.filteredData.removeAll()
                    self.filteredDataForPrevious.removeAll()
                    self.allData.removeAll()
                    if root["REQUEST_ROW"] is [[String:AnyObject]] {
                        let appoins = root["REQUEST_ROW"] as! [[String: AnyObject]]
                        for i in appoins {
                            print(i)
                            self.filteredData.append(AppointmentDTO(JSON: i)!)
                            self.filteredDataForPrevious.append(AppointmentDTO(JSON: i)!)
                        }
                    } else if root["REQUEST_ROW"] is [String:AnyObject] {
                        self.filteredData.append(AppointmentDTO(JSON:root["REQUEST_ROW"] as! [String:AnyObject])!)
                        self.filteredDataForPrevious.append(AppointmentDTO(JSON:root["REQUEST_ROW"] as! [String:AnyObject])!)
                        print("self.filteredData.count")
                        print(self.filteredData.count)
                    }
                } else {
                    self.filteredData.removeAll()
                    self.filteredDataForPrevious.removeAll()
                }
                self.allData = self.filteredData
                self.filterData()
            }
        }
    }
    
    func GetData() {
        segmentedControl.segments = LabelSegment.segments(withTitles: [UserManager.isArabic ? "القادمة" : "Upcomming", UserManager.isArabic ? "السابقة" : "Previous"],normalTextColor: .black,selectedTextColor: .white)
        NotificationCenter.default.addObserver(self, selector: #selector(self.ReloadAppointments(notification:)), name: NSNotification.Name(rawValue: "UpdateAppointment"), object: nil)
        if Utilities.sharedInstance.getPatientId() == "" {
            Utilities.showLoginAlert(vc: self.navigationController!)
            return
        }
        let urlString = Constants.APIProvider.MyAppointment+"PATIENT_ID=\(Utilities.sharedInstance.getPatientId().trimmed)&INIT=1"
        let url = URL(string: urlString)
        let parseUrl = Constants.APIProvider.MyAppointment + Constants.getoAuthValue(url: url!, method: "GET")
        if allData.isEmpty {
            indicator.sharedInstance.show()
        }
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: parseUrl, parameters: nil, vc: self) { (data, error) in
            if error == nil {
                if let root = ((data as? [String: AnyObject])?["Root"] as? [String:AnyObject])?["CANCEL_REASON"] as? [String:AnyObject] {
                    self.filteredData.removeAll()
                    self.filteredDataForPrevious.removeAll()
                    self.allData.removeAll()
                    self.cancelReasonsList.removeAll()
                    if root["CANCEL_REASON_ROW"] is [[String:AnyObject]]{
                        let appoins = root["CANCEL_REASON_ROW"] as! [[String: AnyObject]]
                        for i in appoins {
                            self.cancelReasonsList.append(cancelReason(JSON: i)!)}
                    } else if root["CANCEL_REASON_ROW"] is [String:AnyObject]{
                        self.cancelReasonsList.append(cancelReason(JSON:root["CANCEL_REASON_ROW"] as![String:AnyObject] )!)
                    }
                }
                if let root = ((data as? [String: AnyObject])?["Root"] as? [String:AnyObject])?["REQUEST"] as? [String:AnyObject] {
                    if root["REQUEST_ROW"] is [[String:AnyObject]] {
                        let appoins = root["REQUEST_ROW"] as! [[String: AnyObject]]
                        for i in appoins {
                            print(i)
                            self.filteredData.append(AppointmentDTO(JSON: i)!)
                            self.filteredDataForPrevious.append(AppointmentDTO(JSON: i)!)
                        }
                    } else if root["REQUEST_ROW"] is [String:AnyObject] {
                        self.filteredData.append(AppointmentDTO(JSON:root["REQUEST_ROW"] as![String:AnyObject] )!)
                        self.filteredDataForPrevious.append(AppointmentDTO(JSON:root["REQUEST_ROW"] as![String:AnyObject] )!)
                    }
                } else {
                    self.filteredData.removeAll()
                    self.filteredDataForPrevious.removeAll()
                }
                self.allData = self.filteredData
                self.filterData()
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
                self.collectionView .reloadData()
            }
        }
    }
    
    @objc func ReloadAppointments(notification:NSNotification) {
        if vcType != nil && vcType == .fromReservation {
            if fromGuest {
                GetDataForGuestReservations()
            }else {
                GetData()
            }
        } else {
            GetData()
        }
    }
    
    func CancelOrderClicked(_ data: AppoimentCollectionViewCell) {
        // cancel
        OPEN_OPTION_POPUP(container: self, message: UserManager.isArabic ? "هل انت متاكد من حذف هذا الموعد؟" : "Are you sure you want to cancel this appointment?") { ok in
            if !ok { return }
            if self.vcType != nil && self.vcType == .fromReservation  {
                if self.fromGuest && self.self.cancelReasonsList.isEmpty {
                    self.cancelReservation(data)
                }else if self.fromGuest {
                    self.showCancelPop(data)
                }else {
                    self.cancelReservation(data)
                }
            }
            else {
                self.showCancelPop(data)
            }
        }
    }
    
    func showCancelPop(_ data:AppoimentCollectionViewCell) {
        AppPopUpHandler.instance.initListPopup(container: self, arrayNames: UserManager.isArabic ? self.cancelReasonsList.map{$0.NAME_AR}: self.cancelReasonsList.map{$0.NAME_EN}, title: UserManager.isArabic ? "اختر سبب الالغاء" : "Choose Cancel Reason", type: "cancel")
        self.canceledCelled = data
    }
    
    func cancelReservation(_ data:AppoimentCollectionViewCell) {
        self.canceledCelled = data
        self.selectIndex = data.selectIndex
        let type = fromGuest ? canceledCelled?.data?.CallFutureFlag :canceledCelled?.data?.DETECT_TYPE
            let pars = ["BRANCH_ID": self.canceledCelled!.data!.hOSP_ID ,
                        "COMPUTER_NAME":"ios" ,
                        "SERV_TYPE":"1",
                        "DOC_ID": self.canceledCelled?.data?.DOC_ID ?? "",
                        "REASON_DELETE": "No Reasons" ,
                        "DETECT_TYPE":type ?? "",
                        "PATIENT_ID": Utilities.sharedInstance.getPatientId(),
                        "SER":  self.canceledCelled!.data!.sER,
                        "buffer_status": "3",
            ] as [String : String]
            let urlString = Constants.APIProvider.SubmitAppointment
            let url = URL(string: urlString)
            let parseUrl = Constants.APIProvider.SubmitAppointment + Constants.getoAuthValue(url: url!, method: "POST")
            WebserviceMananger.sharedInstance.makeCall(method: .post, url: parseUrl, parameters: pars, vc: self) { (data, error) in
                let root = (data as? [String:AnyObject])?["Root"] as? [String: AnyObject] ?? .init()
                if root.keys.contains("OUT_PARMS")
                {
                    let messageRow = (root["OUT_PARMS"] as? [String: AnyObject])?["OUT_PARMS_ROW"] as? [String : AnyObject] ?? .init()
                    print(messageRow)
                    OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "تم الغاء الحجز بنجاح" : "Appointment has been cancelled successfuly")
                    self.updateList("Canceled")
                    if self.fromGuest {
                        self.GetDataForGuestReservations()
                    }else {
                        self.GetData()
                    }
                    
                }else {
                    OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "حصل خطآ غير معروف حاول مرة اخري" : "UnKnown Error Occured Please Try Again")
                }
            }
    }
    
    func CellClicked(_ data: AppoimentCollectionViewCell) {
        let doctorsVC = DoctorsViewController()
        doctorsVC.branchId = data.data!.hOSP_ID
        let pars = ["ID": data.data!.hOSP_ID , "NAME_AR": data.data!.hOSP_NAME_AR, "NAME_EN": data.data!.hOSP_NAME_EN]
        var branch = Branch()
        branch.id = data.data!.hOSP_ID
        branch.arabicName = data.data!.hOSP_NAME_AR
        branch.englishName = data.data!.hOSP_NAME_EN
        branch.BRANCH_TYPE = "1"
        doctorsVC.branch = branch
        doctorsVC.specialityId = data.data!.sPECIAL_SPEC_ID
        doctorsVC.guestName = data.data?.COMPLETEPATNAME_AR ?? ""
        doctorsVC.guestPhone = data.data?.PAT_TEL ?? ""
        doctorsVC.guestPhoneCode = data.data?.PAT_TEL_COUNTRY_CODE ?? ""
        doctorsVC.guestBithDate = data.data?.DATEOFBIRTH ?? ""
        doctorsVC.guestGender = UserManager.isArabic ? data.data?.GENDER_NAME_AR ?? "" : data.data?.GENDER_NAME_EN ?? ""
        doctorsVC.guestIdentityType = UserManager.isArabic ? data.data?.IDENT_TYPE_NAME_AR ?? "" : data.data?.IDENT_TYPE_NAME_EN ?? ""
        doctorsVC.guestSSN = data.data?.PAT_SSN ?? ""
        doctorsVC.isScedule = true
        doctorsVC.guestGender = UserManager.isArabic ? data.data?.GENDER_NAME_AR ?? "" : data.data?.GENDER_NAME_EN ?? ""
        isReschedule = true
        reservationID = data.data!.sER
        //        AppPopUpHandler.instance.openVCPop(doctorsVC, height: 400)
        self.navigationController?.show(doctorsVC, sender: self)
    }
    
    func rateClicked(_ data: AppoimentCollectionViewCell) {
        selectIndex = data.selectIndex
        if data.data!.sTATUS_NAME_EN == "New" || data.data!.sTATUS_NAME_EN == "Future" { // confirm
            let detectType = data.data?.DETECT_TYPE ?? ""
            let pars = ["BRANCH_ID": data.data!.hOSP_ID ,
                        "COMPUTER_NAME":"ios" ,
                        "SERV_TYPE":"1",
                        "DOC_ID": data.data?.DOC_ID ?? "",
                        "DETECT_TYPE": detectType,
                        "REASON_DELETE": "Confirmed Through Mobile APP" ,
                        "PATIENT_ID": Utilities.sharedInstance.getPatientId(),
                        "SER": data.data!.sER,
                        "STATUS": "4",
                        "USER_ID": "KHABEER",
                        "NOTES": "",
                        "REQ_TYPE": detectType,
                        "PROCESS_ID": "18234",
            ] as [String : String]
            let urlString = Constants.APIProvider.ConfirmAppointment
            let url = URL(string: urlString)
            let parseUrl = Constants.APIProvider.ConfirmAppointment + Constants.getoAuthValue(url: url!, method: "POST")
            WebserviceMananger.sharedInstance.makeCall(method: .post, url: parseUrl, parameters: pars, vc: self) { (data, error) in
                let code = (data as? [String: AnyObject])?["code"] as? Int ?? 0
                if code == 1 {
                    OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "تم تاكيد الحجز بنجاح" : "Appointment has been confirmed successfuly")
                    self.updateList("Confirmed")
                    self.GetData()
                } else {
                    Utilities.showSuccessAlert(self, messageToDisplay: (data as? [String: AnyObject])?["message"] as? String ?? "")
                }
            }
        } else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "QuestionaryVC") as? QuestionaryVC
            nextViewController?.visit_id = data.data?.VISIT_ID ?? ""
            self.navigationController?.pushViewController(nextViewController!, animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      //  self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return  CGSize(width: 0, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppoimentCollectionViewCell", for: indexPath) as! AppoimentCollectionViewCell
        cell.delegate = self
        cell.isUpcomming = segmentedControl.index == 0
        cell.selectIndex = indexPath.row
        cell.configureCell(vc: self,data: filteredData[indexPath.row])
        return cell
    }
    
    func updateList(_ status:String) {
        allData[selectIndex].sTATUS_NAME_EN = status
        collectionView.reloadData()
    }
    
}
extension MyAppoimentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size = CGSize.zero
        // collection view size minus the section inset spacing and in between spacing each of 10
        size.width = (collectionView.bounds.size.width) - 10
        
        let date = self.filteredData[indexPath.row].eXPECTEDDONEDATE.ConvertToDate
        if date.trimTime.compare(Date().trimTime) == ComparisonResult.orderedAscending {
            if filteredData[indexPath.row].sTATUS_NAME_EN == "Performed" && filteredData[indexPath.row].EVAL_STATUS == "0" {
                size.height =  200
            } else {
                size.height =  200
            }
        } else {
            if filteredData[indexPath.row].sTATUS_NAME_EN == "New" || filteredData[indexPath.row].sTATUS_NAME_EN == "Future" {
                size.height =  300
            } else {
                size.height =  200
            }
        }
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
}

extension MyAppoimentViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    // ===============================================
    // ==== DZNEmptyDataSet Delegate & Datasource ====
    // ===============================================
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return filteredData.count == 0
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "error")
    }
    
    func imageAnimation(forEmptyDataSet scrollView: UIScrollView!) -> CAAnimation! {
        let animation = CABasicAnimation(keyPath: "transform")
        
        animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        animation.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat(M_PI_2), 0.0, 0.0, 1.0))
        
        animation.duration = 0.25
        animation.isCumulative = true
        animation.repeatCount = MAXFLOAT
        
        return animation
    }
    
    //    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    //        let text =  UserManager.isArabic ?  "لا توجد مواعيد" : "No appointment found !"
    //        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17),NSAttributedStringKey.foregroundColor:Color.darkGray]
    //
    //        return NSAttributedString(string: text, attributes: attributes)
    //    }
}


extension MyAppoimentViewController:ListPopupDelegate{
    func listPopupDidSelect(index: Int, type: String) {
        self.cancelReservation(self.canceledCelled ?? .init())
//        let pars = ["BRANCH_ID": self.canceledCelled!.data!.hOSP_ID ,
//                    "COMPUTER_NAME":"ios" ,
//                    "SERV_TYPE":"1",
//                    "DETECT_TYPE":self.canceledCelled?.data?.DETECT_TYPE ?? "",
//                    "DOC_ID": self.canceledCelled!.data!.DOC_ID,
//                    "REASON_DELETE": cancelReasonsList[index].ID,
//                    "PATIENT_ID": Utilities.sharedInstance.getPatientId(),
//                    "SER":  self.canceledCelled!.data!.sER,
//                    "buffer_status": "3",
//        ] as [String : String]
//        let urlString = Constants.APIProvider.SubmitAppointment
//        print(pars)
////        let url = URL(string: urlString)
////        let parseUrl = Constants.APIProvider.SubmitAppointment + Constants.getoAuthValue(url: url!, method: "POST")
//        WebserviceMananger.sharedInstance.makeCall(method: .post, url: urlString, parameters: pars, vc: self) { (data, error) in
//            let root = (data as! [String:AnyObject])["Root"] as! [String: AnyObject]
//            if root.keys.contains("OUT_PARMS")
//            {
//                let messageRow = (root["OUT_PARMS"] as! [String: AnyObject])["OUT_PARMS_ROW"] as! [String : AnyObject]
//                
//                //                let englishMsg = messageRow["SER"] as! String
//                Utilities.showSuccessAlert(self, messageToDisplay:"Appointment has been cancelled successfuly")
//                if self.vcType != nil && self.vcType == .fromReservation
//                {
//                    self.GetDataForGuestReservations()
//                }
//                else
//                {
//                    self.GetData()
//                    
//                }
//                
//            }
//        }
    }
}
