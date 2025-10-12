//
//  AppointmentDTO.swift
//  CareMate
//
//  Created by Yo7ia on 12/31/18.
//  Copyright © 2018 khabeer Group. All rights reserved.
//
import ObjectMapper
import Foundation
class getCurrentMedDTO: Mappable {

    var ENDDATE : String = ""
    var GEN_SERIAL_ITEM : String = ""
    var ITEMARNAME : String = ""
    var ITEMCODE : String = ""
    var ITEMENNAME : String = ""
    var NOTES : String = ""
    var NOTES_EN : String = ""
    var STARTDATE : String = ""
    var DRUG_IMAGE: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        ENDDATE <- map["ENDDATE"]
        GEN_SERIAL_ITEM <- map["GEN_SERIAL_ITEM"]
        ITEMARNAME <- map["ITEMARNAME"]
        ITEMCODE <- map["ITEMCODE"]
        ITEMENNAME <- map["ITEMENNAME"]
        NOTES <- map["NOTES"]
        NOTES_EN <- map["NOTES_EN"]
        STARTDATE <- map["STARTDATE"]
        DRUG_IMAGE <- map["DRUG_IMAGE"]
        
    }
    
}


