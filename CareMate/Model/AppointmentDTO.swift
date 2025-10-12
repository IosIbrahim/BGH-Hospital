//
//  AppointmentDTO.swift
//  CareMate
//
//  Created by Yo7ia on 12/31/18.
//  Copyright © 2018 khabeer Group. All rights reserved.
//
import ObjectMapper
import Foundation
class AppointmentDTOReservation: Mappable {
    var sER : String = ""
    var eXPECTEDDONEDATE : String = ""
    var cLINIC_ID : String = ""
    var cLINIC_NAME_AR : String = ""
    var cLINIC_NAME_EN : String = ""
    var sTATUS_NAME_AR : String = ""
    var sTATUS_NAME_EN : String = ""
    
    var dOC_ID : String = ""
    var eMP_AR_DATA : String = ""
    var eMP_EN_DATA : String = ""
    var sPECIAL_SPEC_EN_NAME : String = ""
    var sPECIAL_SPEC_AR_NAME : String = ""
    var sHIFT_ID : String = ""
    var sCHED_SERIAL : String = ""
    var sPECIAL_SPEC_ID : String = ""
    var hOSP_ID : String = ""
    var hOSP_NAME_AR : String = ""
    var hOSP_NAME_EN : String = ""
    var  DOC_ID : String = ""
    var  QUE_SYS_SER : String = ""

    

    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        sER <- map["SER"]
        eXPECTEDDONEDATE <- map["EXPECTEDDONEDATE"]
        cLINIC_ID <- map["CLINIC_ID"]
        cLINIC_NAME_AR <- map["PLACE_NAME_AR"]
        cLINIC_NAME_EN <- map["PLACE_NAME_EN"]
        sTATUS_NAME_AR <- map["STATUS_NAME_AR"]
        sTATUS_NAME_EN <- map["STATUS_NAME_EN"]
        dOC_ID <- map["DOC_ID"]
        eMP_AR_DATA <- map["EMP_NAME_AR"]
        eMP_EN_DATA <- map["EMP_NAME_EN"]
        sPECIAL_SPEC_EN_NAME <- map["SPECIALITY_NAME_EN"]
        sPECIAL_SPEC_AR_NAME <- map["SPECIALITY_NAME_AR"]
        sHIFT_ID <- map["SHIFT_ID"]
        sCHED_SERIAL <- map["SCHED_SERIAL"]
//        sPECIAL_SPEC_ID <- map["SPECIAL_SPEC_ID"]
        hOSP_ID <- map["HOSP_ID"]
        hOSP_NAME_AR <- map["HOSP_AR_NAME"]
        hOSP_NAME_EN <- map["HOSP_EN_NAME"]
        DOC_ID <- map["DOC_ID"]
        QUE_SYS_SER <- map["QUEUE_SER"]

       

        

    }
    
}




class AppointmentDTO: Mappable {
    var sER : String = ""
    var eXPECTEDDONEDATE : String = ""
    var DATE_ENTER : String = ""

    
    
    var cLINIC_ID : String = ""
    var cLINIC_NAME_AR : String = ""
    var cLINIC_NAME_EN : String = ""
    var sTATUS_NAME_AR : String = ""
    var sTATUS_NAME_EN : String = ""
    
