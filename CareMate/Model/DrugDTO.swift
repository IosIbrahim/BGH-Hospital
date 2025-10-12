//
//  DrugDTO.swift
//  CareMate
//
//  Created by Yo7ia on 1/1/19.
//  Copyright © 2019 khabeer Group. All rights reserved.
//

import Foundation
import ObjectMapper

struct DrugDTO : Mappable {
    var iD : String = ""
    var nAME_AR : String = ""
    var nAME_EN : String = ""
    var mEDPLANCD : String = ""
    var mEDPLANDATE : String = ""
    var pRESC_TYPE : String = ""
    var pRESC_TYPE_NAME_AR : String = ""
    var pRESC_TYPE_NAME_EN : String = ""
    var nOTES_AR : String = ""
    var nOTES_EN : String = ""
    var rEMARKS : String = ""
    var fREQCODE : String = ""
    var dOSAGE : String = ""
    var dOS_TYPE : String = ""
    var dURATIONUNIT : String = ""
    var dURATION : String = ""
    var rOUTE : String = ""
    var rANGE : String = ""
    var sTARTDATE : String = ""
    var eNDDATE : String = ""
    var gEN_SERIAL_ITEM : String = ""
    var rEVISED : String = ""
    var uSERID : String = ""
    var tOT_SMALL_EXPANDED : String = ""
    var tOT_SMALL_QTY : String = ""
    var iTEM_STATUS : String = ""
    var lAST_DOSAGE : String = ""
    var uSER_NAME_AR : String = ""
    var uSER_NAME_EN : String = ""
    var dOC_NAME_AR : String = ""
    var dOC_NAME_EN : String = ""
    var tRANSDATE : String = ""
    var vISIT_ID : String = ""
    var rEAPETED : String = ""
    var nO_MONTHS : String = ""
    var nO_MONTHES_EXPANDED : String = ""
    var sTOPPED : String = ""
    var iTEM_STATUS_ID : String = ""
    var iTEM_STATUS_NAME_AR : String = ""
    var iTEM_STATUS_NAME_EN : String = ""
    
    init?(map: Map) {
        
    }
    
   mutating func mapping(map: Map) {
        
        iD <- map["ID"]
        nAME_AR <- map["NAME_AR"]
        nAME_EN <- map["NAME_EN"]
        mEDPLANCD <- map["MEDPLANCD"]
        mEDPLANDATE <- map["MEDPLANDATE"]
        pRESC_TYPE <- map["PRESC_TYPE"]
        pRESC_TYPE_NAME_AR <- map["PRESC_TYPE_NAME_AR"]
        pRESC_TYPE_NAME_EN <- map["PRESC_TYPE_NAME_EN"]
        nOTES_AR <- map["NOTES_AR"]
        nOTES_EN <- map["NOTES_EN"]
        rEMARKS <- map["REMARKS"]
        fREQCODE <- map["FREQCODE"]
        dOSAGE <- map["DOSAGE"]
        dOS_TYPE <- map["DOS_TYPE"]
        dURATIONUNIT <- map["DURATIONUNIT"]
        dURATION <- map["DURATION"]
        rOUTE <- map["ROUTE"]
        rANGE <- map["RANGE"]
        sTARTDATE <- map["STARTDATE"]
        eNDDATE <- map["ENDDATE"]
        gEN_SERIAL_ITEM <- map["GEN_SERIAL_ITEM"]
        rEVISED <- map["REVISED"]
        uSERID <- map["USERID"]
        tOT_SMALL_EXPANDED <- map["TOT_SMALL_EXPANDED"]
        tOT_SMALL_QTY <- map["TOT_SMALL_QTY"]
        iTEM_STATUS <- map["ITEM_STATUS"]
        lAST_DOSAGE <- map["LAST_DOSAGE"]
        uSER_NAME_AR <- map["USER_NAME_AR"]
        uSER_NAME_EN <- map["USER_NAME_EN"]
        dOC_NAME_AR <- map["DOC_NAME_AR"]
        dOC_NAME_EN <- map["DOC_NAME_EN"]
        tRANSDATE <- map["TRANSDATE"]
        vISIT_ID <- map["VISIT_ID"]
        rEAPETED <- map["REAPETED"]
        nO_MONTHS <- map["NO_MONTHS"]
        nO_MONTHES_EXPANDED <- map["NO_MONTHES_EXPANDED"]
        sTOPPED <- map["STOPPED"]
        iTEM_STATUS_ID <- map["ITEM_STATUS_ID"]
        iTEM_STATUS_NAME_AR <- map["ITEM_STATUS_NAME_AR"]
        iTEM_STATUS_NAME_EN <- map["ITEM_STATUS_NAME_EN"]
    }
    
}


struct LabReportDTO : Mappable {
    var iTEMID : String = ""
    var iTEMDDESCR : String = ""
    var uPNORMAL_VAL : String = ""
    var rESULT_LAB : String = ""
    var rEFERENCE_DATA : String = ""
    var sAMPLE_UPNORMAL_VAL : String = ""
    var dELTA_CHECK : String = ""
    var rES_CHANGE_DELTA : String = ""
    var uPNORMAL_NAME_AR : String = ""
    var uPNORMAL_NAME_EN : String = ""
    var aCCESSION_NO : String = ""
    var rEQUEST_DETAIL : String = ""
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        iTEMID <- map["ITEMID"]
        iTEMDDESCR <- map["ITEMDDESCR"]
        uPNORMAL_VAL <- map["UPNORMAL_VAL"]
        rESULT_LAB <- map["RESULT_LAB"]
        rEFERENCE_DATA <- map["REFERENCE_DATA"]
        sAMPLE_UPNORMAL_VAL <- map["SAMPLE_UPNORMAL_VAL"]
        dELTA_CHECK <- map["DELTA_CHECK"]
        rES_CHANGE_DELTA <- map["RES_CHANGE_DELTA"]
        uPNORMAL_NAME_AR <- map["UPNORMAL_NAME_AR"]
        uPNORMAL_NAME_EN <- map["UPNORMAL_NAME_EN"]
        aCCESSION_NO <- map["ACCESSION_NO"]
        rEQUEST_DETAIL <- map["REQUEST_DETAIL"]
    }
}
