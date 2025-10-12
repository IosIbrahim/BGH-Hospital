//
//  PatientReportDTO.swift
//  CareMate
//
//  Created by Khabeer on 2/1/21.
//  Copyright © 2021 khabeer Group. All rights reserved.
//


import Foundation
import ObjectMapper

struct PatientReportDTO : Mappable {
    var ACTION_NAME_AR : String = ""
    var STATUS_NAME_EN : String = ""
    var ACTION_SER : String = ""
    var COMPLETEPATNAME_EN : String = ""
    var DATE_DELETE : String = ""
    var DATE_UPDATE : String = ""
    var DESC_AR : String = ""
    var DESC_EN : String = ""
    var EMP_AR_DATA : String = ""
    var EMP_EN_DATA : String = ""
    var HOSPID : String = ""
    var LASTMODDATE : String = ""
    var PATIENTID : String = ""
    var PLACE_NAME_AR : String = ""
    var PLACE_NAME_EN : String = ""
    var REMARKS : String = ""
    var REPORT_STATUS : String = ""
    var REP_TYPE : String = ""
    var SER : String = ""
    var TEMP_CODE : String = ""
    var UPDATE_USER_AR : String = ""
    var UPDATE_USER_EN : String = ""
    var USERID : String = ""
    var USER_DELETE : String = ""
    var USER_UPDATE : String = ""
    var VISITID : String = ""
    var VISIT_DOC_NAME_AR: String = ""
    var VISIT_DOC_NAME_EN: String = ""

    var VISIT_START_DATE: String = ""
    var VISIT_TYPE_AR: String = ""
    var VISIT_TYPE_EN: String = ""
    var BRANCH_NAME_AR: String = ""
    var BRANCH_NAME_EN: String = ""
    var SPECIALITY_NAME_AR: String = ""
    var SPECIALITY_NAME_EN: String = ""

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        SPECIALITY_NAME_AR <- map["SPECIALITY_NAME_AR"]
        SPECIALITY_NAME_EN <- map["SPECIALITY_NAME_EN"]
        BRANCH_NAME_AR <- map["BRANCH_NAME_AR"]
        BRANCH_NAME_EN <- map["BRANCH_NAME_EN"]
        VISIT_TYPE_AR <- map["VISIT_TYPE_AR"]
        VISIT_TYPE_EN <- map["VISIT_TYPE_EN"]
        VISIT_START_DATE <- map["VISIT_START_DATE"]

        VISIT_DOC_NAME_AR <- map["VISIT_DOC_NAME_AR"]
        VISIT_DOC_NAME_EN <- map["VISIT_DOC_NAME_EN"]
        ACTION_NAME_AR <- map["ACTION_NAME_AR"]
        STATUS_NAME_EN <- map["STATUS_NAME_EN"]
        ACTION_SER <- map["ACTION_SER"]
        COMPLETEPATNAME_EN <- map["COMPLETEPATNAME_EN"]
        DATE_DELETE <- map["DATE_DELETE"]
        DATE_UPDATE <- map["DATE_UPDATE"]
        DESC_AR <- map["DESC_AR"]
        DESC_EN <- map["DESC_EN"]
        EMP_AR_DATA <- map["EMP_AR_DATA"]
        EMP_EN_DATA <- map["EMP_EN_DATA"]
        HOSPID <- map["HOSPID"]
        LASTMODDATE <- map["LASTMODDATE"]
        PATIENTID <- map["PATIENTID"]
        PLACE_NAME_AR <- map["PLACE_NAME_AR"]
        PLACE_NAME_EN <- map["PLACE_NAME_EN"]
        REMARKS <- map["REMARKS"]
        REPORT_STATUS <- map["REPORT_STATUS"]
        REP_TYPE <- map["REP_TYPE"]
        SER <- map["SER"]
        TEMP_CODE <- map["TEMP_CODE"]
        UPDATE_USER_AR <- map["UPDATE_USER_AR"]
        UPDATE_USER_EN <- map["UPDATE_USER_EN"]
        USERID <- map["USERID"]
        USER_DELETE <- map["USER_DELETE"]
        USER_UPDATE <- map["USER_UPDATE"]
        VISITID <- map["VISITID"]
        
    }
    
}