    var dOC_ID : String = ""
    var eMP_AR_DATA : String = ""
    var eMP_EN_DATA : String = ""
    var sPECIAL_SPEC_EN_NAME : String = ""
    var sPECIAL_SPEC_AR_NAME : String = ""
    var sHIFT_ID : String = ""
    var sCHED_SERIAL : String = ""
    var sPECIAL_SPEC_ID : String = ""
    var hOSP_ID : String = ""
    var hOSP_NAME_AR : String = ""
    var hOSP_NAME_EN : String = ""
    var  DOC_ID : String = ""
    var  QUE_SYS_SER : String = ""
    var  DOCTOR_PIC : String = ""
    var  EMP_GENDUR : String = "M"
    var COMPLETEPATNAME_AR: String = ""
    var COMPLETEPATNAME_EN: String = ""
    var PAT_TEL: String = ""
    var PAT_TEL_COUNTRY_CODE: String = ""
    var GENDER_NAME_AR: String = ""
    var GENDER_NAME_EN: String = ""
    var DATEOFBIRTH: String = ""
    var IDENT_TYPE_NAME_AR: String = ""
    var IDENT_TYPE_NAME_EN: String = ""
    var PAT_SSN: String = ""
    var EVAL_STATUS = ""
    var VISIT_ID = ""
    var CLINIC_LOCATION_AR = ""
    var CLINIC_LOCATION_EN = ""
    var DETECT_TYPE = "0"
    var CallFutureFlag = ""
//http://172.25.26.140/mobileApi/ImagesStore/058b7b95-4478-49af-d184-795d8be1fe4b/3f3589a9-1441-480e-bd40-29bfbb903147.jpg
    init(sER:String, eXPECTEDDONEDATE:String,cLINIC_ID:String,cLINIC_NAME_AR:String,cLINIC_NAME_EN:String,sTATUS_NAME_AR:String,sTATUS_NAME_EN:String,dOC_ID:String,eMP_AR_DATA:String,eMP_EN_DATA:String,sPECIAL_SPEC_EN_NAME:String,sPECIAL_SPEC_AR_NAME:String,sHIFT_ID:String,sCHED_SERIAL:String,sPECIAL_SPEC_ID:String,hOSP_ID:String,hOSP_NAME_AR:String,hOSP_NAME_EN:String,DOC_ID:String,DOCTOR_PIC:String,EMP_GENDUR:String,QUE_SYS_SER:String,DATE_ENTER:String,detectType:String,callFuture:String) {
           self.sER = sER
           self.eXPECTEDDONEDATE = eXPECTEDDONEDATE
           self.cLINIC_ID = cLINIC_ID
           self.cLINIC_NAME_AR = cLINIC_NAME_AR
          self.cLINIC_NAME_EN = cLINIC_NAME_EN
          self.sTATUS_NAME_AR = sTATUS_NAME_AR
          self.sTATUS_NAME_EN = sTATUS_NAME_EN
          self.dOC_ID = dOC_ID
        self.eMP_AR_DATA = eMP_AR_DATA
        self.eMP_EN_DATA = eMP_EN_DATA
        self.sPECIAL_SPEC_AR_NAME = sPECIAL_SPEC_AR_NAME
        self.sPECIAL_SPEC_EN_NAME = sPECIAL_SPEC_EN_NAME
        self.sHIFT_ID = sHIFT_ID
        self.sCHED_SERIAL = sCHED_SERIAL
        self.sPECIAL_SPEC_ID = sPECIAL_SPEC_ID
        self.hOSP_ID = hOSP_ID
        self.hOSP_NAME_AR = hOSP_NAME_AR
        self.hOSP_NAME_EN = hOSP_NAME_EN
        self.DOC_ID = DOC_ID
        self.QUE_SYS_SER = QUE_SYS_SER
        self.DOCTOR_PIC = DOCTOR_PIC
        self.EMP_GENDUR = EMP_GENDUR
        self.DATE_ENTER = EMP_GENDUR
        self.DETECT_TYPE = detectType
        self.CLINIC_LOCATION_AR = ""
        self.CLINIC_LOCATION_EN = ""
        self.CallFutureFlag = callFuture
        
       }

    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        CLINIC_LOCATION_AR <- map["CLINIC_LOCATION_AR"]
        CLINIC_LOCATION_EN <- map["CLINIC_LOCATION_EN"]
        VISIT_ID <- map["VISIT_ID"]
        EVAL_STATUS <- map["EVAL_STATUS"]
        IDENT_TYPE_NAME_AR <- map["IDENT_TYPE_NAME_AR"]
        IDENT_TYPE_NAME_EN <- map["IDENT_TYPE_NAME_EN"]
        PAT_SSN <- map["PAT_SSN"]
        DATEOFBIRTH <- map["DATEOFBIRTH"]
        GENDER_NAME_AR <- map["GENDER_NAME_AR"]
        GENDER_NAME_EN <- map["GENDER_NAME_EN"]
        PAT_TEL <- map["PAT_TEL"]
        PAT_TEL_COUNTRY_CODE <- map["PAT_TEL_COUNTRY_CODE"]
        COMPLETEPATNAME_AR <- map["COMPLETEPATNAME_AR"]
        COMPLETEPATNAME_EN <- map["COMPLETEPATNAME_EN"]
        sER <- map["SER"]
        eXPECTEDDONEDATE <- map["EXPECTEDDONEDATE"]
        cLINIC_ID <- map["CLINIC_ID"]
        cLINIC_NAME_AR <- map["CLINIC_NAME_AR"]
        cLINIC_NAME_EN <- map["CLINIC_NAME_EN"]
        sTATUS_NAME_AR <- map["STATUS_NAME_AR"]
        sTATUS_NAME_EN <- map["STATUS_NAME_EN"]
        dOC_ID <- map["DOC_ID"]
        eMP_AR_DATA <- map["EMP_AR_DATA"]
        eMP_EN_DATA <- map["EMP_EN_DATA"]
        sPECIAL_SPEC_EN_NAME <- map["SPECIAL_SPEC_EN_NAME"]
        sPECIAL_SPEC_AR_NAME <- map["SPECIAL_SPEC_AR_NAME"]
        sHIFT_ID <- map["SHIFT_ID"]
        sCHED_SERIAL <- map["SCHED_SERIAL"]
        sPECIAL_SPEC_ID <- map["SPECIAL_SPEC_ID"]
        hOSP_ID <- map["HOSP_ID"]
        hOSP_NAME_AR <- map["HOSP_NAME_AR"]
        hOSP_NAME_EN <- map["HOSP_NAME_EN"]
        DOC_ID <- map["DOC_ID"]
        QUE_SYS_SER <- map["QUE_SYS_SER"]
        
