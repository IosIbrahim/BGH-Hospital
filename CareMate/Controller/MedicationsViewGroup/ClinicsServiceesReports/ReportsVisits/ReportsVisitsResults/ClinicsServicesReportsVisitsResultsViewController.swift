//
//  ClinicsServicesReportsVisitsResultsViewController.swift
//  CareMate
//
//  Created by Mohamed Elmaazy on 07/06/2024.
//  Copyright © 2024 khabeer Group. All rights reserved.
//

import UIKit

class ClinicsServicesReportsVisitsResultsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var arrayResults = [ClinicServiceReportVisitResultModel]()
    var ser = ""
    var visitId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "النتيجة" : "Result", hideBack: false)
        initTable()
        getData()
    }
        
    func getData() {
        if Utilities.sharedInstance.getPatientId() == "" {
            Utilities.showLoginAlert(vc: self.navigationController!)
            return
        }
        let pars = "PATIENT_ID=" + Utilities.sharedInstance.getPatientId() + "&USER_ID=" + "KHABEER" + "&SER=" + ser + "&VISIT_ID=" + visitId
        let urlString = Constants.APIProvider.clinicServicesReportsVisitsResults + pars
        indicator.sharedInstance.show()
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            if error == nil {
                if let array = ((data?["Root"] as? [String: AnyObject])?["RESULT"] as? [String:AnyObject])?["RESULT_ROW"] as? [[String: AnyObject]] { // array
                    for object in array {
                        let model = ClinicServiceReportVisitResultModel()
                        model.SER = object["SER"] as? String ?? ""
                        model.RESULT_DATE = object["RESULT_DATE"] as? String ?? ""
                        model.RESULT_PATH = object["RESULT_PATH"] as? String ?? ""
                        model.RESULT_TYPE = object["RESULT_TYPE"] as? String ?? ""
                        model.SHOW_ADD_SIGN = object["SHOW_ADD_SIGN"] as? String ?? ""
                        model.SHOW_DELETE_SIGN = object["SHOW_DELETE_SIGN"] as? String ?? ""
                        self.arrayResults.append(model)
                    }
                } else if let object = ((data?["Root"] as? [String: AnyObject])?["RESULT"] as? [String:AnyObject])?["RESULT_ROW"] as? [String: AnyObject] { // object
                    let model = ClinicServiceReportVisitResultModel()
                    model.SER = object["SER"] as? String ?? ""
                    model.RESULT_DATE = object["RESULT_DATE"] as? String ?? ""
                    model.RESULT_PATH = object["RESULT_PATH"] as? String ?? ""
                    model.RESULT_TYPE = object["RESULT_TYPE"] as? String ?? ""
                    model.SHOW_ADD_SIGN = object["SHOW_ADD_SIGN"] as? String ?? ""
                    model.SHOW_DELETE_SIGN = object["SHOW_DELETE_SIGN"] as? String ?? ""
                    self.arrayResults.append(model)
                }
                if self.arrayResults.count > 0 {
                    self.tableView.reloadData()
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        NotificationCenter.default.post(name: Notification.Name("nodataFound"), object: nil)
                    }
                }
            }
        }
    }
}

class ClinicServiceReportVisitResultModel {
    var SER = ""
    var RESULT_DATE = ""
    var RESULT_PATH = ""
    var RESULT_TYPE = ""
    var SHOW_ADD_SIGN = ""
    var SHOW_DELETE_SIGN = ""
}
