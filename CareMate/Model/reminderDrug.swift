//
//  reminderDrug.swift
//  CareMate
//
//  Created by khabeer on 11/30/19.
//  Copyright © 2019 khabeer Group. All rights reserved.
//

import Foundation
import RealmSwift

class reminderDrug:Object{
   @objc dynamic  var date:String = ""
    @objc dynamic  var allDate:String = ""
    @objc dynamic  var take:String = ""


    @objc dynamic  var drugName:String = ""
    @objc dynamic var drugdose:String = ""
    @objc dynamic var drugdoseEn:String = ""
    @objc dynamic var dateALL:String = ""
    @objc dynamic  var drugNameEn:String = ""
    

}
class reminderDrugCopyForLocalNotifcation:Object{
    @objc dynamic  var date:String = ""
    @objc dynamic  var allDate:String = ""
    @objc dynamic  var take:String = ""
//  @objc dynamic var drugNameEn: String = ""
//  @objc dynamic var drugdoseEn: String = ""
    @objc dynamic  var drugName:String = ""
    @objc dynamic var drugdose:String = ""
    @objc dynamic var dateALL:String = ""
//    @objc dynamic var genID:String = ""


    
    
}