        sER <- map["SER"]
        eXPECTEDDONEDATE <- map["EXPECTEDDONEDATE"]
        cLINIC_ID <- map["CLINIC_ID"]
        cLINIC_NAME_AR <- map["PLACE_NAME_AR"]
        cLINIC_NAME_EN <- map["PLACE_NAME_EN"]
        sTATUS_NAME_AR <- map["STATUS_NAME_AR"]
        sTATUS_NAME_EN <- map["STATUS_NAME_EN"]
        dOC_ID <- map["DOC_ID"]
        eMP_AR_DATA <- map["EMP_NAME_AR"]
        eMP_EN_DATA <- map["EMP_NAME_EN"]
        sPECIAL_SPEC_EN_NAME <- map["SPECIALITY_NAME_EN"]
        sPECIAL_SPEC_AR_NAME <- map["SPECIALITY_NAME_AR"]
        sHIFT_ID <- map["SHIFT_ID"]
        sCHED_SERIAL <- map["SCHED_SERIAL"]
//        sPECIAL_SPEC_ID <- map["SPECIAL_SPEC_ID"]
        hOSP_ID <- map["HOSP_ID"]
        hOSP_NAME_AR <- map["HOSP_AR_NAME"]
        hOSP_NAME_EN <- map["HOSP_EN_NAME"]
        DOC_ID <- map["DOC_ID"]
        QUE_SYS_SER <- map["QUEUE_SER"]
        DOCTOR_PIC <- map["DOCTOR_PIC"]
        EMP_GENDUR <- map["EMP_GENDUR"]
        DATE_ENTER <- map["DATE_ENTER"]
        DETECT_TYPE <- map["DETECT_TYPE"]
        CallFutureFlag <- map["CALL_FUTURE_FLAG"]

    }
    
}


class RECEIPTSDTO: Mappable {
    var PLACE_EN_NAME : String = ""
    var PAGES_COUNT : String = ""
    var CASH_AMOUNT : String = ""
    var REC_NO : String = ""
    var FINAN_NAME_AR : String = ""
    var VISA_AMOUNT : String = ""
    var VISIT_ID : String = ""
    var FINAN_NAME_EN : String = ""
    var HOSP_RECEIPTNO : String = ""
    var PLACE_AR_NAME : String = ""
    var TRANSDATE : String = ""
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        PLACE_EN_NAME <- map["PLACE_EN_NAME"]
        PAGES_COUNT <- map["PAGES_COUNT"]
        CASH_AMOUNT <- map["CASH_AMOUNT"]
        REC_NO <- map["REC_NO"]
        VISA_AMOUNT <- map["VISA_AMOUNT"]
        TRANSDATE <- map["TRANSDATE"]
        VISIT_ID <- map["VISIT_ID"]
        FINAN_NAME_EN <- map["FINAN_NAME_EN"]
        HOSP_RECEIPTNO <- map["HOSP_RECEIPTNO"]
        PLACE_AR_NAME <- map["PLACE_AR_NAME"]
        FINAN_NAME_AR <- map["FINAN_NAME_AR"]
        

    }
    
}


