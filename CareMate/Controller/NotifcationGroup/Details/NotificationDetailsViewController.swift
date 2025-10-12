//
//  NotificationDetailsViewController.swift
//  CareMate
//
//  Created by m3azy on 27/09/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

class NotificationDetailsViewController: BaseViewController {

    @IBOutlet weak var viewData: UIView!
    @IBOutlet weak var labelFormTitle: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDat: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var lablDoctor: UILabel!
    @IBOutlet weak var labelNameTitil: UILabel!
    @IBOutlet weak var labelReserviationTitle: UILabel!
    @IBOutlet weak var labelDoctorTitle: UILabel!
    @IBOutlet weak var btnBackToHome: UIButton!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var viewReport: UIView!
    @IBOutlet weak var viewReservationDate: UIView!
    @IBOutlet weak var viewDoctorSpeciality: UIView!
    @IBOutlet weak var viewBranch: UIView!
    @IBOutlet weak var viewMedicalNumber: UIView!
    @IBOutlet weak var labelReportTitle: UILabel!
    @IBOutlet weak var labelReport: UILabel!
    @IBOutlet weak var labelBranchTitle: UILabel!
    @IBOutlet weak var labelBranch: UILabel!
    @IBOutlet weak var labelMedicalNumberTitle: UILabel!
    @IBOutlet weak var labelMedicalNumber: UILabel!
    @IBOutlet weak var viewMedTitle: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintHeightTableView: NSLayoutConstraint!
    @IBOutlet weak var labelMedTitle: UILabel!
    
    var notificationModel: notifcationDTO?
    var arrayMedicine = [NotificationModel]()
    
