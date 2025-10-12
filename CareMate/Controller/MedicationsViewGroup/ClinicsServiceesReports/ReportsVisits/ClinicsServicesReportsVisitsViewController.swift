//
//  ClinicsServicesReportsVisitsViewController.swift
//  CareMate
//
//  Created by Mohamed Elmaazy on 06/06/2024.
//  Copyright © 2024 khabeer Group. All rights reserved.
//

import UIKit

class ClinicsServicesReportsVisitsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var arrayVisits = [ClinicServiceReportVisitModel]()
    var ser = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "زيارات المريض" : "Patient Visits", hideBack: false)
        initTable()
        getData()
    }
        
    func getData() {
        if Utilities.sharedInstance.getPatientId() == "" {
            Utilities.showLoginAlert(vc: self.navigationController!)
            return
        }
        let pars = "PATIENT_ID=" + Utilities.sharedInstance.getPatientId() + "&SER=" + ser
        let urlString = Constants.APIProvider.clinicServicesReportsVisits + pars
        indicator.sharedInstance.show()
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            if error == nil {
                if let array = ((data?["Root"] as? [String: AnyObject])?["VISIT"] as? [String:AnyObject])?["VISIT_ROW"] as? [[String: AnyObject]] { // array
                    for object in array {
                        let model = ClinicServiceReportVisitModel()
                        model.VISIT_ID = object["VISIT_ID"] as? String ?? ""
                        model.VISIT_START_DATE = object["VISIT_START_DATE"] as? String ?? ""
                        self.arrayVisits.append(model)
                    }
                } else if let object = ((data?["Root"] as? [String: AnyObject])?["VISIT"] as? [String:AnyObject])?["VISIT_ROW"] as? [String: AnyObject] { // object
                    let model = ClinicServiceReportVisitModel()
                    model.VISIT_ID = object["VISIT_ID"] as? String ?? ""
                    model.VISIT_START_DATE = object["VISIT_START_DATE"] as? String ?? ""
                    self.arrayVisits.append(model)
                }
                if self.arrayVisits.count > 0 {
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

class ClinicServiceReportVisitModel {
    var VISIT_ID = ""
    var VISIT_START_DATE = ""
}