class invociesDTO: Mappable {
    var PAT_SHARE : String = ""
    var VISIT_ID : String = ""
    var REC_NO : String = ""
    var BILLDATE : String = ""
    var BILLSERIAL : String = ""
    var DOC_NAME_EN : String = ""
    var DOC_NAME_AR : String = ""
    var PAGES_COUNT : String = ""
    var PLACE_AR_NAME : String = ""
    var VISIT_START_DATE : String = ""
    var FINAN_NAME_EN : String = ""
    var VISIT_END_DATE: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        VISIT_END_DATE <- map["VISIT_END_DATE"]
        PAT_SHARE <- map["PAT_SHARE"]
        VISIT_ID <- map["VISIT_ID"]
        REC_NO <- map["REC_NO"]
        BILLDATE <- map["BILLDATE"]
        BILLSERIAL <- map["BILLSERIAL"]
        DOC_NAME_EN <- map["DOC_NAME_EN"]
        DOC_NAME_AR <- map["DOC_NAME_AR"]
        PAGES_COUNT <- map["PAGES_COUNT"]
        VISIT_START_DATE <- map["VISIT_START_DATE"]
    
        FINAN_NAME_EN <- map["FINAN_NAME_EN"]

        
    }
    
}


class GOV_RDTO: Mappable {
    var PAGES_COUNT : String = ""
    var ROW_NUM : String = ""
    var NAME_EN : String = ""
    var NAME_AR : String = ""
    var ID : String = ""
  
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        ID <- map["ID"]
        NAME_AR <- map["NAME_AR"]

        NAME_EN <- map["NAME_EN"]
        PAGES_COUNT <- map["PAGES_COUNT"]
        ROW_NUM <- map["ROW_NUM"]
     
    
        

    }
    
}
class SpecialityOfOtherInfo: Mappable {
    var NAME_AR : String = ""
    var ID : String = ""
    var NAME_EN : String = ""
    
    
  
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        NAME_AR <- map["NAME_AR"]
        ID <- map["ID"]
        NAME_EN <- map["NAME_EN"]
    
        

    }
    
}
class RxModel: Mappable {
    var ROW_NUM : String = ""
    var PAGES_COUNT : String = ""
    var PATIENTID : String = ""
    var PAT_NAME_AR : String = ""
    var PAT_NAME_EN : String = ""
    var VISIT_ID : String = ""
    var MEDPLANCD : String = ""
    var MEDPLANDATE : String = ""
    var PRESC_TYPE : String = ""
    var PRESC_TYPE_AR : String = ""
    var PREC_TYPE_EN : String = ""
    var VISIT_TYPE : String = ""
    var REGULAR_ITEMS_COUNT : String = ""
    var NEED_APPROVAL_ITEMS_COUNT : String = ""
    var APPROVED_ITEMS_COUNT : String = ""
    var DIS_APPROVED_ITEMS_COUNT : String = ""
    var GEN_SERIAL : String = ""
    var DOCID : String = ""
    var DOC_NAME_AR : String = ""
    var DOC_NAME_EN : String = ""
    var VISIT_START_DATE : String = ""
    var VISIT_TYPE_AR : String = ""
    var VISIT_TYPE_EN : String = ""
    var SPECIALTY_NAME_AR: String = ""
    var SPECIALTY_NAME_EN: String = ""
    var HOSP_NAME_AR: String = ""
    var HOSP_NAME_EN: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        HOSP_NAME_AR <- map["HOSP_NAME_AR"]
        HOSP_NAME_EN <- map["HOSP_NAME_EN"]
        SPECIALTY_NAME_AR <- map["SPECIALTY_NAME_AR"]
        SPECIALTY_NAME_EN <- map["SPECIALTY_NAME_EN"]
        ROW_NUM <- map["ROW_NUM"]
        PAGES_COUNT <- map["PAGES_COUNT"]
        PATIENTID <- map["PAGES_COUNT"]
        PAT_NAME_AR <- map["PAT_NAME_AR"]
        PAT_NAME_EN <- map["PAT_NAME_EN"]
        VISIT_ID <- map["VISIT_ID"]
        MEDPLANCD <- map["MEDPLANCD"]
        MEDPLANDATE <- map["MEDPLANDATE"]
        PRESC_TYPE <- map["PRESC_TYPE"]
        PRESC_TYPE_AR <- map["PRESC_TYPE_AR"]
        PREC_TYPE_EN <- map["PREC_TYPE_EN"]
        VISIT_TYPE <- map["VISIT_TYPE"]
        REGULAR_ITEMS_COUNT <- map["REGULAR_ITEMS_COUNT"]
        NEED_APPROVAL_ITEMS_COUNT <- map["NEED_APPROVAL_ITEMS_COUNT"]
        APPROVED_ITEMS_COUNT <- map["APPROVED_ITEMS_COUNT"]
        DIS_APPROVED_ITEMS_COUNT <- map["DIS_APPROVED_ITEMS_COUNT"]
        DOCID <- map["DOCID"]
        DOC_NAME_AR <- map["DOC_NAME_AR"]
        DOC_NAME_EN <- map["DOC_NAME_EN"]
        VISIT_START_DATE <- map["VISIT_START_DATE"]
        VISIT_TYPE_AR <- map["VISIT_TYPE_AR"]
        VISIT_TYPE_EN <- map["VISIT_TYPE_EN"]
        GEN_SERIAL <- map["GEN_SERIAL"]

    }
    
}

              
           
                 
               
