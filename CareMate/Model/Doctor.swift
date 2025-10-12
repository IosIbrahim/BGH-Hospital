//
//  Doctors.swift
//  CareMate
//
//  Created by Eng Nour Hegazy on 11/18/17.
//  Copyright © 2017 khabeer Group. All rights reserved.
//

import Foundation
import Stuff
import SwiftyJSON
import MOLH

struct Doctor: Decodable {
    var id: String?
    var englishName: String?
    var englishNameAR: String?
    var gender: String?
    var doctorCategory: String?
    var doctorCategoryAR: String?
    var clinicName: String?
    var clinicNameAR: String?
    var nationality: String?
    var nationalityAR: String?
    var clinicId: String?
    var qualification: String?
    var qualificationAR: String?
    var FIRST_SLOT_TIME: String?
    var DOCTOR_PIC:String?
    var HREMPLOYEELANGUAGE_EN:String?
    var HREMPLOYEELANGUAGE_AR:String?
    var CLINIC_PHONE_NUMBER: String?
    var DOCCATNAME:String?
    var NO_RESERVATION_VIEW_ONLY_TEL: String?
    var CLINIC_LETTER: String?
    var CLINIC_LETTER_EN: String?
    var DOC_ID: String?
    var DOC_NAME_AR: String?
    var DOC_NAME_EN: String?
    var SPECIAL_SPEC_ID: String?
    var SPECIALITY_AR: String?
    var SPECIALITY_EN: String?
    var PAGES_COUNT: String?
    var RNUM: String?
    var DOCTOR_CLINICS: DoctorClinicParent?
    var GENDERCODE: String?
    var HIDE_SCHEDULE_MOBILE_APP: String?
    var CONTACT_TEL1: String?
    var CONTACT_TEL2: String?
    var CLINIC_LOCATION_AR: String?
    var CLINIC_LOCATION_EN: String?
    
    enum CodingKeys: String, CodingKey {
        case CLINIC_LOCATION_AR = "CLINIC_LOCATION_AR"
        case CLINIC_LOCATION_EN = "CLINIC_LOCATION_EN"
        case DOC_ID = "DOC_ID"
        case DOC_NAME_AR = "DOC_NAME_AR"
        case DOC_NAME_EN = "DOC_NAME_EN"
        case SPECIAL_SPEC_ID = "SPECIAL_SPEC_ID"
        case SPECIALITY_AR = "SPECIALITY_AR"
        case SPECIALITY_EN = "SPECIALITY_EN"
        case PAGES_COUNT = "PAGES_COUNT"
        case RNUM = "RNUM"
        case DOCTOR_CLINICS = "DOCTOR_CLINICS"
        case id = "EMP_ID"
        case englishName = "EMP_NAME_EN"
        case englishNameAR = "EMP_NAME_AR"
        case gender = "EMP_GENDUR"
        case doctorCategory = "DOCCATENNAME"
        case doctorCategoryAR = "DOCCATARNAME"
        case clinicName = "PLACE_EN_NAME"
        case clinicNameAR = "PLACE_AR_NAME"
        case nationality = "NAT_NAME_EN"
        case nationalityAR = "NAT_NAME_AR"
        case clinicId = "PLACE_ID1"
        case qualification = "EMP_QUALIFICATION_DESC_EN"
        case qualificationAR = "EMP_QUALIFICATION_DESC_AR"
        case FIRST_SLOT_TIME = "FIRST_SLOT_TIME"
        case DOCTOR_PIC = "DOCTOR_PIC"
        case HREMPLOYEELANGUAGE_EN = "HREMPLOYEELANGUAGE_EN"
        case HREMPLOYEELANGUAGE_AR = "HREMPLOYEELANGUAGE_AR"
        case DOCCATNAME = "DOCCATNAME"
        case NO_RESERVATION_VIEW_ONLY_TEL = "NO_RESERVATION_VIEW_ONLY_TEL"
        case CLINIC_PHONE_NUMBER = "CLINIC_PHONE_NUMBER"
        case CLINIC_LETTER = "CLINIC_LETTER"
        case CLINIC_LETTER_EN = "CLINIC_LETTER_EN"
        case GENDERCODE = "GENDERCODE"
        case HIDE_SCHEDULE_MOBILE_APP = "HIDE_SCHEDULE_MOBILE_APP"
        case CONTACT_TEL1 = "CONTACT_TEL1"
        case CONTACT_TEL2 = "CONTACT_TEL2"
    }
}

struct DoctorClinicParent: Codable {
    
    var DOCTOR_CLINICS_ROW: [DoctorClinic]?
    
    enum CodingKeys: String, CodingKey {
        case DOCTOR_CLINICS_ROW = "DOCTOR_CLINICS_ROW"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        DOCTOR_CLINICS_ROW = []
        if let singleAlert = try? values.decode(DoctorClinic.self, forKey: CodingKeys.DOCTOR_CLINICS_ROW) {
            DOCTOR_CLINICS_ROW?.append(singleAlert)
        } else if let multiVenue = try? values.decode([DoctorClinic].self, forKey: CodingKeys.DOCTOR_CLINICS_ROW) {
            DOCTOR_CLINICS_ROW = multiVenue
        }
    }
}

struct DoctorClinic: Codable {
    
    let CLINIC_ID: String?
    let CLINIC_NAME_AR: String?
    let CLINIC_NAME_EN: String?
    let NO_RESERVATION_ONLINE_ONLY_TEL: String?
    var CLINIC_PHONE_NUMBER: String?
    var CLINIC_LETTER: String?
    var CLINIC_LETTER_EN: String?
    var HOSP_ID:String?
    