struct sickLeaveDTO : Mappable {
    var STATUS_NAME_AR : String = ""
    var STATUS_NAME_EN : String = ""
    var DUITY_WORKING_HOURS : String = ""
    var VISIT_ID : String = ""
    var COMPLETEPATNAME_AR : String = ""
    var COMPLETEPATNAME_EN : String = ""
    var PLACE_NAME_AR : String = ""
    var PLACE_NAME_EN : String = ""
    var EMP_NAME_AR : String = ""
    var EMP_NAME_EN : String = ""
    var SER : String = ""
    var SPECIALITY_NAME_AR: String = ""
    var SPECIALITY_NAME_EN: String = ""
    
    var SICK_LEAVE_DAYS : String = ""
    var SICK_LEAVE_START: String = ""
    
    
    
    var VISIT_START_DATE: String = ""
//    var EMP_NAME_AR: String = ""
//    var EMP_NAME_EN: String = ""
//    var SPECIALITY_NAME_AR: String = ""
//    var SPECIALITY_NAME_EN: String = ""
    var FULL_LOCATION_AR: String = ""
    var FULL_LOCATION_EN: String = ""
    var HOSP_NAME_AR: String = ""
    var HOSP_NAME_EN: String = ""
    var VISIT_TYPE_AR: String = ""
    var VISIT_TYPE_EN: String = ""
    var SERIAL_BLOB: String = ""
    
    

    var PATIENT_ID : String = ""

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        SERIAL_BLOB <- map["SERIAL_BLOB"]
        FULL_LOCATION_AR <- map["FULL_LOCATION_AR"]
        FULL_LOCATION_EN <- map["FULL_LOCATION_EN"]
        HOSP_NAME_AR <- map["HOSP_NAME_AR"]
        HOSP_NAME_EN <- map["HOSP_NAME_EN"]
        VISIT_TYPE_AR <- map["VISIT_TYPE_AR"]
        VISIT_TYPE_EN <- map["VISIT_TYPE_EN"]
        VISIT_START_DATE <- map["VISIT_START_DATE"]
        SICK_LEAVE_START <- map["SICK_LEAVE_START"]
        SPECIALITY_NAME_EN <- map["SPECIALITY_NAME_EN"]
        SPECIALITY_NAME_AR <- map["SPECIALITY_NAME_AR"]
        STATUS_NAME_AR <- map["STATUS_NAME_AR"]
        STATUS_NAME_EN <- map["STATUS_NAME_EN"]
        DUITY_WORKING_HOURS <- map["DUITY_WORKING_HOURS"]
        VISIT_ID <- map["VISIT_ID"]
        COMPLETEPATNAME_AR <- map["COMPLETEPATNAME_AR"]
        COMPLETEPATNAME_EN <- map["COMPLETEPATNAME_EN"]
        PLACE_NAME_AR <- map["PLACE_NAME_AR"]
        PLACE_NAME_EN <- map["PLACE_NAME_EN"]
        EMP_NAME_AR <- map["EMP_NAME_AR"]
        EMP_NAME_EN <- map["EMP_NAME_EN"]
        SER <- map["SER"]

        PATIENT_ID <- map["PATIENT_ID"]

        SICK_LEAVE_DAYS <- map["SICK_LEAVE_DAYS"]

    }
    
}


struct sickLeavePrintDTO : Mappable {
    var patientid, patNameAr, patNameEn, dateofbirth: String?
  
    var dateofbirthHijrah: String?
    var DUITY_DURATION: String?

    
      var visitID: String?
    var visitStartDate, visitStartDateHijrah, visitEndDate, visitEndDateHijrah: String?
    var gendercode, gendernameAr, gendernameEn: String?
    var empID: String?
    var empDataAr, empDataEn: String?
    var treatingEmpID: String?
    var treatingEmpDataAr, treatingEmpDataEn: String?

    var natCode: String?
    var natNameAr, natNameEn: String?
    var approvalOfSickLeave, cannotBeTreated, permanentOrPartial, others: String?
    var ser, hospID: String?
      var patientID: String?
    var visitId1, checkIdentity, sickLeaveDays: String?
    var sickLeaveStart, sickLeaveEnd: String?
    var folloupBeforeEnd, referToMedicalCommittee: String?
    var NATIONALITY_LOCAL_FLAG: Double?
    var INPAT_FLAG: Double?
    var OUTPAT_FLAG: Double?
    var SICK_LEAVE_REASON: String?

    
    
    
    
    var patSsn: String?

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        patientid <- map["PATIENTID"]
        patNameAr <- map["PAT_NAME_AR"]
        patNameEn <- map["PAT_NAME_EN"]
        dateofbirth <- map["DATEOFBIRTH"]
        dateofbirthHijrah <- map["DATEOFBIRTH_HIJRAH"]
        visitStartDate <- map["VISIT_START_DATE"]
        visitStartDateHijrah <- map["VISIT_START_DATE_HIJRAH"]
        visitStartDate <- map["VISIT_START_DATE"]
        visitEndDate <- map["VISIT_END_DATE"]
        visitEndDateHijrah <- map["VISIT_END_DATE_HIJRAH"]
        gendercode <- map["GENDERCODE"]