class RxModelDetails: Mappable {
    var ROW_NUM : String = ""
    var PAGES_COUNT : String = ""
    var ITEMCODE : String = ""
    var ITEM_NAME_AR : String = ""
    var ITEM_NAME_EN : String = ""
    var NOTES_AR : String = ""
    var NOTES_EN : String = ""
    var TRANSDATE : String = ""
    var EMP_ID : String = ""
    var EMP_NAME_AR : String = ""
    var EMP_NAME_EN : String = ""
    var APPROVE_ID : String = ""
    var APPROVE_NAME_AR : String = ""
    var APPROVE_NAME_EN : String = ""
    var DRUG_IMAGE: String = ""
    var GEN_SERIAL_ITEM: String = ""
    var ITEM_STATUS: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        ITEM_STATUS <- map["ITEM_STATUS"]
        GEN_SERIAL_ITEM <- map["GEN_SERIAL_ITEM"]
        ROW_NUM <- map["ROW_NUM"]
        PAGES_COUNT <- map["PAGES_COUNT"]
        ITEMCODE <- map["ITEMCODE"]
        ITEM_NAME_AR <- map["ITEM_NAME_AR"]
        ITEM_NAME_EN <- map["ITEM_NAME_EN"]
        NOTES_AR <- map["NOTES_AR"]
        NOTES_EN <- map["NOTES_EN"]
        TRANSDATE <- map["TRANSDATE"]
        EMP_ID <- map["EMP_ID"]
        EMP_NAME_AR <- map["EMP_NAME_AR"]
        EMP_NAME_EN <- map["EMP_NAME_EN"]
        APPROVE_ID <- map["APPROVE_ID"]
        APPROVE_NAME_AR <- map["APPROVE_NAME_AR"]
        APPROVE_NAME_EN <- map["APPROVE_NAME_EN"]
        DRUG_IMAGE <- map["DRUG_IMAGE"]

    }
    
}