    init(_ model: notifcationDTO) {
        notificationModel = model
        super.init(nibName: "NotificationDetailsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHeader(isNotifcation: false, title: UserManager.isArabic ? "تفاصيل الاشعار" : "Notification Details")
        if UserManager.isArabic {
            labelNameTitil.text = "الاسم"
            labelReserviationTitle.text = "موعد الحجز"
            labelDoctorTitle.text = "الطبيب / التخصص"
            btnBackToHome.setTitle("العودة للصفحة الرئيسية", for: .normal)
            labelFormTitle.text = "عزيزى المراجع  يرجي العلم أن التقرير الطبي تم الإنتهاء من إعداده وجاهز للتسليم"
            labelReportTitle.text = "التقرير"
            labelBranchTitle.text = "الفرع"
            labelMedicalNumberTitle.text = "الرقم الطبى"
        }
        getData()
        initTableView()
    }
    
    func getData() {
        viewData.isHidden = true
        let urlString = Constants.APIProvider.loadPatNotificationDetails + "alertSerial=\(notificationModel?.ALERT_SERIAL ?? "")"
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            if error == nil {
                self.viewData.isHidden = false
                let root = ((((data as? [String: AnyObject]))?["Root"] as? [String: AnyObject])?["ALERT_DETAILS_DATA"] as? [String: AnyObject]) ?? [:]
                if root["ALERT_DETAILS_DATA_ROW"] is [String: AnyObject] {
                    let model = NotificationModel(JSON: root["ALERT_DETAILS_DATA_ROW"] as? [String: AnyObject] ?? [:], context: nil)
                    self.updateViews(model)
                } else if root["ALERT_DETAILS_DATA_ROW"] is [[String: AnyObject]] {
                    for item in root["ALERT_DETAILS_DATA_ROW"] as? [[String: AnyObject]] ?? [[:]] {
                        self.arrayMedicine.append(NotificationModel(JSON: item)!)
                    }
                    let item = self.arrayMedicine.last
                    self.arrayMedicine.removeLast()
                    self.updateViews(item)
                    self.constraintHeightTableView.constant = CGFloat(self.arrayMedicine.count * 50)
                    if self.constraintHeightTableView.constant > 300 {
                        self.constraintHeightTableView.constant = 300
                    }
                    self.tableView.reloadData()
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func updateViews(_ model: NotificationModel?) {
        guard let model = model else { return }
        switch notificationModel?.ALERT_ID {
        case "132": // doctor/speciality
            viewMedTitle.isHidden = true
            tableView.isHidden = true
            labelFormTitle.isHidden = true
            viewReport.isHidden = true
            viewBranch.isHidden = true
            viewMedicalNumber.isHidden = true
            labelName.text = UserManager.isArabic ? model.DOCTOR_NAME_AR : model.DOCTOR_NAME_EN
            let date = UserManager.isArabic ? model.ACTUAL_DATE_NAME_AR?.components(separatedBy: " ") : model.ACTUAL_DATE_NAME_EN?.components(separatedBy: " ")
            if date?.count ?? 0 > 2 {
                labelDat.text = date![0]
                labelTime.text = "\(date![1]) \(date![2]) \(date![3])"
            } else {
                viewReservationDate.isHidden = true
            }
            lablDoctor.text = UserManager.isArabic ? model.DOCTOR_NAME_AR : model.DOCTOR_NAME_EN
            break
        case "268": // report
            viewMedTitle.isHidden = true
            tableView.isHidden = true
            viewName.isHidden = true
            labelReserviationTitle.text = UserManager.isArabic ? "تاريخ الطلب" : "Request date"
            viewBranch.isHidden = true
            viewMedicalNumber.isHidden = true
            viewDoctorSpeciality.isHidden = true
            labelReport.text = UserManager.isArabic ? model.REPORT_NAME_AR : model.REPORT_NAME_EN
            let date = model.REPORT_DATE?.ConvertToDate
            if let date = date {
                labelDat.text = date.toWeekDay
                labelTime.text = "\(date.asStringWithTime)"
            } else {
                viewReservationDate.isHidden = true
            }
            break
        case "735":
            viewMedTitle.isHidden = true
            tableView.isHidden = true
            labelFormTitle.isHidden = true
            labelNameTitil.text = UserManager.isArabic ? "الطبيب" : "Doctor"
            viewReport.isHidden = true
            labelReserviationTitle.text = UserManager.isArabic ? "تاريخ الزيارة" : "Visit date"
            labelDoctorTitle.text = UserManager.isArabic ? "التخصص" : "Speciality"
            viewBranch.isHidden = true
            viewMedicalNumber.isHidden = true
            labelName.text = UserManager.isArabic ? model.DOC_NAME_AR : model.DOC_NAME_EN
            let date = model.VISIT_START_DATE?.ConvertToDate
            if let date = date {
                labelDat.text = date.toWeekDay
                labelTime.text = "\(date.asStringWithTime)"
            } else {
                viewReservationDate.isHidden = true
            }
            lablDoctor.text = UserManager.isArabic ? model.SPECIALITY_NAME_AR : model.SPECIALITY_NAME_EN
            break
        case "742":
            labelFormTitle.isHidden = true
            viewName.isHidden = true
            viewReport.isHidden = true
            viewReservationDate.isHidden = true
            viewDoctorSpeciality.isHidden = true
            viewBranch.isHidden = true
            viewMedicalNumber.isHidden = true
            labelMedTitle.text = UserManager.isArabic ? "عزيزي المراجع\n نود أحاطكم علما بأنه لم تتم الموافقة\n من قبل شركة التأمين علي الأدوية التالية" : "Dear reviewer\nPlease note that this medicines didn't had approval from insurance company"
            arrayMedicine.append(model)
            constraintHeightTableView.constant = 50
            self.tableView.reloadData()
            break
        case "741":
            labelFormTitle.isHidden = true
            viewName.isHidden = true
            viewReport.isHidden = true
            viewReservationDate.isHidden = true
            viewDoctorSpeciality.isHidden = true
            viewBranch.isHidden = true
            viewMedicalNumber.isHidden = true
            labelMedTitle.text = UserManager.isArabic ? "عزيزي المراجع\n نود أحاطكم علما بأنه  تم الموافقة\n من قبل شركة التأمين علي الأدوية التالية" : "Dear reviewer\nPlease note that this medicines had approval from insurance company"
            arrayMedicine.append(model)
            constraintHeightTableView.constant = 50
            self.tableView.reloadData()
            break
        default:
            break
        }
        
    }
    
    @IBAction func backToHome(_ sender: Any) {
//        if let nav = navigationController {
//            var index = 0
//            for (i, controller) in nav.viewControllers.enumerated() {
//                if controller is MedicalRecordVC {
//                    index = i
//                    break
//                }
//            }
//            nav.popToViewController(nav.viewControllers[index], animated: true)
//        } else {
        navigationController?.popToRootViewController(animated: true)
//        }
    }
}

import ObjectMapper

struct NotificationModel: Mappable {
    var ACTUAL_DATE_NAME_EN: String?
    var ACTUAL_DATE_NAME_AR: String?
    var SERVICE_NAME_EN: String?
    var SERVICE_NAME_AR: String?
    var PATIENT_NAME_AR: String?
    var PATIENT_NAME_EN: String?
    var DOCTOR_NAME_AR: String?
    var DOCTOR_NAME_EN: String?
    var RESERVATION_DATETIME: String?
    var REPORT_NAME_AR: String?
    var REPORT_NAME_EN: String?
    var REPORT_DATE: String?
    var VISIT_ID: String?
    var PATIENTID: String?
    var PATFINANACCOUNT: String?
    var VISIT_END_DATE: String?
    var VISIT_START_DATE: String?
    var SPECIALITY_NAME_EN: String?
    var SPECIALITY_NAME_AR: String?
    var DOC_NAME_EN: String?
    var DOC_NAME_AR: String?
    var ITEMCODE: String?
    var ITEMARNAME: String?
    var ITEMENNAME: String?
    var REQ_DATE: String?
    var DECISION_DATE: String?
    var TRANSDATE: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        REPORT_NAME_AR <- map["REPORT_NAME_AR"]
        REPORT_NAME_EN <- map["REPORT_NAME_EN"]
        REPORT_DATE <- map["REPORT_DATE"]
        TRANSDATE <- map["TRANSDATE"]
        ITEMCODE <- map["ITEMCODE"]
        ITEMARNAME <- map["ITEMARNAME"]
        ITEMENNAME <- map["ITEMENNAME"]
        REQ_DATE <- map["REQ_DATE"]
        DECISION_DATE <- map["DECISION_DATE"]
        VISIT_ID <- map["VISIT_ID"]
        PATIENTID <- map["PATIENTID"]
        PATFINANACCOUNT <- map["PATFINANACCOUNT"]
        VISIT_END_DATE <- map["VISIT_END_DATE"]
        VISIT_START_DATE <- map["VISIT_START_DATE"]
        SPECIALITY_NAME_EN <- map["SPECIALITY_NAME_EN"]
        SPECIALITY_NAME_AR <- map["SPECIALITY_NAME_AR"]
        DOC_NAME_EN <- map["DOC_NAME_EN"]
        DOC_NAME_AR <- map["DOC_NAME_AR"]
        ACTUAL_DATE_NAME_EN <- map["ACTUAL_DATE_NAME_EN"]
        ACTUAL_DATE_NAME_AR <- map["ACTUAL_DATE_NAME_AR"]
        SERVICE_NAME_EN <- map["SERVICE_NAME_EN"]
        SERVICE_NAME_AR <- map["SERVICE_NAME_AR"]
        PATIENT_NAME_EN <- map["PATIENT_NAME_EN"]
        PATIENT_NAME_AR <- map["PATIENT_NAME_AR"]
        DOCTOR_NAME_AR <- map["DOCTOR_NAME_AR"]
        DOCTOR_NAME_EN <- map["DOCTOR_NAME_EN"]
        RESERVATION_DATETIME <- map["RESERVATION_DATETIME"]
        
    }
}

//struct NotificationMedicineModel: Mappable {
//    var ITEMCODE: String?
//    var ITEMARNAME: String?
//    var ITEMENNAME: String?
//    var REQ_DATE: String?
//    var DECISION_DATE: String?
//
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//        ITEMCODE <- map["ITEMCODE"]
//        ITEMARNAME <- map["ITEMARNAME"]
//        ITEMENNAME <- map["ITEMENNAME"]
//        REQ_DATE <- map["REQ_DATE"]
//        DECISION_DATE <- map["DECISION_DATE"]
//    }
//}