        gendernameAr <- map["GENDERNAME_AR"]
        gendernameEn <- map["GENDERNAME_EN"]
        empID <- map["EMP_ID"]
        empDataAr <- map["EMP_DATA_AR"]
        empDataEn <- map["EMP_DATA_EN"]
        
        treatingEmpID <- map["TREATING_EMP_ID"]

        treatingEmpDataAr <- map["TREATING_EMP_DATA_AR"]

        treatingEmpDataEn <- map["TREATING_EMP_DATA_EN"]
        natCode <- map["NAT_CODE"]

        natNameAr <- map["NAT_NAME_AR"]
        approvalOfSickLeave <- map["APPROVAL_OF_SICK_LEAVE"]
        cannotBeTreated <- map["CANNOT_BE_TREATED"]
        permanentOrPartial <- map["PERMANENT_OR_PARTIAL"]
        others <- map["OTHERS"]

        ser <- map["SER"]
        hospID <- map["HOSP_ID"]
        patientid <- map["PATIENT_ID"]
        visitId1 <- map["VISIT_ID1"]

        checkIdentity <- map["CHECK_IDENTITY"]
        sickLeaveDays <- map["SICK_LEAVE_DAYS"]
        sickLeaveStart <- map["SICK_LEAVE_START"]
        sickLeaveEnd <- map["SICK_LEAVE_END"]
        folloupBeforeEnd <- map["FOLLOUP_BEFORE_END"]
        referToMedicalCommittee <- map["REFER_TO_MEDICAL_COMMITTEE"]
        referToMedicalCommittee <- map["REFER_TO_MEDICAL_COMMITTEE"]
        patSsn <- map["PAT_SSN"]

        DUITY_DURATION <- map["DUITY_DURATION"]

        NATIONALITY_LOCAL_FLAG <- map["NATIONALITY_LOCAL_FLAG"]

        INPAT_FLAG <- map["INPAT_FLAG"]

        OUTPAT_FLAG <- map["OUTPAT_FLAG"]
        SICK_LEAVE_REASON <- map["SICK_LEAVE_REASON"]

        
        
    }
    
}


struct operationDTO : Mappable {
    var SER : String = ""
    var OPER_TYPE : String = ""
    var SERVICE_ID : String = ""
    var SRV_AR_NAME : String = ""
    var SRV_EN_NAME : String = ""

    var BRANCH_NAME_AR: String = ""
    var BRANCH_NAME_EN: String = ""
    var EXPECTEDDONEDATE : String = ""
    var OPER_DURATION_DESC_AR : String = ""
    var OPER_DURATION_DESC_EN : String = ""
    var SURGEON_NAME_AR : String = ""
    var SURGEON_NAME_EN : String = ""
    var ANTHESIA_NAME_AR : String = ""

    var ANTHESIA_NAME_EN : String = ""
    var LAST_ROW : String = ""
    var DOC_NAME_EN: String = ""
    var DOC_NAME_AR: String = ""
    var SERV_STATUS_AR: String = ""
    var SERV_STATUS_EN: String = ""
    var OPERATION_INSTRUCTIONS: OperationInstructionParentModel?
    var VISIT_ID: String = ""
    
    init?(map: Map) {
        
    }
    
    
    mutating func mapping(map: Map) {
        VISIT_ID <- map["VISIT_ID"]
        BRANCH_NAME_AR <- map["BRANCH_NAME_AR"]
        BRANCH_NAME_EN <- map["BRANCH_NAME_EN"]
        SERV_STATUS_AR <- map["SERV_STATUS_AR"]
        SERV_STATUS_EN <- map["SERV_STATUS_EN"]
        DOC_NAME_EN <- map["DOC_NAME_EN"]
        DOC_NAME_AR <- map["DOC_NAME_AR"]
        SER <- map["SER"]
        OPER_TYPE <- map["OPER_TYPE"]
        SERVICE_ID <- map["SERVICE_ID"]
        SRV_AR_NAME <- map["SRV_AR_NAME"]
        SRV_EN_NAME <- map["SRV_EN_NAME"]
        EXPECTEDDONEDATE <- map["EXPECTEDDONEDATE"]
        OPER_DURATION_DESC_AR <- map["OPER_DURATION_DESC_AR"]
        OPER_DURATION_DESC_EN <- map["OPER_DURATION_DESC_EN"]
        SURGEON_NAME_AR <- map["SURGEON_NAME_AR"]
        SURGEON_NAME_EN <- map["SURGEON_NAME_EN"]
        ANTHESIA_NAME_AR <- map["ANTHESIA_NAME_AR"]

        ANTHESIA_NAME_EN <- map["ANTHESIA_NAME_EN"]
        LAST_ROW <- map["LAST_ROW"]
        OPERATION_INSTRUCTIONS <- map["OPERATION_INSTRUCTIONS"]

        
        
    }
    
}