class historyModel: Mappable {
    var HISTORY_ID : String = ""
    var DESC_EN : String = ""
    var TRANS_DATE : String = ""
    var USER_ID : String = ""
    var USER_NAME_AR : String = ""
    var USER_NAME_EN : String = ""
    var VISIT_ID : String = ""
    var VISIT_START_DATE : String = ""
    var VISIT_END_DATE : String = ""
    var VISIT_EMP_NAME_AR : String = ""
    var VISIT_EMP_NAME_EN : String = ""
    var VISIT_SPECIALITY_NAME_AR : String = ""
    var VISIT_SPECIALITY_NAME_EN : String = ""
    var H_PRESENT_FLAG : String = ""
    var H_PAST_FLAG : String = ""
    var H_FAMILY_FLAG : String = ""

    

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        HISTORY_ID <- map["HISTORY_ID"]
        DESC_EN <- map["DESC_EN"]
        TRANS_DATE <- map["TRANS_DATE"]
        USER_ID <- map["USER_ID"]
        USER_NAME_AR <- map["USER_NAME_AR"]
        USER_NAME_EN <- map["USER_NAME_EN"]
        VISIT_ID <- map["VISIT_ID"]
        VISIT_START_DATE <- map["VISIT_START_DATE"]
        VISIT_END_DATE <- map["VISIT_END_DATE"]
        VISIT_EMP_NAME_AR <- map["VISIT_EMP_NAME_AR"]
        VISIT_EMP_NAME_EN <- map["VISIT_EMP_NAME_EN"]
        VISIT_SPECIALITY_NAME_AR <- map["VISIT_SPECIALITY_NAME_AR"]
        VISIT_SPECIALITY_NAME_EN <- map["VISIT_SPECIALITY_NAME_EN"]
        H_PRESENT_FLAG <- map["H_PRESENT_FLAG"]
        H_PAST_FLAG <- map["H_PAST_FLAG"]
        H_FAMILY_FLAG <- map["H_FAMILY_FLAG"]


    }
    
}



           
             
               
class diagnosisModel: Mappable {
    var CODE : String = ""
    var ITEM_DESC : String = ""
    var STATUS_NAME_AR : String = ""
    var STATUS_NAME_EN : String = ""

    var DOC_NAME_AR : String = ""

    var DOC_NAME_EN : String = ""
    var SPECIALITY_NAME_AR : String = ""
    var SPECIALITY_NAME_EN : String = ""
    var LAST_MOSD_DATE : String = ""
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        CODE <- map["CODE"]
        ITEM_DESC <- map["ITEM_DESC"]
        STATUS_NAME_AR <- map["STATUS_NAME_AR"]
        STATUS_NAME_EN <- map["STATUS_NAME_EN"]
        DOC_NAME_AR <- map["DOC_NAME_AR"]
        DOC_NAME_EN <- map["DOC_NAME_EN"]
        SPECIALITY_NAME_AR <- map["SPECIALITY_NAME_AR"]
        SPECIALITY_NAME_EN <- map["SPECIALITY_NAME_EN"]
        LAST_MOSD_DATE <- map["LAST_MOSD_DATE"]
    } 
}

class allergyModel: Mappable {
    var ID : String = ""
    var DESC_AR : String = ""
    var DESC_EN : String = ""
    var SORT_TYPE : String = ""
    var DATE_START : String = ""

    var DATE_END : String = ""

    var COMMENTS : String = ""
    var TRANS_DATE : String = ""

    var USER_ID : String = ""
    var ALLERGY_TYPE_NAME_AR : String = ""

    var ALLERGY_TYPE_NAME_EN : String = ""
    var LAST_ROW : String = ""

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        ID <- map["ID"]
        DESC_AR <- map["DESC_AR"]
        DESC_EN <- map["DESC_EN"]
        SORT_TYPE <- map["SORT_TYPE"]
        DATE_START <- map["DATE_START"]
        DATE_END <- map["DATE_END"]
        COMMENTS <- map["COMMENTS"]
        TRANS_DATE <- map["TRANS_DATE"]
        USER_ID <- map["USER_ID"]
        ALLERGY_TYPE_NAME_AR <- map["ALLERGY_TYPE_NAME_AR"]
        ALLERGY_TYPE_NAME_EN <- map["ALLERGY_TYPE_NAME_EN"]
        LAST_ROW <- map["LAST_ROW"]
    }
    
}

                 
              