    func getName() -> String {
        MOLHLanguage.isArabic() ? CLINIC_NAME_AR ?? "" : CLINIC_NAME_EN ?? ""
    }
}

extension Doctor {
    static func getDoctors(withSpecialityId specialityId: String, andBranchId branchId: String, type: String,isload:Bool = true, completion: @escaping (([Doctor]?) -> Void)) {
        if isload {
            indicator.sharedInstance.show()
        }

        let urlString = "\(Constants.APIProvider.GetDoctors)SPEC_ID=\(specialityId)&BRANCH_ID=\(branchId)&BRANCH_TYPE=\(type)&PROCESS_ID=0&PROCESS_INFO_CODE=0&object_id=0"
    
        let url = URL(string: urlString)
        let parseURl = Constants.APIProvider.GetDoctors + Constants.getoAuthValue(url: url!, method: "GET")
        print(parseURl)
    
        URLSession.shared.dataTask(with: URL(string: parseURl)!) { data, response, error in
            indicator.sharedInstance.dismiss()

            guard let data = data else {
//        Utilities.showAlert(messageToDisplay:"Couldn't connect to server")
                DispatchQueue.main.async {completion(nil)}
                return
        }
      guard let json = String.init(data: data, encoding: .utf8), json.contains("DOCTOR_ROW") else {
//        Utilities.showAlert(messageToDisplay:"No doctors found")
        DispatchQueue.main.async {completion(nil)}
        return
      }
        
        print(json)
        let selectDoctor = try? Doctor(data: data, keyPath: "Root.DOCTOR.DOCTOR_ROW")
        if let selectDoctor = selectDoctor {
          DispatchQueue.main.async {completion([selectDoctor])}
        } else {
          let doctors = try? [Doctor](data: data, keyPath: "Root.DOCTOR.DOCTOR_ROW")

            print(doctors?.count)
          if let doctors = doctors {
              DispatchQueue.main.async {completion(doctors)}
          } else {
              DispatchQueue.main.async {completion(nil)}
          }
            
        }
      }.resume()
  }
    
    static func getSearchDoctors(url: String, completion: @escaping (([Doctor]?) -> Void)) {
        let url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print(url)
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {completion(nil)}
                return
            }
            guard let json = String.init(data: data, encoding: .utf8), json.contains("SEARCH_DOCTORS_ROW") else {
                DispatchQueue.main.async {completion(nil)}
                return
            }
            print(json)
            let selectDoctor = try? Doctor(data: data, keyPath: "Root.SEARCH_DOCTORS.SEARCH_DOCTORS_ROW")
            if let selectDoctor = selectDoctor {
                DispatchQueue.main.async {completion([selectDoctor])}
            } else {
                let doctors = try? [Doctor](data: data, keyPath: "Root.SEARCH_DOCTORS.SEARCH_DOCTORS_ROW")
                if let doctors = doctors {
                    DispatchQueue.main.async {completion(doctors)}
                } else {
                    DispatchQueue.main.async {completion(nil)}
                }
            }
        }.resume()
    }

}


import Foundation

// MARK: - Welcome
struct ServiceBigModel: Codable {
    let services: [Service]
}

// MARK: - Service
struct Service: Codable {
    let serviceID, serviceIDFollowup, defaultSrvs, clinicID: String?
    let docCatID: String?
    let dcafMarkerFlag, dcafMarkerColor, defaultSrvsFlag, examServ: String?
    let srvPrice: String?
    let resType, inpatFollowup, numberSlots, isFollowupService: String?
    let transferDiscExist, id, nameAr, nameEn: String?
    let serviceCode, servNameAr, servNameEn, displayNameAr: String?
    let displayNameEn: String?
    let needMachine, convReq: String?
    let resDate: String?
    let noRecursiceCheck: String?
    let mainService, filterColumn, selectedservices: String?

    enum CodingKeys: String, CodingKey {
        case serviceID = "SERVICE_ID"
        case serviceIDFollowup = "SERVICE_ID_FOLLOWUP"
        case defaultSrvs = "DEFAULT_SRVS"
        case clinicID = "CLINIC_ID"
        case docCatID = "DOC_CAT_ID"
        case dcafMarkerFlag = "DCAF_MARKER_FLAG"
        case dcafMarkerColor = "DCAF_MARKER_COLOR"
        case defaultSrvsFlag = "DEFAULT_SRVS_FLAG"
        case examServ = "EXAM_SERV"
        case srvPrice = "SRV_PRICE"
        case resType = "RES_TYPE"
        case inpatFollowup = "INPAT_FOLLOWUP"
        case numberSlots = "NUMBER_SLOTS"
        case isFollowupService = "IS_FOLLOWUP_SERVICE"
        case transferDiscExist = "TRANSFER_DISC_EXIST"
        case id = "ID"
        case nameAr = "NAME_AR"
        case nameEn = "NAME_EN"
        case serviceCode = "SERVICE_CODE"
        case servNameAr = "SERV_NAME_AR"
        case servNameEn = "SERV_NAME_EN"
        case displayNameAr = "DISPLAY_NAME_AR"
        case displayNameEn = "DISPLAY_NAME_EN"
        case needMachine = "NEED_MACHINE"
        case convReq = "CONV_REQ"
        case resDate = "RES_DATE"
        case noRecursiceCheck = "NO_RECURSICE_CHECK"
        case mainService = "MAIN_SERVICE"
        case filterColumn = "FILTER_COLUMN"
        case selectedservices = "SELECTEDSERVICES"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