struct OperationInstructionParentModel: Mappable {
    
    var OPERATION_INSTRUCTIONS_ROW = [OperationInstructionModel]()
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        OPERATION_INSTRUCTIONS_ROW <- map["OPERATION_INSTRUCTIONS_ROW"]
    }
}

struct OperationInstructionModel: Mappable {
    
    var DESC_AR: String = ""
    var DESC_EN: String = ""
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        DESC_AR <- map["DESC_AR"]
        DESC_EN <- map["DESC_EN"]
    }
}

struct labStatuesModel : Mappable {
    var NAME_AR : String = ""
    var NAME_EN : String = ""
    var ID : String = ""
    
    init(ID: String, NAME_AR: String, NAME_EN: String) {
        self.ID = ID
        self.NAME_AR = NAME_AR
        self.NAME_EN = NAME_EN
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        NAME_AR <- map["NAME_AR"]
        NAME_EN <- map["NAME_EN"]
        ID <- map["ID"]
   

        
        
    }
    
}
struct visitDTO : Mappable {
    var CLASSNAME_EN : String = ""
    var CLASSNAME_AR : String = ""
    var CLINIC_NAME_EN : String = ""
    var CLINIC_NAME_AR : String = ""
    var EMP_EN_DATA : String = ""
    var EMP_AR_DATA : String = ""
    var NAME_EN : String = ""
    var NAME_AR : String = ""
    var VISIT_START_DATE : String = ""
    var ID : String = ""
    var VISIT_ID : String = ""

    var SPECIALITY_NAME_AR : String = ""
    var SPECIALITY_NAME_EN : String = ""
    var CLASSNAME: String = ""
    var EVAL_STATUS: String = ""
    var PAT_SURVEY_LINK = ""
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        EVAL_STATUS <- map["EVAL_STATUS"]
        CLASSNAME <- map["CLASSNAME"]
        CLASSNAME_AR <- map["CLASSNAME_AR"]
        CLASSNAME_EN <- map["CLASSNAME_EN"]
        CLINIC_NAME_EN <- map["CLINIC_NAME_EN"]
        CLINIC_NAME_AR <- map["CLINIC_NAME_AR"]
        EMP_EN_DATA <- map["EMP_EN_DATA"]
        EMP_AR_DATA <- map["EMP_AR_DATA"]
        NAME_EN <- map["NAME_EN"]
        NAME_AR <- map["NAME_AR"]
        VISIT_START_DATE <- map["VISIT_START_DATE"]
        ID <- map["ID"]
        VISIT_ID <- map["VISIT_ID"]
        SPECIALITY_NAME_AR <- map["SPECIALITY_NAME_AR"]
        SPECIALITY_NAME_EN <- map["SPECIALITY_NAME_EN"]
        PAT_SURVEY_LINK <- map["PAT_SURVEY_LINK"]

        
    
    }
    
}
struct notifcationDTO : Mappable {
    var ALERT_BODY : String = ""
    var ALERT_HEADER : String = ""
    var ALERT_SERIAL : String = ""
    var PATIENTID : String = ""
    var ALERT_ID: String = ""
    var TRANSDATE : String = ""

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        ALERT_BODY <- map["ALERT_BODY"]
        ALERT_HEADER <- map["ALERT_HEADER"]
        ALERT_SERIAL <- map["ALERT_SERIAL"]
        ALERT_ID <- map["ALERT_ID"]
        PATIENTID <- map["PATIENTID"]
        TRANSDATE <- map["TRANSDATE"]
       
   
        
        
    }
    
}