class ReportRequestsModel: Mappable {
    var HOSP_ID : String = ""
    var SERIAL : String = ""
    var PATIENTID : String = ""
    var VISIT_ID : String = ""
    var PAT_MED_REP_SER : String = ""
    var REPORT_TEMPLATE_CODE : String = ""
    var REP_TYPE : String = ""
    var DOCTOR_ID : String = ""
    var NEED_SIGN : String = ""
    var DELIGATED_PERSON : String = ""
    var NOTES : String = ""
    var CASHIER_FLAG : String = ""
    var RECEIPT_NO : String = ""
    var ACTION_SER : String = ""
    var ENTRY_USERID : String = ""
    var ENTRY_DATE : String = ""
    var UPDATE_USERID : String = ""
    var UPDATE_DATE : String = ""
    var VISIT_ID_FOR_REPORT : String = ""
    var PAT_NAME_AR : String = ""
    var PAT_NAME_EN : String = ""
    var DOC_NAME_AR : String = ""
    var DOC_NAME_EN : String = ""
    var TEMP_DESC_AR : String = ""
    var TEMP_DESC_EN : String = ""
    var STATUS_AR : String = ""
    var STATUS_EN : String = ""
    var NEED_SIGN_AR : String = ""
    var NEED_SIGN_EN : String = ""
    var PATFINANACCOUNT : String = ""
    var REQ_SOURCE : String = ""
    var SHOW_CHARGE_BUTTON : String = ""
    var SPECIALITY_NAME_AR: String = ""
    var SPECIALITY_NAME_EN: String = ""
    var VISIT_START_DATE: String = ""
    var VISIT_TYPE_AR: String = ""
    var VISIT_TYPE_EN: String = ""
    var BRANCH_NAME_AR: String = ""
    var BRANCH_NAME_EN: String = ""
    var IS_FILE_SCANNED: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        IS_FILE_SCANNED <- map["IS_FILE_SCANNED"]
        BRANCH_NAME_AR <- map["BRANCH_NAME_AR"]
        BRANCH_NAME_EN <- map["BRANCH_NAME_EN"]
        VISIT_TYPE_EN <- map["VISIT_TYPE_EN"]
        VISIT_TYPE_AR <- map["VISIT_TYPE_AR"]
        VISIT_START_DATE <- map["VISIT_START_DATE"]
        SPECIALITY_NAME_AR <- map["SPECIALITY_NAME_AR"]
        SPECIALITY_NAME_EN <- map["SPECIALITY_NAME_EN"]
        HOSP_ID <- map["HOSP_ID"]
        SERIAL <- map["SERIAL"]
        PATIENTID <- map["PATIENTID"]
        VISIT_ID <- map["VISIT_ID"]
        PAT_MED_REP_SER <- map["PAT_MED_REP_SER"]
        REPORT_TEMPLATE_CODE <- map["REPORT_TEMPLATE_CODE"]
        REP_TYPE <- map["REPORT_TEMPLATE_CODE"]
        DOCTOR_ID <- map["DOCTOR_ID"]
        NEED_SIGN <- map["NEED_SIGN"]
        DELIGATED_PERSON <- map["DELIGATED_PERSON"]
        NOTES <- map["NOTES"]
        CASHIER_FLAG <- map["CASHIER_FLAG"]
        RECEIPT_NO <- map["RECEIPT_NO"]
        ACTION_SER <- map["ACTION_SER"]
        ENTRY_USERID <- map["ENTRY_USERID"]
        ENTRY_DATE <- map["ENTRY_DATE"]
        UPDATE_USERID <- map["UPDATE_USERID"]
        UPDATE_DATE <- map["UPDATE_DATE"]
        VISIT_ID_FOR_REPORT <- map["VISIT_ID_FOR_REPORT"]
        PAT_NAME_AR <- map["PAT_NAME_AR"]
        PAT_NAME_EN <- map["PAT_NAME_EN"]
        DOC_NAME_AR <- map["VISIT_DOC_NAME_AR"]
        DOC_NAME_EN <- map["VISIT_DOC_NAME_EN"]
        TEMP_DESC_AR <- map["TEMP_DESC_AR"]
        TEMP_DESC_EN <- map["TEMP_DESC_EN"]
        STATUS_AR <- map["STATUS_AR"]
        STATUS_EN <- map["STATUS_EN"]
        NEED_SIGN_AR <- map["NEED_SIGN_AR"]
        NEED_SIGN_EN <- map["NEED_SIGN_EN"]
        PATFINANACCOUNT <- map["PATFINANACCOUNT"]
        REQ_SOURCE <- map["REQ_SOURCE"]
        SHOW_CHARGE_BUTTON <- map["SHOW_CHARGE_BUTTON"]

    }
    
}
     
       
 
class cancelReason: Mappable {
    var NAME_AR : String = ""
    var ID : String = ""
    var NAME_EN : String = ""


    init(NAME_AR:String, ID:String,NAME_EN:String) {
           self.NAME_AR = NAME_AR
           self.ID = ID
           self.NAME_EN = NAME_EN
       }

    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        NAME_AR <- map["NAME_AR"]
        ID <- map["ID"]
        NAME_EN <- map["NAME_EN"]
    }
    
}
