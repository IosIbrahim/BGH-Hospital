//
//  AmbulanceHistoryViewController.swift
//  CareMate
//
//  Created by m3azy on 25/09/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

class AmbulanceHistoryViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageViewAdd: UIView!
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var labelFilter: UILabel!
    @IBOutlet weak var viewClearFilter: UIView!
    @IBOutlet weak var labelClearFilter: UILabel!
    @IBOutlet weak var labelHint: UILabel!
    
    var arrayAmbulance = [AmbulanceModel]()
    var arrayAmbulanceFiltered = [AmbulanceModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHeader(title: UserManager.isArabic ? "الطلبات السابقة" : "Previous Orders")
        labelFilter.text =   UserManager.isArabic ? "فلتر البحث" : "Filter"
        labelClearFilter.text =   UserManager.isArabic ? "حذف الفلتر" : "Clear filter"
        initViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }

    func initViews() {
        initTableView()
        imageViewAdd.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openAddSurvey)))
        let gestureopenopenOperationCliked = UITapGestureRecognizer(target: self, action:  #selector(self.openFilter))
        self.viewFilter.addGestureRecognizer(gestureopenopenOperationCliked)
        viewClearFilter.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clearFilter)))
        if UserManager.isArabic {
            labelHint.text = "إضافة طلب إسعاف/خدمة منزلية"
        }
    }
    
    @objc func openAddSurvey() {
        let vc1 = CallerInfoViewController()
        vc1.fromMedicalRecord = true
        self.navigationController?.pushViewController(vc1, animated: true)
    }

    func getData() {
        arrayAmbulance.removeAll()
        tableView.reloadData()
        let urlString = Constants.APIProvider.ambulanceHistory+"BRANCH_ID=1&USER_ID=KHABEER&PATIENT_ID=\(Utilities.sharedInstance.getPatientId())"
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            if error == nil {
                if let array = (((data as? [String: AnyObject])?["Root"] as? [String: AnyObject])?["CALL"] as? [String: AnyObject])?["CALL_ROW"] {
                    if array is [[String: AnyObject]] {
                        let array = array as! [[String: AnyObject]]
                        for item in array {
                            self.arrayAmbulance.append(AmbulanceModel(JSON: item)!)
                            self.arrayAmbulanceFiltered.append(AmbulanceModel(JSON: item)!)
                        }
                    } else if array is [String: AnyObject] {
                        let array = array as! [String: AnyObject]
                        self.arrayAmbulance.append(AmbulanceModel(JSON: array)!)
                        self.arrayAmbulanceFiltered.append(AmbulanceModel(JSON: array)!)
                    } else {
                        self.setErrorLabelText(error: UserManager.isArabic ? "لا يوجد طلبات سابقة" : "No previous requests found")
                    }
                } else {
                    self.setErrorLabelText(error: UserManager.isArabic ? "لا يوجد طلبات سابقة" : "No previous requests found")
                }
                self.tableView.reloadData()
            } else {
                self.setErrorLabelText(error: UserManager.isArabic ? "لا يوجد طلبات سابقة" : "No previous requests found")
            }
        }
    }
   
    @objc func openFilter(sender : UITapGestureRecognizer) {
//        listOfFilterStatues.removeAll()
//        listOfFilterStatues.append(labStatuesModel(ID: "R", NAME_AR: "تم الطلب", NAME_EN: "For Sampling"))
//        listOfFilterStatues.append(labStatuesModel(ID: "F", NAME_AR: "تم التأكيد", NAME_EN: "Confirmed"))
//        listOfFilterStatues.append(labStatuesModel(ID: "W", NAME_AR: "تحتاج موافقة", NAME_EN: "Wait for Approval"))
//        listOfFilterStatues.append(labStatuesModel(ID: "P", NAME_AR: "تمت الموافقة", NAME_EN: "Approved"))
//        listOfFilterStatues.append(labStatuesModel(ID: "I", NAME_AR: "تم تسليم العينة (للكميائي)", NAME_EN: "Sample received (lab. doctor)"))
        
        let vc  = FilterLabRadViewController()
        vc.hideViewStatus = true
//        vc.listOfFilterStatues = listOfFilterStatues
        vc.delegte = self
//        self.navigationController?.pushViewController(vc, animated: true)
        AppPopUpHandler.instance.openVCPop(vc, height: 500, bottomSheet: true)
//        AppPopUpHandler.instance.openPopup(container: self, vc: vc)
        
//        AppPopUpHandler.instance.initListPopup(container: self, arrayNames: UserManager.isArabic ?  listOfFilterStatues.map{$0.NAME_AR} : listOfFilterStatues.map{$0.NAME_EN} , title: "Choose", type: "")
    }
    
    @objc func clearFilter() {
        arrayAmbulanceFiltered = arrayAmbulance
        tableView.reloadData()
        viewClearFilter.isHidden = true
    }
}

