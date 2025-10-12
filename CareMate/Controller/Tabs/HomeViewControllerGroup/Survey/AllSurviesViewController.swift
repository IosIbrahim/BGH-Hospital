//
//  AllSurviesViewController.swift
//  CareMate
//
//  Created by m3azy on 19/09/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

class AllSurviesViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageViewAdd: UIImageView!
    
    var arraySurvey = [SurveyModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHeader(title: UserManager.isArabic ? "الإستطلاعات السابقة" : "Previous Surveys")
        initViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }

    func initViews() {
        initTableView()
        imageViewAdd.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openAddSurvey)))
    }
    
    @objc func openAddSurvey() {
        let vc = VisitsViewController()
        vc.gotoSurvery = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func getData() {
        let urlString = Constants.APIProvider.allSurvies+"SearchID=\(Utilities.sharedInstance.getPatientId())&QuestionnaireType=1&BranchID=1"
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            if error == nil {
                if let root = (data as? [String: AnyObject])?["Root"] as? [String:AnyObject] {
                    if let array = (root["STP_PAT_SATISFACTION_MASTER"] as? [String:AnyObject])?["STP_PAT_SATISFACTION_MASTER_ROW"] as? [[String: AnyObject]] {
                        for item in array {
                            self.arraySurvey.append(SurveyModel(JSON: item)!)
                        }
                        self.tableView.reloadData()
                        return
                    } else {
                        if let object = (root["STP_PAT_SATISFACTION_MASTER"] as? [String:AnyObject])?["STP_PAT_SATISFACTION_MASTER_ROW"] as? [String: AnyObject] {
                            self.arraySurvey.append(SurveyModel(JSON: object)!)
                            self.tableView.reloadData()
                            return
                        }
                    }
                    if let array = (((data as? [String: AnyObject])?["Root"] as? [String:AnyObject])?["STP_PAT_SATISFACTION_MASTER"] as? [String:AnyObject])?["STP_PAT_SATISFACTION_MASTER_ROW"] as? [[String: AnyObject]] {
                        for item in array {
                            self.arraySurvey.append(SurveyModel(JSON: item)!)
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

import ObjectMapper

struct SurveyModel: Mappable {
    var TRANSSERIAL : String = ""
    var TRANSDATE : String = ""
    var VISIT_ID : String = ""
    var USER_ID : String = ""
    var LASTMODEDATE : String = ""
    var NAME_AR : String = ""
    var NAME_EN : String = ""
    var DOCTOR_NAME_EN: String = ""
    var DOCTOR_NAME_AR: String = ""
    var CLASSNAME: String?
    var CLASSNAME_EN: String = ""
    var PLACE_AR: String = ""
    var PLACE_EN: String = ""
    var VISIT_START_DATE: String = ""
    var HOSP_EN_NAME: String = ""
    var HOSP_AR_NAME: String = ""
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        HOSP_EN_NAME <- map["HOSP_EN_NAME"]
        HOSP_AR_NAME <- map["HOSP_AR_NAME"]
        VISIT_START_DATE <- map["VISIT_START_DATE"]
        PLACE_AR <- map["PLACE_AR"]
        PLACE_EN <- map["PLACE_EN"]
        CLASSNAME <- map["CLASSNAME"]
        CLASSNAME_EN <- map["CLASSNAME_EN"]
        DOCTOR_NAME_EN <- map["DOCTOR_NAME_EN"]
        DOCTOR_NAME_AR <- map["DOCTOR_NAME_AR"]
        TRANSSERIAL <- map["TRANSSERIAL"]
        TRANSDATE <- map["TRANSDATE"]
        VISIT_ID <- map["VISIT_ID"]
        USER_ID <- map["USER_ID"]
        LASTMODEDATE <- map["LASTMODEDATE"]
        NAME_AR <- map["NAME_AR"]
        NAME_EN <- map["NAME_EN"]
    }
}
