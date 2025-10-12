//
//  LabRadDTO.swift
//  CareMate
//
//  Created by Yo7ia on 1/1/19.
//  Copyright © 2019 khabeer Group. All rights reserved.
//

import Foundation
import ObjectMapper

struct LabRadDTO : Mappable {
    var rEC_NO : String = ""
    var pAGES_COUNT : String = ""
    var rEQ_ID : String = ""
    var vISIT_ID : String = ""
    var aCCESSION_NO : String = ""
    var lAB_SERV_RESULT_CLINIC : String = ""
    var rEQ_DATE : String = ""
    var dELIV_DATE : String = ""
    var uSERID : String = ""
    var sERVICE_ID : String = ""
    var cLINIC_WRITTEN : String = ""
    var sAMPLEID : String = ""
    var pATHOLOGY_SERV : String = ""
    var mICROBIOLOGY_SERV : String = ""
    var eMP_ID : String = ""
    var eMP_AR_DATA : String = ""
    var eMP_EN_DATA : String = ""
    var eMERGENCY : String = ""
    var sERVSTATUS : String = ""
    var rESULT_COMMENT : String = ""
    var uNDO_LOG : String = ""
    var sEEN_DOCTOR : String = ""
    var sEEN_NURSE : String = ""
    var fREQ : String = ""
    var dURUNIT : String = ""
    var aBNORMAL_RESULT : String = ""
    var dURATION : String = ""
    var cASHIER_FLAG : String = ""
    var sERVICE_NAME_AR : String = ""
    var sERVICE_NAME_EN : String = ""
    var pATH_REP_STATUS : String = ""
    var pLACE_NAME_AR : String = ""
    var pLACE_NAME_EN : String = ""
    var pENDING_ORDERS_COUNT : String = ""
    var nORMAL_ORDERS_COUNT : String = ""
    var aBNORMAL_ORDERS_COUNT : String = ""
    var nOTSEEN_NORMAL_ORDERS_COUNT : String = ""
    var nOTSEEN_ABNORMAL_ORDERS_COUNT : String = ""
    var tOTAL_ORDERS_COUNT : String = ""
    var fREQUNCY_NAME_AR : String = ""
    var fREQUNCY_NAME_EN : String = ""
    var nORMALSTATUS_NAME_AR : String = ""
    var nORMALSTATUS_NAME_EN : String = ""
    var lABSTATUS_NAME_AR : String = ""
    var lABSTATUS_NAME_EN : String = ""
    var rADSTATUS_NAME_AR : String = ""
    var rADSTATUS_NAME_EN : String = ""
    var cAN_CANCEL_SERV : String = ""
    var pATH_REP_STATUS_NAME_AR : String = ""
    var pATH_REP_STATUS_NAME_EN : String = ""
    var PREPARE_DESC_AR : String = ""
    var PREPARE_DESC_EN : String = ""
    var readMore = false
    var SPECIALITY_NAME_EN: String = ""
    var SPECIALITY_NAME_AR: String = ""
    var BRANCHID: String = ""
    var VISIT_TYPE_NAME_AR: String = ""
    var VISIT_TYPE_NAME_EN: String = ""
    var VISIT_START_DATE: String = ""
    var BRANCH_NAME_AR: String = ""
    var BRANCH_NAME_EN: String = ""
    var EXT_SCAN: String = ""
    var CHILD_ACCESSION_NOS:String = ""
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        EXT_SCAN <- map["EXT_SCAN"]
        BRANCH_NAME_EN <- map["BRANCH_NAME_EN"]
        BRANCH_NAME_AR <- map["BRANCH_NAME_AR"]
        VISIT_START_DATE <- map["VISIT_START_DATE"]
        VISIT_TYPE_NAME_AR <- map["VISIT_TYPE_NAME_AR"]
        VISIT_TYPE_NAME_EN <- map["VISIT_TYPE_NAME_EN"]
        BRANCHID <- map["BRANCHID"]
        SPECIALITY_NAME_EN <- map["SPECIALITY_NAME_EN"]
        SPECIALITY_NAME_AR <- map["SPECIALITY_NAME_AR"]
        PREPARE_DESC_AR <- map["PREPARE_DESC_AR"]
        PREPARE_DESC_EN <- map["PREPARE_DESC_EN"]
        rEC_NO <- map["REC_NO"]
        pAGES_COUNT <- map["PAGES_COUNT"]
        rEQ_ID <- map["REQ_ID"]
        vISIT_ID <- map["VISIT_ID"]
        aCCESSION_NO <- map["ACCESSION_NO"]
        lAB_SERV_RESULT_CLINIC <- map["LAB_SERV_RESULT_CLINIC"]
        rEQ_DATE <- map["REQ_DATE"]
        dELIV_DATE <- map["DELIV_DATE"]
        uSERID <- map["USERID"]
        sERVICE_ID <- map["SERVICE_ID"]
        cLINIC_WRITTEN <- map["CLINIC_WRITTEN"]
        sAMPLEID <- map["SAMPLEID"]
        pATHOLOGY_SERV <- map["PATHOLOGY_SERV"]
        mICROBIOLOGY_SERV <- map["MICROBIOLOGY_SERV"]
        eMP_ID <- map["EMP_ID"]
        eMP_AR_DATA <- map["EMP_AR_DATA"]
        eMP_EN_DATA <- map["EMP_EN_DATA"]
        eMERGENCY <- map["EMERGENCY"]
        sERVSTATUS <- map["SERVSTATUS"]
        rESULT_COMMENT <- map["RESULT_COMMENT"]
        uNDO_LOG <- map["UNDO_LOG"]
        sEEN_DOCTOR <- map["SEEN_DOCTOR"]
        sEEN_NURSE <- map["SEEN_NURSE"]
        fREQ <- map["FREQ"]
        dURUNIT <- map["DURUNIT"]
        aBNORMAL_RESULT <- map["ABNORMAL_RESULT"]
        dURATION <- map["DURATION"]
        cASHIER_FLAG <- map["CASHIER_FLAG"]
        sERVICE_NAME_AR <- map["SERVICE_NAME_AR"]
        sERVICE_NAME_EN <- map["SERVICE_NAME_EN"]
        pATH_REP_STATUS <- map["PATH_REP_STATUS"]
        pLACE_NAME_AR <- map["PLACE_NAME_AR"]
        pLACE_NAME_EN <- map["PLACE_NAME_EN"]
        pENDING_ORDERS_COUNT <- map["PENDING_ORDERS_COUNT"]
        nORMAL_ORDERS_COUNT <- map["NORMAL_ORDERS_COUNT"]
        aBNORMAL_ORDERS_COUNT <- map["ABNORMAL_ORDERS_COUNT"]
        nOTSEEN_NORMAL_ORDERS_COUNT <- map["NOTSEEN_NORMAL_ORDERS_COUNT"]
        nOTSEEN_ABNORMAL_ORDERS_COUNT <- map["NOTSEEN_ABNORMAL_ORDERS_COUNT"]
        tOTAL_ORDERS_COUNT <- map["TOTAL_ORDERS_COUNT"]
        fREQUNCY_NAME_AR <- map["FREQUNCY_NAME_AR"]
        fREQUNCY_NAME_EN <- map["FREQUNCY_NAME_EN"]
        nORMALSTATUS_NAME_AR <- map["NORMALSTATUS_NAME_AR"]
        nORMALSTATUS_NAME_EN <- map["NORMALSTATUS_NAME_EN"]
        lABSTATUS_NAME_AR <- map["LABSTATUS_NAME_AR"]
        lABSTATUS_NAME_EN <- map["LABSTATUS_NAME_EN"]
        rADSTATUS_NAME_AR <- map["RADSTATUS_NAME_AR"]
        rADSTATUS_NAME_EN <- map["RADSTATUS_NAME_EN"]
        cAN_CANCEL_SERV <- map["CAN_CANCEL_SERV"]
        pATH_REP_STATUS_NAME_AR <- map["PATH_REP_STATUS_NAME_AR"]
        pATH_REP_STATUS_NAME_EN <- map["PATH_REP_STATUS_NAME_EN"]
        CHILD_ACCESSION_NOS <- map["CHILD_ACCESSION_NOS"]
    }
    
}
