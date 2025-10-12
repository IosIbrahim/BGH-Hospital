//
//  LitsOfPatientLogedBySameMobileNumberViewController.swift
//  CareMate
//
//  Created by Khabber on 09/01/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//
enum listOfOtherScreenType {
    case fromLogin
    case fromRegister
    case fromretrive

}

import UIKit
import ObjectMapper
struct listOfTherPatient : Mappable {
    var COMPLETEPATNAME_AR : String = ""
    var COMPLETEPATNAME_EN : String = ""
    var PAT_TEL : String = ""
    var PAT_EMAIL : String = ""
    var PATIENTID : String = ""

    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        
        COMPLETEPATNAME_AR <- map["COMPLETEPATNAME_AR"]
        COMPLETEPATNAME_EN <- map["COMPLETEPATNAME_EN"]
        PAT_TEL <- map["PAT_TEL"]
        PAT_EMAIL <- map["PAT_EMAIL"]
        PATIENTID <- map["PATIENTID"]

    }
    
}

class LitsOfPatientLogedBySameMobileNumberViewController: BaseViewController {

    @IBOutlet weak var tableViewListOfOthers: UITableView!

    var listOfOthersPatient = [listOfTherPatient]()
    var selectedIndexsignICon = 0
    var vcType:listOfOtherScreenType?
    var delegate:fromChangePass?
    var primaryPhoneNumber = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
//        setupTabBar.instance.setuptabBar(vc: self)

    }
    init(listOfOthers: [listOfTherPatient],VcType:listOfOtherScreenType) {
        self.listOfOthersPatient = listOfOthers
        self.vcType = VcType
        super.init(nibName: "LitsOfPatientLogedBySameMobileNumberViewController", bundle: nil)
        initHeader(isNotifcation: false, isLanguage: false, title: UserManager.isArabic ? "قائمة المرضى" : "Patient List", hideBack: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
