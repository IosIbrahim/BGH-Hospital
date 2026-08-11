//
//  SessionModel.swift
//  CareMate
//
//  Created by Ibrahim on 24/05/2026.
//  Copyright © 2026 khabeer Group. All rights reserved.
//

struct SessionResponseModel:Codable {
    let services:ServiceSessionModel?
    enum CodingKeys: String, CodingKey {
        case services = "PAT_SERVICES"
    }
}

struct SessionSingleResponseModel:Codable {
    let services:ServiceSingleSessionModel?
    enum CodingKeys: String, CodingKey {
        case services = "PAT_SERVICES"
    }
}

struct ServiceSingleSessionModel:Codable{
    let rows: ServiceSessionRowModel?
    enum CodingKeys:String, CodingKey {
        case rows = "PAT_SERVICES_ROW"
    }
}

struct ServiceSessionModel:Codable{
    let rows: [ServiceSessionRowModel]?
    enum CodingKeys:String, CodingKey {
        case rows = "PAT_SERVICES_ROW"
    }
}

struct ServiceSessionRowModel:Codable{
    let patientId: String?
    let patnameEn:String?
    let patnameAr:String?
    let visitId:String?
    let doctorId:String?
    let doctorNameAr:String?
    let doctorNameEn:String?
    
    let doctorSpecialId:String?
    let doctorSpecialAr:String?
    let doctorSpecialEn:String?
    
    let hospitalNameAr:String?
    let hospitalNameEn:String?
    let startDate:String?
    let sessions:SessionsModel?
    var isSelected:Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case patientId = "PATIENTID"
        case patnameEn = "PAT_NAME_EN"
        case patnameAr = "PAT_NAME_AR"
        case visitId = "VISIT_ID"
        case doctorId = "REQ_DOC_ID"
        case doctorNameAr = "REQ_DOC_NAME_AR"
        case doctorNameEn = "REQ_DOC_NAME_EN"
        case doctorSpecialId = "REQ_DOC_SPECIAL_ID"
        case doctorSpecialAr = "REQ_DOC_SPECIAL_AR"
        case doctorSpecialEn = "REQ_DOC_SPECIAL_EN"
        case hospitalNameAr = "HOSP_NAME_AR"
        case hospitalNameEn = "HOSP_NAME_EN"
        case startDate = "VISIT_START_DATE"
        case sessions = "PHYSIO_SESSIONS"
    }
    
    func getPatientName() -> String? {
        return UserManager.isArabic ? patnameAr:patnameEn
    }
    func getDoctorName() -> String? {
        return UserManager.isArabic ? doctorNameAr:doctorNameEn
    }
    func getDoctorSpecial() -> String? {
        return UserManager.isArabic ? doctorSpecialAr:doctorSpecialEn
    }
    func getHospital() -> String? {
        return UserManager.isArabic ? hospitalNameAr:hospitalNameEn
    }
}
struct SessionsModel:Codable{
    let rows: [SessionRowModel]?
    enum CodingKeys: String, CodingKey {
        case rows = "PHYSIO_SESSIONS_ROW"
    }
    
    func getFiltered(_ filter:SessionFilter)-> [SessionRowModel] {
        var filtered = [SessionRowModel]()
        for item in rows ?? [] {
            if filter == .schedule {
//                if item.canSchedule == "1"{
//                    filtered.append(item)
//                }
                if item.canReSchedule == "1"{
                    filtered.append(item)
                }
            }else if filter == .reschedule {
//                if item.canReSchedule == "1"{
//                    filtered.append(item)
//                }
                if item.canSchedule == "1"{
                    filtered.append(item)
                }
            }
        }
        return filtered
    }
}

struct SessionRowModel:Codable{
    let ser: String?
    let serviceID:String?
    let serviceNameAr:String?
    let serviceNameEn:String?
    let doneDate:String?
    
    let expectedDoneDate:String?
    let doctorId:String?
    let doctorNameAr:String?
    let doctorNameEn:String?
    let doctorSpecialId:String?
    
    let doctorSpecialAr:String?
    let doctorSpecialEn:String?
    let canSchedule:String?
    let canReSchedule:String?
    let waitApprove:String?
    
    let status:String?
    let statusAr:String?
    let statusEn:String?
    
    func getService() -> String? {
        return UserManager.isArabic ? serviceNameAr:serviceNameEn
    }
    
    func getDoctorName() -> String? {
        return UserManager.isArabic ? doctorNameAr:doctorNameEn
    }
    
    func getDoctorSpecial() -> String? {
        return UserManager.isArabic ? doctorSpecialAr:doctorSpecialEn
    }
    
    func getStatus() -> String? {
        return UserManager.isArabic ? statusAr:statusEn
    }
    
    func getStatusColor() -> UIColor? {
        if canSchedule == "1" {
            return UIColor.fromHex(hex: ConstantsData.physical_greenB, alpha: 1.0)
        }else if canReSchedule == "1"{
            return UIColor.fromHex(hex: ConstantsData.physical_orange, alpha: 1.0)
        }else if waitApprove == "1" {
            return UIColor.fromHex(hex: ConstantsData.physical_blue, alpha: 1.0)
        }
        return UIColor.fromHex(hex: ConstantsData.physical_green, alpha: 1.0)
    }
    
    func getStatusTitle() -> String? {
        if canSchedule == "1" {
            return UserManager.isArabic ? "تحتاج جدولة":"Need Schedule"
        }else if canReSchedule == "1"{
            return UserManager.isArabic ? "مجدولة":"Scheduled"
        }else if waitApprove == "1" {
            return UserManager.isArabic ? "قيد الانتظار":"Pending"
        }
        return UserManager.isArabic ? "تم الموافقة":"Approved"
    }
    
    func getStatusAction() -> String? {
        if canSchedule == "1" {
            return UserManager.isArabic ? "احجز الآن":"Reserve Now"
        }else if canReSchedule == "1"{
            return UserManager.isArabic ? "تعديل الحجز":"Edit Reservation"
        }else if waitApprove == "1" {
            return UserManager.isArabic ? "":""
        }
        return UserManager.isArabic ? "":""
    }
    
    func isWaitingApporve() -> Bool {
      return waitApprove == "1"
    }
    
    func isCanSchedule() -> Bool {
      return canSchedule == "1"
    }
    func getRowHieght() -> Int {
        if canSchedule == "1" {
            return 130
        }else if canReSchedule == "1"{
            return 270
        }else if waitApprove == "1" {
            return 120
        }
        return 270
    }
    
    enum CodingKeys: String, CodingKey {
        case ser = "SER"
        case serviceID = "SERVICE_ID"
        case serviceNameAr = "SRV_NAME_AR"
        case serviceNameEn = "SRV_NAME_EN"
        case doneDate = "DONE_DATE"
        
        case expectedDoneDate = "EXPECTEDDONEDATE"
        case doctorId = "DONE_DOCID"
        case doctorNameAr = "DONE_DOC_AR"
        case doctorNameEn = "DONE_DOC_EN"
        case doctorSpecialId = "DONE_DOC_SPECIAL_ID"
        
        case doctorSpecialAr = "DONE_DOC_SPECIAL_AR"
        case doctorSpecialEn = "DONE_DOC_SPECIAL_EN"
        case canSchedule = "CAN_SCHEDUAL"
        case canReSchedule = "CAN_RESCHEDUAL"
        case waitApprove = "WAITE_APPROVAL"
        case status = "STATUS"
        case statusAr = "STATUS_AR"
        case statusEn = "STATUS_EN"

    }
}