extension AmbulanceHistoryViewController :labRadFilter{
    
    func labRadFilterProtocal(statusName: String, Statues: String?, DATE_FROM_STR_FORMATED: String?, DATE_TO_STR_FORMATED: String?) {
        guard let dateFrom = DATE_FROM_STR_FORMATED?.ConvertToDate, let dateTo = DATE_TO_STR_FORMATED?.ConvertToDate else { return }
        arrayAmbulanceFiltered.removeAll()
        for item in arrayAmbulance {
            if item.CAL_DATE.ConvertToDate.isBetween(dateFrom, and: dateTo) {
                arrayAmbulanceFiltered.append(item)
            }
        }
        tableView.reloadData()
        viewClearFilter.isHidden = false
    }
}

import ObjectMapper

struct AmbulanceModel: Mappable {
    
    var SERIAL : String = ""
    var CALLAR_NAME : String = ""
    var CAL_DATE : String = ""
    var PATIENT_ID : String = ""
    var COMPLETEPATNAME_AR : String = ""
    var COMPLETEPATNAME_EN : String = ""
    var CALL_WF_NAME_AR : String = ""
    var CALL_WF_NAME_EN: String = ""
    var ACTION_SER: String = ""
    var CALL_TYPE: String = ""
    var CALL_TYPE_NAME_AR: String = ""
    var CALL_TYPE_NAME_EN: String = ""
    var CALL_PAT_TYPE: String = ""
    var CALL_PAT_TYPE_NAME_AR: String = ""
    var CALL_PAT_TYPE_NAME_EN: String = ""
    var HOME_VISIT_NURSE_NEED: String = ""
    var HOME_VISIT_DOC_NEED: String = ""
    var AMBULANCE_DOC_NEED: String = ""
    var AMBULANCE_NURSE_NEED: String = ""
    var AMBULANCE_CAR_TYPE: String = ""
    var HOME_VISIT_DOC_SPEC: String = ""
    var GOV_ID: String = ""
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        SERIAL <- map["SERIAL"]
        CALLAR_NAME <- map["CALLAR_NAME"]
        CAL_DATE <- map["CAL_DATE"]
        PATIENT_ID <- map["PATIENT_ID"]
        COMPLETEPATNAME_AR <- map["COMPLETEPATNAME_AR"]
        COMPLETEPATNAME_EN <- map["COMPLETEPATNAME_EN"]
        CALL_WF_NAME_AR <- map["CALL_WF_NAME_AR"]
        CALL_WF_NAME_EN <- map["CALL_WF_NAME_EN"]
        ACTION_SER <- map["ACTION_SER"]
        CALL_TYPE <- map["CALL_TYPE"]
        CALL_TYPE_NAME_AR <- map["CALL_TYPE_NAME_AR"]
        CALL_TYPE_NAME_EN <- map["CALL_TYPE_NAME_EN"]
        CALL_PAT_TYPE <- map["CALL_PAT_TYPE"]
        CALL_PAT_TYPE_NAME_AR <- map["CALL_PAT_TYPE_NAME_AR"]
        CALL_PAT_TYPE_NAME_EN <- map["CALL_PAT_TYPE_NAME_EN"]
        HOME_VISIT_NURSE_NEED <- map["HOME_VISIT_NURSE_NEED"]
        HOME_VISIT_DOC_NEED <- map["HOME_VISIT_DOC_NEED"]
        AMBULANCE_DOC_NEED <- map["AMBULANCE_DOC_NEED"]
        AMBULANCE_NURSE_NEED <- map["AMBULANCE_NURSE_NEED"]
        AMBULANCE_CAR_TYPE <- map["AMBULANCE_CAR_TYPE"]
        HOME_VISIT_DOC_SPEC <- map["HOME_VISIT_DOC_SPEC"]
        GOV_ID <- map["GOV_ID"]
    }
}

extension Date {
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
}
