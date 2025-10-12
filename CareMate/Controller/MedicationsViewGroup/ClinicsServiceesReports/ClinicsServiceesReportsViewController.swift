//
//  ClinicsServiceesReportsViewController.swift
//  CareMate
//
//  Created by Mohamed Elmaazy on 06/06/2024.
//  Copyright © 2024 khabeer Group. All rights reserved.
//

import UIKit

class ClinicsServiceesReportsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrayReports = [ClinicServiceReportModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "نتائج خدمات العيادة" : "Clinic Services Reports", hideBack: false)
        initTable()
        getData()
    }
        
    func getData() {
        if Utilities.sharedInstance.getPatientId() == "" {
            Utilities.showLoginAlert(vc: self.navigationController!)
            return
        }
        let pars = "PATIENT_ID=" + Utilities.sharedInstance.getPatientId()
        let urlString = Constants.APIProvider.clinicServicesReports + pars
        indicator.sharedInstance.show()
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            if error == nil {
                var tempArray = [ClinicServiceReportModel]()
                if let array = ((data?["Root"] as? [String: AnyObject])?["MACHINE"] as? [String:AnyObject])?["MACHINE_ROW"] as? [[String: AnyObject]] { // array
                    for object in array {
                        let model = ClinicServiceReportModel()
                        model.ID = object["ID"] as? String ?? ""
                        model.NAME_AR = object["NAME_AR"] as? String ?? ""
                        model.NAME_EN = object["NAME_EN"] as? String ?? ""
                        model.COUNT_VAL = object["COUNT_VAL"] as? String ?? ""
                        tempArray.append(model)
                    }
                } else if let object = ((data?["Root"] as? [String: AnyObject])?["MACHINE"] as? [String:AnyObject])?["MACHINE_ROW"] as? [String: AnyObject] { // object
                    let model = ClinicServiceReportModel()
                    model.ID = object["ID"] as? String ?? ""
                    model.NAME_AR = object["NAME_AR"] as? String ?? ""
                    model.NAME_EN = object["NAME_EN"] as? String ?? ""
                    model.COUNT_VAL = object["COUNT_VAL"] as? String ?? ""
                    tempArray.append(model)
                }
                for item in tempArray {
                    if Int(item.COUNT_VAL) ?? 0 > 0 {
                        self.arrayReports.append(item)
                    }
                }
                if self.arrayReports.count > 0 {
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

class ClinicServiceReportModel {
    var ID = ""
    var NAME_AR = ""
    var NAME_EN = ""
    var COUNT_VAL = ""
}