struct REPORTSDTO : Mappable {
    var NAME_AR : String = ""
    var NAME_EN : String = ""
    var ID : String = ""
    var REP_TYPE : String = ""

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        NAME_AR <- map["NAME_AR"]
        NAME_EN <- map["NAME_EN"]
        ID <- map["ID"]
        REP_TYPE <- map["REP_TYPE"]

        
        
        
    }
    
}
struct familtyDTO : Mappable {
    var CL_F_NAME : String = ""
    var COMPLETEPATNAME_EN : String = ""
    var PARENT_PAT_ID : String = ""
    var DATEOFBIRTH : String = ""
    var wifeSon : String = ""
    var PATIENTID: String = ""
    var COMPLETEPATNAME: String = ""
    var RELATION_NAME_AR: String = ""
    var RELATION_NAME_EN: String = ""
    var GENDERCODE: String = ""
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {

        CL_F_NAME <- map["CL_F_NAME"]
        COMPLETEPATNAME_EN <- map["COMPLETEPATNAME_EN"]
        PARENT_PAT_ID <- map["PARENT_PAT_ID"]
        DATEOFBIRTH <- map["DATEOFBIRTH"]
        PATIENTID <- map["PATIENTID"]
        COMPLETEPATNAME <- map["COMPLETEPATNAME"]
        RELATION_NAME_AR <- map["RELATION_NAME_AR"]
        RELATION_NAME_EN <- map["RELATION_NAME_EN"]
        GENDERCODE <- map["GENDERCODE"]

    }
    
}



struct ComplainsDTO : Mappable {
    var PRIORITY_NAME_AR : String = ""
    var PRIORITY_NAME_EN : String = ""
    var COMPLAIN_SERIAL : String = ""
    var CLASSNAME : String = ""
    var CLASSNAME_EN : String = ""
    var VISIT_ID : String = ""
    var COMPLAINTS_CAT_NAME_EN : String = ""
    var COMPLAINTS_CAT_NAME_AR : String = ""

    var COMPLAINTS_TYPE_NAME_EN : String = ""

    var COMPLAINTS_TYPE_NAME_AR : String = ""
    var COMPLAIN_TRANSDATE: String = ""
    var COMPLAINT_STATUS_NAME_AR: String = ""
    var COMPLAINT_STATUS_NAME_EN: String = ""
    var DOC_NAME_AR: String = ""
    var DOC_NAME_EN: String = ""
    var VISIT_START_DATE: String = ""
    var PLACE_NAME_AR: String = ""
    var PLACE_NAME_EN: String = ""
    var HOSP_EN_NAME: String = ""
    var HOSP_AR_NAME: String = ""
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        HOSP_EN_NAME <- map["HOSP_EN_NAME"]
        HOSP_AR_NAME <- map["HOSP_AR_NAME"]
        PLACE_NAME_AR <- map["PLACE_NAME_AR"]
        PLACE_NAME_EN <- map["PLACE_NAME_EN"]
        VISIT_START_DATE <- map["VISIT_START_DATE"]
        DOC_NAME_AR <- map["DOC_NAME_AR"]
        DOC_NAME_EN <- map["DOC_NAME_EN"]
        COMPLAINT_STATUS_NAME_AR <- map["COMPLAINT_STATUS_NAME_AR"]
        COMPLAINT_STATUS_NAME_EN <- map["COMPLAINT_STATUS_NAME_EN"]
        COMPLAIN_TRANSDATE <- map["COMPLAIN_TRANSDATE"]
        PRIORITY_NAME_AR <- map["PRIORITY_NAME_AR"]
        PRIORITY_NAME_EN <- map["PRIORITY_NAME_EN"]
        COMPLAIN_SERIAL <- map["COMPLAIN_SERIAL"]
        CLASSNAME_EN <- map["CLASSNAME_EN"]
        CLASSNAME <- map["CLASSNAME"]
        VISIT_ID <- map["VISIT_ID"]
        COMPLAINTS_CAT_NAME_EN <- map["COMPLAINTS_CAT_NAME_EN"]
        COMPLAINTS_CAT_NAME_AR <- map["COMPLAINTS_CAT_NAME_AR"]
        
        COMPLAINTS_TYPE_NAME_EN <- map["COMPLAINTS_TYPE_NAME_EN"]
        COMPLAINTS_TYPE_NAME_AR <- map["COMPLAINTS_TYPE_NAME_AR"]

    }
    
}


struct saveReportRequest {
    var flParms: FLParms?
    var flReportPrintRequest: [FLReportPrintRequest]?

  
}

// MARK: - FLParms
struct FLParms {
    var userID, computerName, branchID: String?

    
   
}

// MARK: - FLReportPrintRequest
class FLReportPrintRequest {
    var reportTemplateCode, repType, visitIDForReport, notes: String?
    var needSign, bufferStatus, hospID: String?
    var patientid, visitID: String?

 
}
